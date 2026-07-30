"""
Visualización 2D de la grúa portacontenedores STS con conexión Simulink (UDP).
Geometría derivada de MATLAB_SIMULINK/parametros.m
"""

import socket
import struct
import threading
import time
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import matplotlib.animation as animation
from matplotlib.patches import FancyArrowPatch

# ─── Parámetros del sistema (de parametros.m) ───────────────────────────────
Y_t0      = 45.0   # [m] Altura fija de poleas en el carro
H_c       = 2.59   # [m] Altura del container
W_c       = 2.44   # [m] Ancho del container
Y_sb      = 5.0    # [m] Despeje sobre borde de muelle

x_t_min   = -30.0  # [m] Límite mínimo de traslación del carro
x_t_max   =  50.0  # [m] Límite máximo de traslación del carro
y_h_min   = -20.0  # [m] Límite mínimo de izaje (dentro del barco)
y_h_max   =  40.0  # [m] Límite máximo de izaje

l_h_min   = Y_t0 - y_h_max   # = 5  m
l_h_max   = Y_t0 - y_h_min   # = 65 m

# ─── Estado del sistema (valores de demo) ───────────────────────────────────
x_t       = 20.0   # [m] Posición del carro (sobre el barco)
l_h       = 28.0   # [m] Longitud de cable de izaje
theta_l   = np.deg2rad(6.0)  # [rad] Ángulo de balanceo
modo               = 'AUTOMÁTICO'  # 'AUTOMÁTICO' | 'MANUAL'
SIMULINK_CONNECTED = False          # True cuando hay conexión activa con Simulink

# ─── Conexión UDP con Simulink ───────────────────────────────────────────────
SIM_UDP_IP      = '127.0.0.1'
SIM_UDP_PORT    = 5010
SIM_UDP_FMT     = '<d'          # double little-endian (default Simulink UDP Send)
SIM_TIMEOUT_S   = 1.0           # sin paquete → desconectado
SIM_UPDATE_MS   = 33            # intervalo de animación [ms]  ≈ 30 fps


# ─── Conexión UDP con contenedores en barco ──────────────────────────────────
CONT_UDP_PORT   = 5011          # vector de 9 doubles: cantidad de containers por posición
CONT_X_POSITIONS = list(np.linspace(1.5, 48.5, 19))  # [m] 19 posiciones en el barco
CONT_MAX_STACK   = 30           # máximo pre-alocado (−20 + 30×2.59 = 57.7 m, hasta el boom)

_cont_lock  = threading.Lock()
_cont_state = {'counts': [0] * 9, 'connected': False, 'last_rx': 0.0}

def _containers_receiver():
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind(('127.0.0.1', CONT_UDP_PORT))
    sock.settimeout(0.5)
    print(f"[Containers] Escuchando UDP en 127.0.0.1:{CONT_UDP_PORT}")
    while True:
        try:
            data, _ = sock.recvfrom(256)
            if len(data) == 72:   # 9 doubles
                vals = struct.unpack('<9d', data)
                with _cont_lock:
                    _cont_state['counts']    = [max(0, int(round(v))) for v in vals]
                    _cont_state['connected'] = True
                    _cont_state['last_rx']   = time.monotonic()
        except socket.timeout:
            with _cont_lock:
                if time.monotonic() - _cont_state['last_rx'] > 2.0:
                    _cont_state['connected'] = False
        except Exception as e:
            print(f"[Containers] Error receptor: {e}")

threading.Thread(target=_containers_receiver, daemon=True).start()

# ─── Conexión UDP con controller_reader ──────────────────────────────────────
CTRL_UDP_PORT   = 5006          # controller_reader envía mirror aquí
CTRL_UDP_FMT    = '!ffBBBBBB'  # trolley_cmd, hoist_cmd, system_on, mode_auto,
                                #   twistlock_closed, sway_ctrl, emergency, emgy_ack
CTRL_TIMEOUT_S  = 1.0

_ctrl_lock = threading.Lock()   
_ctrl_state = {
    'trolley_cmd':      0.0,
    'hoist_cmd':        0.0,
    'system_on':        True,
    'mode_auto':        True,    # modo AUTOMÁTICO
    'twistlock_closed': True,    # TLK cerrado (carga enganchada)
    'sway_ctrl':        True,    # controlador de balanceo activo
    'emergency':        False,
    'emgy_ack':         False,
    'connected':        False,
    'last_rx':          0.0,
}

_sim_lock = threading.Lock()
_sim_state = {
    'x_t_sim':     x_t,     # posición simulada del carro [m]
    'theta_l_sim': theta_l, # ángulo de balanceo simulado [rad] 
    'l_h_sim':     l_h,     # longitud de cable simulada [m]
    'BRK_t':       False,   # freno de traslación
    'BRK_h':       False,   # freno de operación izaje
    'BRK_hE':      False,   # freno de emergencia izaje
    'TLK':         False,    # twistlock (carga enganchada)
    'SWAY_CTR':    True,    # controlador de balanceo activo
    'x_t_est':     x_t,    # posición estimada del carro [m]
    'y_c0_lidar':  0.0,    # altura medida por LIDAR [m]
    'trucks':      [1, 1, 1, 1, 1],  # presencia de camiones (0=ausente, 1=presente)
    'truck_loads': [1, 1, 1, 1, 1],  # carga en camión (0=vacío, 1=con container)
    'escenario':   -1,                # -1=no informado 0=espera 1=carga 2=descarga 3=doble
    'F_hw':          0.0,              # [N] fuerza medida por sensor en cable de izaje
    'modo':          0,               # 0=manual 1=automático
    'masa_estimada': 0.0,             # [kg] masa estimada de la carga
    'connected': False,
    'last_rx':   0.0,
}

def _simulink_receiver():
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind((SIM_UDP_IP, SIM_UDP_PORT))
    sock.settimeout(0.5)
    print(f"[Simulink] Escuchando UDP en {SIM_UDP_IP}:{SIM_UDP_PORT}")
    while True:
        try:
            data, addr = sock.recvfrom(512)
            n = len(data)
            with _sim_lock:
                if n == 72:
                    # 9 doubles: x_t_sim, theta_l_sim, l_sim, BRK_t, BRK_h, BRK_hE, TLK, sway_ctr, y_c0_lidar
                    xt, thl, lh, brk_t, brk_h, brk_he, tlk, sway, ylidar = struct.unpack('<9d', data)
                    _sim_state['x_t_sim']     = float(xt)
                    _sim_state['theta_l_sim'] = float(thl)
                    _sim_state['l_h_sim']     = float(lh)
                    _sim_state['BRK_t']       = bool(brk_t)
                    _sim_state['BRK_h']       = bool(brk_h)
                    _sim_state['BRK_hE']      = bool(brk_he)
                    _sim_state['TLK']         = bool(tlk)
                    _sim_state['SWAY_CTR']    = bool(sway)
                    _sim_state['y_c0_lidar']  = float(ylidar)
                elif n == 64:
                    # 8 doubles: sin x_t_est ni y_c0_lidar
                    xt, thl, lh, brk_t, brk_h, brk_he, tlk, sway = struct.unpack('<8d', data)
                    _sim_state['x_t_sim']     = float(xt)
                    _sim_state['theta_l_sim'] = float(thl)
                    _sim_state['l_h_sim']     = float(lh)
                    _sim_state['BRK_t']       = bool(brk_t)
                    _sim_state['BRK_h']       = bool(brk_h)
                    _sim_state['BRK_hE']      = bool(brk_he)
                    _sim_state['TLK']         = bool(tlk)
                    _sim_state['SWAY_CTR']    = bool(sway)
                elif n == 336:
                    # 42 doubles: 41 anteriores + masa_estimada
                    vals = struct.unpack('<42d', data)
                    xt, thl, lh, brk_t, brk_h, brk_he, tlk, sway, ylidar = vals[:9]
                    cnt_vals  = vals[9:28]
                    trk_vals  = vals[28:33]
                    load_vals = vals[33:38]
                    _sim_state['x_t_sim']       = float(xt)
                    _sim_state['theta_l_sim']   = float(thl)
                    _sim_state['l_h_sim']       = float(lh)
                    _sim_state['BRK_t']         = bool(brk_t)
                    _sim_state['BRK_h']         = bool(brk_h)
                    _sim_state['BRK_hE']        = bool(brk_he)
                    _sim_state['TLK']           = bool(tlk)
                    _sim_state['SWAY_CTR']      = bool(sway)
                    _sim_state['y_c0_lidar']    = float(ylidar)
                    _sim_state['trucks']        = [bool(v) for v in trk_vals]
                    _sim_state['truck_loads']   = [bool(v) for v in load_vals]
                    _sim_state['escenario']     = int(round(vals[38]))
                    _sim_state['F_hw']          = float(vals[39])
                    _sim_state['modo']          = int(round(vals[40]))
                    _sim_state['masa_estimada'] = float(vals[41])
                    with _cont_lock:
                        _cont_state['counts']    = [max(0, int(round(x))) for x in cnt_vals]
                        _cont_state['last_rx']   = time.monotonic()
                elif n == 328:
                    # 41 doubles: 39 anteriores + F_hw + modo
                    vals = struct.unpack('<41d', data)
                    xt, thl, lh, brk_t, brk_h, brk_he, tlk, sway, ylidar = vals[:9]
                    cnt_vals  = vals[9:28]
                    trk_vals  = vals[28:33]
                    load_vals = vals[33:38]
                    _sim_state['x_t_sim']     = float(xt)
                    _sim_state['theta_l_sim'] = float(thl)
                    _sim_state['l_h_sim']     = float(lh)
                    _sim_state['BRK_t']       = bool(brk_t)
                    _sim_state['BRK_h']       = bool(brk_h)
                    _sim_state['BRK_hE']      = bool(brk_he)
                    _sim_state['TLK']         = bool(tlk)
                    _sim_state['SWAY_CTR']    = bool(sway)
                    _sim_state['y_c0_lidar']  = float(ylidar)
                    _sim_state['trucks']      = [bool(v) for v in trk_vals]
                    _sim_state['truck_loads'] = [bool(v) for v in load_vals]
                    _sim_state['escenario']   = int(round(vals[38]))
                    _sim_state['F_hw']        = float(vals[39])
                    _sim_state['modo']        = int(round(vals[40]))
                    with _cont_lock:
                        _cont_state['counts']    = [max(0, int(round(x))) for x in cnt_vals]
                        _cont_state['connected'] = True
                        _cont_state['last_rx']   = time.monotonic()
                elif n == 320:
                    # 40 doubles: 39 anteriores + 1 F_hw
                    vals = struct.unpack('<40d', data)
                    xt, thl, lh, brk_t, brk_h, brk_he, tlk, sway, ylidar = vals[:9]
                    cnt_vals  = vals[9:28]
                    trk_vals  = vals[28:33]
                    load_vals = vals[33:38]
                    _sim_state['x_t_sim']     = float(xt)
                    _sim_state['theta_l_sim'] = float(thl)
                    _sim_state['l_h_sim']     = float(lh)
                    _sim_state['BRK_t']       = bool(brk_t)
                    _sim_state['BRK_h']       = bool(brk_h)
                    _sim_state['BRK_hE']      = bool(brk_he)
                    _sim_state['TLK']         = bool(tlk)
                    _sim_state['SWAY_CTR']    = bool(sway)
                    _sim_state['y_c0_lidar']  = float(ylidar)
                    _sim_state['trucks']      = [bool(v) for v in trk_vals]
                    _sim_state['truck_loads'] = [bool(v) for v in load_vals]
                    _sim_state['escenario']   = int(round(vals[38]))
                    _sim_state['F_hw']        = float(vals[39])
                    with _cont_lock:
                        _cont_state['counts']    = [max(0, int(round(x))) for x in cnt_vals]
                        _cont_state['connected'] = True
                        _cont_state['last_rx']   = time.monotonic()
                elif n == 312:
                    # 39 doubles: 9 crane + 19 cont counts + 5 truck presence + 5 truck loads + 1 escenario
                    vals = struct.unpack('<39d', data)
                    xt, thl, lh, brk_t, brk_h, brk_he, tlk, sway, ylidar = vals[:9]
                    cnt_vals  = vals[9:28]
                    trk_vals  = vals[28:33]
                    load_vals = vals[33:38]
                    _sim_state['x_t_sim']     = float(xt)
                    _sim_state['theta_l_sim'] = float(thl)
                    _sim_state['l_h_sim']     = float(lh)
                    _sim_state['BRK_t']       = bool(brk_t)
                    _sim_state['BRK_h']       = bool(brk_h)
                    _sim_state['BRK_hE']      = bool(brk_he)
                    _sim_state['TLK']         = bool(tlk)
                    _sim_state['SWAY_CTR']    = bool(sway)
                    _sim_state['y_c0_lidar']  = float(ylidar)
                    _sim_state['trucks']      = [bool(v) for v in trk_vals]
                    _sim_state['truck_loads'] = [bool(v) for v in load_vals]
                    _sim_state['escenario']   = int(round(vals[38]))
                    with _cont_lock:
                        _cont_state['counts']    = [max(0, int(round(v))) for v in cnt_vals]
                        _cont_state['connected'] = True
                        _cont_state['last_rx']   = time.monotonic()
                elif n == 24:
                    x_t_sim, theta_l_sim, l_h_sim = struct.unpack('<3d', data)
                    _sim_state['x_t_sim']     = float(x_t_sim)
                    _sim_state['theta_l_sim'] = float(theta_l_sim)
                    _sim_state['l_h_sim']     = float(l_h_sim)
                elif n == 16:
                    x_t_sim, theta_l_sim = struct.unpack('<2d', data)
                    _sim_state['x_t_sim']     = float(x_t_sim)
                    _sim_state['theta_l_sim'] = float(theta_l_sim)
                elif n == 8:
                    (x_t_sim,) = struct.unpack('<d', data)
                    _sim_state['x_t_sim'] = float(x_t_sim)
                elif n == 4:
                    (x_t_sim,) = struct.unpack('<f', data)
                    _sim_state['x_t_sim'] = float(x_t_sim)
                else:
                    print(f"[Simulink] Paquete inesperado: {n} bytes de {addr}")
                    continue
                _sim_state['connected'] = True
                _sim_state['last_rx']   = time.monotonic()
        except socket.timeout:
            with _sim_lock:
                if time.monotonic() - _sim_state['last_rx'] > SIM_TIMEOUT_S:
                    _sim_state['connected'] = False
        except Exception as e:
            print(f"[Simulink] Error receptor: {e}")

threading.Thread(target=_simulink_receiver, daemon=True).start()

def _controller_receiver():
    import struct as _struct
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind(('127.0.0.1', CTRL_UDP_PORT))
    sock.settimeout(0.5)
    print(f"[Controller] Escuchando UDP en 127.0.0.1:{CTRL_UDP_PORT}")
    expected = _struct.calcsize(CTRL_UDP_FMT)   # 14 bytes
    while True:
        try:
            data, _ = sock.recvfrom(64)
            if len(data) == expected + 1:   # 15 bytes: formato RT_VIEW con joystick_on
                tc, hc, son, mauto, tlk, sway, emg, _, joy = _struct.unpack('!ffBBBBBBB', data)
                with _ctrl_lock:
                    _ctrl_state['trolley_cmd']      = float(tc)
                    _ctrl_state['hoist_cmd']         = float(hc)
                    _ctrl_state['system_on']         = bool(son)
                    _ctrl_state['mode_auto']         = bool(mauto)
                    _ctrl_state['twistlock_closed']  = bool(tlk)
                    _ctrl_state['sway_ctrl']         = bool(sway)
                    _ctrl_state['emergency']         = bool(emg)
                    _ctrl_state['connected']         = bool(joy)
                    _ctrl_state['last_rx']           = time.monotonic()
            elif len(data) == expected:   # 14 bytes: formato legacy sin joystick_on
                tc, hc, son, mauto, tlk, sway, emg, _ = _struct.unpack(CTRL_UDP_FMT, data)
                with _ctrl_lock:
                    _ctrl_state['trolley_cmd']      = float(tc)
                    _ctrl_state['hoist_cmd']         = float(hc)
                    _ctrl_state['system_on']         = bool(son)
                    _ctrl_state['mode_auto']         = bool(mauto)
                    _ctrl_state['twistlock_closed']  = bool(tlk)
                    _ctrl_state['sway_ctrl']         = bool(sway)
                    _ctrl_state['emergency']         = bool(emg)
                    _ctrl_state['connected']         = True
                    _ctrl_state['last_rx']           = time.monotonic()
        except socket.timeout:
            with _ctrl_lock:
                if time.monotonic() - _ctrl_state['last_rx'] > CTRL_TIMEOUT_S:
                    _ctrl_state['connected'] = False
        except Exception as e:
            print(f"[Controller] Error receptor: {e}")

threading.Thread(target=_controller_receiver, daemon=True).start()

masa_est  = 32500.0          # [kg] Masa estimada de la carga

# Variables discretas (True = activo/cerrado)
BRK_t     = False   # Freno de traslación del carro
BRK_h     = False   # Freno de operación de izaje
BRK_hE    = False   # Freno de emergencia de izaje
TLK       = True    # TLK (carga enganchada al spreader)
SWAY_CTR  = True    # Controlador de balanceo activo

TROLLEY_W = 4.0
TROLLEY_H = 1.8

# Posición del spreader/carga
x_spreader = x_t + l_h * np.sin(theta_l)
y_spreader = Y_t0 - l_h * np.cos(theta_l)

# ─── Geometría estructural de la grúa ───────────────────────────────────────
# Vista lateral (plano XY, X horizontal, Y vertical)
DOCK_X_START   = x_t_min
DOCK_X_END     =  0.0    # Borde del muelle (agua empieza aquí)
WATER_LEVEL    =  0.0
GROUND_LEVEL   =  0.0

# Piernas del pórtico (2D: pierna tierra y pierna mar)
LEG_LAND_X     = -14.0   # Pierna lado tierra
LEG_SEA_X      =   4.0   # Pierna lado mar (cerca del borde)
LEG_TOP        =  Y_t0   # Las piernas llegan al nivel del boom
LEG_WIDTH      =   1.2
LEG_LAND_FOOT_L = LEG_LAND_X - 2.0
LEG_LAND_FOOT_R = LEG_LAND_X + 2.0
LEG_SEA_FOOT_L  = LEG_SEA_X  - 2.0
LEG_SEA_FOOT_R  = LEG_SEA_X  + 2.0

# Boom horizontal (nivel Y_t0)
BOOM_X_LAND   = x_t_min  # Retaguardia
BOOM_X_SEA    = x_t_max  # Avance sobre el barco
BOOM_HEIGHT   = 1.2      # Altura visual del boom

# Casa de máquinas (encima del pórtico, lado tierra)
MACH_X = LEG_LAND_X - 3.0
MACH_W = 10.0
MACH_H =  6.0

# Barco
SHIP_DECK_Y   = 2.0
SHIP_X_START  = 2.5
SHIP_X_END    = 47.5
SHIP_HULL_H   = 20.0  # Altura total del casco = |y_h_min|
SHIP_HOLD_D   = 20.0  # Profundidad de las bodegas (= |y_h_min|)


# Spreader
SPR_W  = W_c  # Ancho del spreader = ancho del container
SPR_H  = 0.6

# Camiones (pick en continente)
H_truck  = 1.0                          # [m] Altura del camión
x_trucks = [-25, -20, -15, -10, -5]    # [m] Borde izquierdo de cada camión

# ─── Figura ─────────────────────────────────────────────────────────────────
fig = plt.figure(figsize=(24, 11))
fig.patch.set_facecolor('white')
# Axes principal (crane view) — deja margen derecho para el panel
ax = fig.add_axes([0.17, 0.06, 0.59, 0.82])   # shifted right to make room for ctrl panel
ax.set_facecolor('white')

# ── Panel izquierdo: control PS4 (dark theme compacto) ───────────────────────
_CB  = '#0f0f1a'   # ctrl background
_CGC = '#2a2a4a'   # ctrl grid
_CTC = '#e0e0e0'   # ctrl text
_CAC = '#00b4d8'   # ctrl accent
_CPG = '#2ecc71'   # ctrl positive/green
_CNR = '#e74c3c'   # ctrl negative/red

cax = fig.add_axes([0.01, 0.06, 0.14, 0.82])
cax.set_facecolor(_CB)
cax.set_xlim(0, 1); cax.set_ylim(0, 1)
cax.set_xticks([]); cax.set_yticks([])
for sp in cax.spines.values():
    sp.set_edgecolor(_CGC)

# Título del panel
cax.text(0.5, 0.985, 'CONTROL PS4', transform=cax.transAxes,
         ha='center', va='top', fontsize=8, color=_CAC, fontweight='bold',
         fontfamily='monospace')

# ── Indicador de conexión del controlador ─────────────────────────────────────
dyn_ctrl_conn = cax.text(0.5, 0.945, '  DESCONECTADO  ', transform=cax.transAxes,
                          ha='center', va='top', fontsize=7.5, color='white',
                          fontweight='bold', fontfamily='monospace',
                          bbox=dict(boxstyle='round,pad=0.3', fc=_CNR, ec='none'))

# Separador
cax.plot([0.05, 0.95], [0.915, 0.915], transform=cax.transAxes,
         color=_CGC, lw=0.8)

# ── Barras de velocidad (CARRO / IZAJE) ───────────────────────────────────────
cax.text(0.5, 0.895, 'Velocidades', transform=cax.transAxes,
         ha='center', va='top', fontsize=7, color='#777777', fontfamily='monospace')

# Fondo de barras
cax.add_patch(plt.Rectangle((0.05, 0.80), 0.90, 0.065,
              transform=cax.transAxes, fc='#1e2a40', ec='none', zorder=1, clip_on=False))
cax.add_patch(plt.Rectangle((0.05, 0.72), 0.90, 0.065,
              transform=cax.transAxes, fc='#1e2a40', ec='none', zorder=1, clip_on=False))

# Línea central de barras
cax.plot([0.5, 0.5], [0.72, 0.87], transform=cax.transAxes,
         color='#555', lw=0.8)

# Labels
cax.text(0.03, 0.833, 'CARRO', transform=cax.transAxes,
         ha='left', va='center', fontsize=6, color=_CTC, fontfamily='monospace')
cax.text(0.03, 0.753, 'IZAJE', transform=cax.transAxes,
         ha='left', va='center', fontsize=6, color=_CTC, fontfamily='monospace')

# Patches dinámicos de barras (ancla en el centro x=0.5)
dyn_bar_carro = plt.Rectangle((0.5, 0.802), 0, 0.055,
                               transform=cax.transAxes, fc=_CPG, ec='none', zorder=2, clip_on=False)
dyn_bar_izaje = plt.Rectangle((0.5, 0.722), 0, 0.055,
                               transform=cax.transAxes, fc=_CPG, ec='none', zorder=2, clip_on=False)
cax.add_patch(dyn_bar_carro)
cax.add_patch(dyn_bar_izaje)

dyn_txt_carro = cax.text(0.5, 0.874, '0.00 m/s', transform=cax.transAxes,
                          ha='center', va='top', fontsize=6.5, color=_CAC,
                          fontweight='bold', fontfamily='monospace')
dyn_txt_izaje = cax.text(0.5, 0.794, '0.00 m/s', transform=cax.transAxes,
                          ha='center', va='top', fontsize=6.5, color=_CAC,
                          fontweight='bold', fontfamily='monospace')

# Separador
cax.plot([0.05, 0.95], [0.705, 0.705], transform=cax.transAxes,
         color=_CGC, lw=0.8)

# ── Estado del sistema ────────────────────────────────────────────────────────
cax.text(0.5, 0.688, 'Estado', transform=cax.transAxes,
         ha='center', va='top', fontsize=7, color='#777777', fontfamily='monospace')

_ctrl_rows = [
    ('sys',   'SIMULINK:',  0.650),
    ('csys',  'Sistema:',   0.580),
    ('mode',  'Modo:',      0.510),
    ('tlk',   'Twistlock:', 0.440),
    ('sway',  'Balanceo:',  0.370),
    ('emg',   'Emergencia:',0.300),
]
dyn_ctrl_status = {}
for key, lbl, y in _ctrl_rows:
    cax.text(0.05, y, lbl, transform=cax.transAxes,
             ha='left', va='center', fontsize=7, color='#777777', fontfamily='monospace')
    dyn_ctrl_status[key] = cax.text(0.97, y, '—', transform=cax.transAxes,
                                     ha='right', va='center', fontsize=7,
                                     color=_CTC, fontweight='bold', fontfamily='monospace')

# Axes del panel de estado (derecha, sin bordes ni ticks)
pax = fig.add_axes([0.77, 0.06, 0.21, 0.82])
pax.set_facecolor('#eef2f6')
pax.set_xticks([]); pax.set_yticks([])
for sp in pax.spines.values():
    sp.set_edgecolor('#8098b0')

def c(hex_str):
    return hex_str

STEEL      = '#8fa8c8'
STEEL_DARK = '#8fa8c8'
BOOM_CLR   = '#8fa8c8'
GROUND_CLR = '#9a9a8a'
WATER_CLR  = '#0d3b6e'
WATER_SURF = '#1565c0'
SHIP_CLR   = '#2d4a6a'
SHIP_DECK  = '#3d5a7a'
CONT_COLORS  = ['#c0392b', '#27ae60', '#2980b9', '#f39c12', '#8e44ad']
STACK_COLORS = ['#e74c3c', '#2ecc71', '#3498db', '#f1c40f', '#9b59b6',
                '#1abc9c', '#e67e22', '#34495e', '#e91e63', '#00bcd4']
CABLE_CLR  = '#e0d0a0'
SPREADER_CLR = '#e8c060'
HIGHLIGHT  = '#f0e060'
TEXT_CLR   = '#1a2a3a'
GRID_CLR   = '#b0b8c8'
ANNOT_CLR  = '#2a4a6a'


# ── Fondo / ambiente ─────────────────────────────────────────────────────────
# Fondo del cielo — blanco puro (manejado por ax.set_facecolor)

# Agua
water = patches.Rectangle((DOCK_X_END, -25), SHIP_X_END + 10 - DOCK_X_END, 25,
                           color=WATER_CLR, zorder=1)
ax.add_patch(water)

# Línea de agua
ax.plot([DOCK_X_END, SHIP_X_START], [WATER_LEVEL, WATER_LEVEL],
        color=WATER_SURF, lw=2, zorder=2)
ax.plot([SHIP_X_END, SHIP_X_END + 8], [WATER_LEVEL, WATER_LEVEL],
        color=WATER_SURF, lw=2, zorder=2)

# Muelle (suelo) — relleno desde el fondo hasta y=0
GROUND_BOTTOM = -24
dock = patches.Rectangle((x_t_min - 2, GROUND_BOTTOM),
                          DOCK_X_END - x_t_min + 2, -GROUND_BOTTOM,
                          color=GROUND_CLR, zorder=2)
ax.add_patch(dock)
# Línea de superficie a y=0
ax.plot([x_t_min - 2, DOCK_X_END], [GROUND_LEVEL, GROUND_LEVEL],
        color='#606070', lw=1.2, zorder=3)

# Borde del muelle (línea vertical)
ax.plot([DOCK_X_END, DOCK_X_END], [GROUND_BOTTOM, SHIP_DECK_Y + 0.5],
        color='#607090', lw=2, zorder=3)

# Sill beam: x∈[-1.5, 0], y∈[0, Y_sb=5]
SB_X_START = -1.0
SB_X_END   =  0.0
ax.add_patch(patches.Rectangle((SB_X_START, 0.0), SB_X_END - SB_X_START, Y_sb,
                                color=STEEL, zorder=4))
ax.add_patch(patches.Rectangle((SB_X_START, 0.0), SB_X_END - SB_X_START, Y_sb,
                                fill=False, edgecolor=STEEL_DARK, lw=1.0, zorder=5))

# Línea de rail del carro (suelo del muelle)
ax.axhline(GROUND_LEVEL, x_t_min - 2, DOCK_X_END, color='#505060', lw=0.8, zorder=3)

# ── Camiones con contenedores en continente ──────────────────────────────────
TRUCK_CLR = '#5a5a6a'
WHEEL_R  = 0.28                          # [m] radio de rueda
BODY_Y   = GROUND_LEVEL + 2 * WHEEL_R   # cuerpo arranca sobre las ruedas
BODY_H   = H_truck - 2 * WHEEL_R        # altura del cuerpo = 1.0 - 0.56 = 0.44 m

# Patches de camiones — dinámicos (visibilidad controlada por Simulink)
# Cada entrada: {'body': [...patches cuerpo+ruedas...], 'load': [...patches container...]}
_truck_patches = []
for _ti, _xt in enumerate(x_trucks):
    _color  = CONT_COLORS[_ti % len(CONT_COLORS)]
    _xleft  = _xt - W_c / 2   # x_trucks son centros
    _cont_y = GROUND_LEVEL + H_truck
    _body_ps = []
    # Ruedas
    for _wx in [_xleft + 0.35, _xleft + W_c - 0.35]:
        _c = plt.Circle((_wx, GROUND_LEVEL + WHEEL_R), WHEEL_R, color='#2a2a3a', zorder=5)
        ax.add_patch(_c); _body_ps.append(_c)
    # Cuerpo
    _body = patches.Rectangle((_xleft, BODY_Y), W_c, BODY_H, color=TRUCK_CLR, zorder=4)
    _body_e = patches.Rectangle((_xleft, BODY_Y), W_c, BODY_H,
                                  fill=False, edgecolor='#3a3a4a', lw=0.8, zorder=5)
    ax.add_patch(_body); ax.add_patch(_body_e)
    _body_ps += [_body, _body_e]
    # Contenedor (controlado por truck_loads independientemente)
    _cont = patches.Rectangle((_xleft, _cont_y), W_c, H_c, color=_color, zorder=4, alpha=0.9)
    _cont_e = patches.Rectangle((_xleft, _cont_y), W_c, H_c,
                                  fill=False, edgecolor='#00000055', lw=0.8, zorder=5)
    ax.add_patch(_cont); ax.add_patch(_cont_e)
    _truck_patches.append({'body': _body_ps, 'load': [_cont, _cont_e]})

# ── Barco ─────────────────────────────────────────────────────────────────────
SHIP_W = SHIP_X_END - SHIP_X_START

# Interior del casco (fondo blanco)
ax.add_patch(patches.Rectangle((SHIP_X_START, WATER_LEVEL - SHIP_HULL_H),
                                 SHIP_W, SHIP_HULL_H, color='#f0f4f8', zorder=2))

# Paredes laterales del casco (zona sólida con textura rallada)
_WALL_W = SHIP_X_START - DOCK_X_END  # 2.5 m
_HATCH_CLR = '#8a9bb0'
for _hx in [DOCK_X_END, SHIP_X_END]:
    ax.add_patch(patches.Rectangle(
        (_hx, WATER_LEVEL - SHIP_HULL_H), _WALL_W, SHIP_HULL_H,
        color='#c8d4e0', zorder=2))
    ax.add_patch(patches.Rectangle(
        (_hx, WATER_LEVEL - SHIP_HULL_H), _WALL_W, SHIP_HULL_H,
        fill=False, hatch='////', edgecolor=_HATCH_CLR, lw=0.0, zorder=3))

# Contorno del casco: solo 3 lados (sin borde superior)
hull_x0, hull_x1 = SHIP_X_START, SHIP_X_END
hull_y0, hull_y1 = WATER_LEVEL - SHIP_HULL_H, WATER_LEVEL
for xs, ys in [([hull_x0, hull_x0], [hull_y0, hull_y1]),   # izquierdo
               ([hull_x0, hull_x1], [hull_y0, hull_y0]),   # inferior
               ([hull_x1, hull_x1], [hull_y0, hull_y1])]:  # derecho
    ax.plot(xs, ys, color=SHIP_CLR, lw=2.0, zorder=3)



# ── Containers en el barco (patches pre-alocados, visibilidad dinámica) ──────
CONT_BASE_Y = -20.0   # [m] fondo de la bodega del barco
_ship_cont_patches = []
for _cx in CONT_X_POSITIONS:
    _col = []
    for _k in range(CONT_MAX_STACK):
        _clr  = STACK_COLORS[_k % len(STACK_COLORS)]
        _cy   = CONT_BASE_Y + _k * H_c
        _fill = patches.Rectangle((_cx - W_c / 2, _cy), W_c, H_c,
                                   color=_clr, zorder=3, alpha=0.92, visible=False)
        _edge = patches.Rectangle((_cx - W_c / 2, _cy), W_c, H_c,
                                   fill=False, edgecolor='#000000bb', lw=1.0,
                                   zorder=4, visible=False)
        ax.add_patch(_fill); ax.add_patch(_edge)
        _col.append((_fill, _edge))
    _ship_cont_patches.append(_col)

# ── Matriz de ocupación ───────────────────────────────────────────────────────

# ── Estructura de la grúa ──────────────────────────────────────────────────
# Boom (viga horizontal superior)
boom = patches.Rectangle((BOOM_X_LAND, Y_t0), BOOM_X_SEA - BOOM_X_LAND, BOOM_HEIGHT,
                          color=BOOM_CLR, zorder=6)
ax.add_patch(boom)
# Detalle inferior del boom
ax.plot([BOOM_X_LAND, BOOM_X_SEA], [Y_t0, Y_t0], color=STEEL_DARK, lw=1, zorder=7)


# Vigas de celosía del boom (diagonales decorativas)
n_truss = 12
boom_step = (BOOM_X_SEA - BOOM_X_LAND) / n_truss
for i in range(n_truss):
    x0 = BOOM_X_LAND + i * boom_step
    x1 = BOOM_X_LAND + (i + 1) * boom_step
    if i % 2 == 0:
        ax.plot([x0, x1], [Y_t0, Y_t0 + BOOM_HEIGHT], color=STEEL_DARK, lw=0.7, zorder=7, alpha=0.6)
    else:
        ax.plot([x0, x1], [Y_t0 + BOOM_HEIGHT, Y_t0], color=STEEL_DARK, lw=0.7, zorder=7, alpha=0.6)


# ── Artistas dinámicos (se actualizan en cada frame) ─────────────────────────
def _compute_pendulum(xt, lh, thl):
    """Devuelve posiciones derivadas del estado del péndulo."""
    xs = xt + lh * np.sin(thl)
    ys = Y_t0 - lh * np.cos(thl)
    return xs, ys

pulley_y  = Y_t0 - TROLLEY_H

# Trolley — relleno (referencia para mover)
dyn_trolley = patches.Rectangle((x_t - TROLLEY_W / 2, Y_t0 - TROLLEY_H),
                                  TROLLEY_W, TROLLEY_H, color='#d4a020', zorder=9)
ax.add_patch(dyn_trolley)
dyn_trolley_edge = patches.Rectangle((x_t - TROLLEY_W / 2, Y_t0 - TROLLEY_H),
                                       TROLLEY_W, TROLLEY_H,
                                       fill=False, edgecolor='#f0c030', lw=1.5, zorder=10)
ax.add_patch(dyn_trolley_edge)
# Ruedas
dyn_wheel_l = plt.Circle((x_t - TROLLEY_W/2 + 0.8, Y_t0 + 0.3), 0.4, color='black', zorder=10)
dyn_wheel_r = plt.Circle((x_t + TROLLEY_W/2 - 0.8, Y_t0 + 0.3), 0.4, color='black', zorder=10)
ax.add_patch(dyn_wheel_l); ax.add_patch(dyn_wheel_r)
# Polea
dyn_pulley = plt.Circle((x_t, pulley_y), 0.5, color='#a08020', zorder=10)
ax.add_patch(dyn_pulley)

# LIDAR (fijo al carro, offset +3 m en x)
LIDAR_OFFSET = 3.0   # x_lidar_offset de parametros.m
LIDAR_W  = 0.7; LIDAR_H  = 0.45
LIDAR_SH = 1.2        # longitud del soporte vertical
_lx  = x_t + LIDAR_OFFSET
_ly  = Y_t0 - TROLLEY_H - LIDAR_SH - LIDAR_H   # base del cuerpo
_ly_top = Y_t0 - TROLLEY_H                       # punto de anclaje en el carro

# Soporte en L: horizontal desde borde del carro → LIDAR, luego vertical → sensor
_lx_anchor = x_t + TROLLEY_W/2   # borde derecho del carro
dyn_lidar_support, = ax.plot([_lx_anchor, _lx, _lx],
                              [_ly_top, _ly_top, _ly + LIDAR_H],
                              color='#888888', lw=1.5, zorder=10)
# Cuerpo del sensor
dyn_lidar_body = patches.Rectangle((_lx - LIDAR_W/2, _ly),
                                    LIDAR_W, LIDAR_H,
                                    color='#c0392b', zorder=11)
dyn_lidar_edge = patches.Rectangle((_lx - LIDAR_W/2, _ly),
                                    LIDAR_W, LIDAR_H,
                                    fill=False, edgecolor='#e74c3c', lw=1.2, zorder=12)
ax.add_patch(dyn_lidar_body)
ax.add_patch(dyn_lidar_edge)
# Haz de medición
dyn_lidar_beam, = ax.plot([_lx, _lx], [_ly, 0.0],
                           color='#e74c3c', lw=0.8, ls='--', alpha=0.45, zorder=7)
dyn_lidar_dot = ax.plot(_lx, 0.0, '*', color='#e74c3c',
                         ms=8, zorder=12)[0]

# Perfil acumulado del LIDAR
_LIDAR_DX      = 0.01
_lidar_xs      = np.arange(x_t_min, x_t_max + _LIDAR_DX, _LIDAR_DX)  # 8001 pts
_lidar_ys      = np.full(len(_lidar_xs), np.nan)                        # NaN = no medido
_lidar_last_idx = [None]   # índice del frame anterior (lista para mutabilidad)
dyn_lidar_profile, = ax.plot(_lidar_xs, _lidar_ys,
                              color='#e74c3c', lw=1.5, zorder=20, alpha=0.95,
                              label=r'Lectura LIDAR s/ $\hat{x}_t$')


ax.legend(loc='upper right', fontsize=7.5, framealpha=0.85,
          edgecolor='#8098b0', facecolor='#f4f7fa',
          handlelength=1.6, handletextpad=0.5)

# Cable
dyn_cable, = ax.plot([x_t, x_spreader], [pulley_y, y_spreader + SPR_H],
                      color=CABLE_CLR, lw=1.8, zorder=8)

# Spreader: fondo en y_spreader, tope en y_spreader + SPR_H (incluido en l_h)
cos_t = np.cos(theta_l); sin_t = np.sin(theta_l)
hw = SPR_W / 2;          hh   = SPR_H / 2
_corners_s = np.array([[-hw,-hh],[hw,-hh],[hw,hh],[-hw,hh]])
_rot = np.array([[cos_t,-sin_t],[sin_t,cos_t]])
_sxy = np.array([x_spreader + SPR_H/2*sin_t, y_spreader + SPR_H/2*cos_t])
dyn_spr  = plt.Polygon((_rot @ _corners_s.T).T + _sxy,
                         closed=True, color=SPREADER_CLR, zorder=11)
dyn_spr_e = plt.Polygon((_rot @ _corners_s.T).T + _sxy,
                          closed=True, fill=False, edgecolor='#f0a000', lw=1.5, zorder=12)
ax.add_patch(dyn_spr); ax.add_patch(dyn_spr_e)

# Contenedor: centro en H_c/2 debajo del fondo del spreader
_corners_c = np.array([[-W_c/2,-H_c/2],[W_c/2,-H_c/2],[W_c/2,H_c/2],[-W_c/2,H_c/2]])
_cxy = np.array([x_spreader + H_c/2*sin_t,
                  y_spreader - H_c/2*cos_t])
dyn_cont   = plt.Polygon((_rot @ _corners_c.T).T + _cxy,
                           closed=True, color='#c0392b', zorder=12, alpha=0.9)
dyn_cont_e = plt.Polygon((_rot @ _corners_c.T).T + _cxy,
                           closed=True, fill=False, edgecolor='#e05040', lw=1.5, zorder=13)
ax.add_patch(dyn_cont); ax.add_patch(dyn_cont_e)

# ── Etiquetas de elementos ────────────────────────────────────────────────────
labels = [
]
for lx, ly, lt, lc in labels:
    ax.text(lx, ly, lt, ha='center', va='center', fontsize=7, color=lc,
            zorder=20, fontweight='bold',
            bbox=dict(boxstyle='round,pad=0.2', fc='#e0e8f0', ec='none', alpha=0.7))

# ── Título e info ─────────────────────────────────────────────────────────────
fig.text(0.5, 0.97, 'Grúa Portacontenedores STS — Visualización 2D del sistema',
         ha='center', va='top', fontsize=13, color=TEXT_CLR, fontweight='bold')
fig.text(0.5, 0.93, 'Martín, I.  –  Sorrentino, N.',
         ha='center', va='top', fontsize=10, color=TEXT_CLR)

# Indicador de modo (dentro del plot, esquina superior izquierda)
# Indicador SIMULINK_CONNECTION (fuera del plot, encima del modo)
dyn_sim_txt = fig.text(0.04, 0.905, '  SIMULINK: DESCONECTADO  ',
                        ha='left', va='top', fontsize=9, color='white', fontweight='bold',
                        bbox=dict(boxstyle='round,pad=0.35', fc='#c0392b', ec='white', lw=1.2))

# Paleta de escenarios
_ESC_INFO = {
   -1: ('Escenario: NO INFORMADO',    '#90a4ae'),
    0: ('Escenario: ESPERA',          '#546e7a'),
    1: ('Escenario: CICLO CARGA',     '#1565c0'),
    2: ('Escenario: CICLO DESCARGA',  '#b71c1c'),
    3: ('Escenario: CICLO DOBLE',     '#6a1b9a'),
}
dyn_esc_txt = fig.text(0.875, 0.935, f'  {_ESC_INFO[-1][0]}  ',
                        ha='center', va='top', fontsize=11, color='white', fontweight='bold',
                        bbox=dict(boxstyle='round,pad=0.4', fc=_ESC_INFO[0][1],
                                  ec='white', lw=1.8))

# Indicador de modo (dinámico)
dyn_modo_txt = ax.text(0.01, 0.99, '  MODO: MANUAL  ', transform=ax.transAxes,
                        ha='left', va='top', fontsize=11, color='white', fontweight='bold',
                        zorder=25,
                        bbox=dict(boxstyle='round,pad=0.4', fc='#e67e22', ec='white', lw=1.5, alpha=0.92))

# ── Panel derecho: estado continuo + discretas ────────────────────────────────
DARK = '#1a2a3a'
pax.text(0.5, 0.97, 'ESTADO', transform=pax.transAxes,
         ha='center', va='top', fontsize=11, color=DARK, fontweight='bold')
pax.plot([0, 1], [0.94, 0.94], color='#8098b0', lw=1.0, transform=pax.transAxes, clip_on=False)

# Variables continuas — guardar referencias a los textos de valor para RT
cont_var_labels = [
    '$x_{t,\\mathrm{sim}}$',
    '$l_{\\mathrm{sim}}$',
    '$\\theta_{l,\\mathrm{sim}}$',
    '$\\hat{m}$',
    '$F_{hw}$',
]
cont_var_inits = [
    f'{x_t:.2f} m',
    f'{l_h:.2f} m',
    f'{np.rad2deg(theta_l):.2f}°',
    f'{masa_est/1000:.2f} t',
    '0.00 N',
]
y_cur = 0.91
row_gap = 0.072
pax.text(0.5, y_cur, 'Continuas', transform=pax.transAxes,
         ha='center', va='top', fontsize=9, color='#4a6a8a', style='italic')
y_cur -= 0.04
dyn_val_txts = {}
for label, val in zip(cont_var_labels, cont_var_inits):
    pax.text(0.08, y_cur, label, transform=pax.transAxes,
             ha='left', va='top', fontsize=10, color=DARK)
    dyn_val_txts[label] = pax.text(0.92, y_cur, val, transform=pax.transAxes,
                                    ha='right', va='top', fontsize=10,
                                    color=DARK, fontweight='bold')
    y_cur -= row_gap

pax.plot([0, 1], [y_cur + 0.01, y_cur + 0.01], color='#8098b0', lw=0.8, transform=pax.transAxes, clip_on=False)
y_cur -= 0.025

# Semántica de color para cada variable discreta:
#   BRK_*  : 0=cerrado(verde)  1=abierto(rojo)   → verde cuando NO activo
#   TLK    : 0=abierto(rojo)   1=cerrado(verde)   → verde cuando activo
#   SWAY_CTR: 0=inactivo(rojo) 1=activo(verde)    → verde cuando activo
def _disc_style(name, val):
    """Devuelve (label, color) según la semántica de la variable."""
    if name.startswith('BRK'):
        green = not val   # 0=cerrado=OK=verde
        return ('Cerrado' if not val else 'Abierto'), ('#27ae60' if green else '#c0392b')
    else:  # TLK, SWAY_CTR: 1=activo=verde
        return ('ON' if val else 'OFF'), ('#27ae60' if val else '#c0392b')

# Variables discretas — las que vienen de Simulink son dinámicas
disc_vars = [
    ('BRK_t',    BRK_t,    True),   # (nombre, valor_inicial, es_dinámica)
    ('BRK_h',    BRK_h,    True),
    ('BRK_hE',   BRK_hE,   True),
    ('TLK',      TLK,      True),
    ('SWAY_CTR', SWAY_CTR, True),
]
pax.text(0.5, y_cur, 'Discretas', transform=pax.transAxes,
         ha='center', va='top', fontsize=9, color='#4a6a8a', style='italic')
y_cur -= 0.04
row_gap_d = 0.075
dyn_disc_txts = {}   # keyed por nombre → artist de la pastilla
for name, val, dynamic in disc_vars:
    label, clr = _disc_style(name, val)
    pax.text(0.08, y_cur, name, transform=pax.transAxes,
             ha='left', va='top', fontsize=10, color=DARK)
    pill = pax.text(0.92, y_cur, f'  {label}  ', transform=pax.transAxes,
                    ha='right', va='top', fontsize=9, color='white', fontweight='bold',
                    bbox=dict(boxstyle='round,pad=0.25', fc=clr, ec='none'))
    if dynamic:
        dyn_disc_txts[name] = pill
    y_cur -= row_gap_d

# ── Ejes y grilla ─────────────────────────────────────────────────────────────
ax.set_xlim(x_t_min - 6, SHIP_X_END + 6)
ax.set_ylim(-24, Y_t0 + BOOM_HEIGHT + 8)
ax.set_aspect('equal')
ax.set_xlabel('Posición horizontal $x$ [m]', color=TEXT_CLR, fontsize=9)
ax.set_ylabel('Altura $y$ [m]', color=TEXT_CLR, fontsize=9)
ax.tick_params(colors=TEXT_CLR, labelsize=8)
for spine in ax.spines.values():
    spine.set_edgecolor('#8098b0')
ax.set_facecolor('white')
ax.grid(color=GRID_CLR, linewidth=0.5, linestyle='--', alpha=0.4)

xlim = (x_t_min - 6, SHIP_X_END + 6)
ylim = (-24, Y_t0 + BOOM_HEIGHT + 8)
ax.set_xticks(np.arange(np.ceil(xlim[0] / 5) * 5, xlim[1] + 0.1, 5))
ax.set_yticks(np.arange(np.ceil(ylim[0] / 5) * 5, ylim[1] + 0.1, 5))

# ── Función de actualización RT ───────────────────────────────────────────────
def update_frame(_frame):
    with _sim_lock:
        xt_sim   = _sim_state['x_t_sim']
        thl_sim  = _sim_state['theta_l_sim']
        lh_sim   = _sim_state['l_h_sim']
        brk_t    = _sim_state['BRK_t']
        brk_h    = _sim_state['BRK_h']
        brk_he   = _sim_state['BRK_hE']
        tlk      = _sim_state['TLK']
        sway_ctr = _sim_state['SWAY_CTR']
        sim_ok    = _sim_state['connected']
        ylidar    = _sim_state['y_c0_lidar']
    with _sim_lock:
        truck_presence = list(_sim_state['trucks'])
        truck_loads    = list(_sim_state['truck_loads'])
        escenario      = _sim_state['escenario']
        f_hw           = _sim_state['F_hw']
        modo_val       = _sim_state['modo']
        masa_estimada  = _sim_state['masa_estimada']
    with _cont_lock:
        cont_counts = list(_cont_state['counts'])
    with _ctrl_lock:
        ctrl_ok   = _ctrl_state['connected']
        tc        = _ctrl_state['trolley_cmd']
        hc        = _ctrl_state['hoist_cmd']
        c_sys     = _ctrl_state['system_on']
        c_tlk     = _ctrl_state['twistlock_closed']
        c_sway    = _ctrl_state['sway_ctrl']
        c_emg     = _ctrl_state['emergency']

    # Geometría del péndulo con valores de Simulink
    xs, ys = _compute_pendulum(xt_sim, lh_sim, thl_sim)
    ct  = np.cos(thl_sim); st = np.sin(thl_sim)
    rot = np.array([[ct, -st], [st, ct]])

    # Trolley
    dyn_trolley.set_x(xt_sim - TROLLEY_W / 2)
    dyn_trolley_edge.set_x(xt_sim - TROLLEY_W / 2)
    dyn_wheel_l.set_center((xt_sim - TROLLEY_W/2 + 0.8, Y_t0 + 0.3))
    dyn_wheel_r.set_center((xt_sim + TROLLEY_W/2 - 0.8, Y_t0 + 0.3))
    dyn_pulley.set_center((xt_sim, pulley_y))

    # LIDAR
    _lx_sim  = xt_sim + LIDAR_OFFSET
    _ly_sim  = Y_t0 - TROLLEY_H - LIDAR_SH - LIDAR_H
    _lyt_sim = Y_t0 - TROLLEY_H
    _lx_anchor_sim = xt_sim + TROLLEY_W/2
    dyn_lidar_support.set_data([_lx_anchor_sim, _lx_sim, _lx_sim],
                                [_lyt_sim, _lyt_sim, _ly_sim + LIDAR_H])
    dyn_lidar_body.set_x(_lx_sim - LIDAR_W/2)
    dyn_lidar_edge.set_x(_lx_sim - LIDAR_W/2)
    _ylidar_disp = max(ylidar, SHIP_DECK_Y) if ylidar >= SHIP_DECK_Y else ylidar
    dyn_lidar_beam.set_data([_lx_sim, _lx_sim], [_ly_sim, _ylidar_disp])
    dyn_lidar_dot.set_data([_lx_sim], [_ylidar_disp])

    # Actualizar perfil acumulado
    _idx = int(round((xt_sim + LIDAR_OFFSET - x_t_min) / _LIDAR_DX))
    _idx = max(0, min(len(_lidar_ys) - 1, _idx))
    prev = _lidar_last_idx[0]
    if prev is not None and abs(_idx - prev) < 500:
        lo, hi = min(_idx, prev), max(_idx, prev)
        _lidar_ys[lo:hi + 1] = ylidar
    else:
        _lidar_ys[_idx] = ylidar
    _lidar_last_idx[0] = _idx
    dyn_lidar_profile.set_ydata(_lidar_ys.copy())


    # Cable
    dyn_cable.set_data([xt_sim, xs], [pulley_y, ys + SPR_H])

    # Spreader: fondo en ys, tope en ys + SPR_H (incluido en l_h)
    sxy = np.array([xs + SPR_H/2*st, ys + SPR_H/2*ct])
    hw  = SPR_W / 2; hh = SPR_H / 2
    cs  = np.array([[-hw,-hh],[hw,-hh],[hw,hh],[-hw,hh]])
    dyn_spr.set_xy((rot @ cs.T).T + sxy)
    dyn_spr_e.set_xy((rot @ cs.T).T + sxy)

    # Contenedor: centro en H_c/2 debajo del fondo del spreader
    cc  = np.array([[-W_c/2,-H_c/2],[W_c/2,-H_c/2],[W_c/2,H_c/2],[-W_c/2,H_c/2]])
    cxy = np.array([xs + H_c/2*st, ys - H_c/2*ct])
    dyn_cont.set_xy((rot @ cc.T).T + cxy)
    dyn_cont_e.set_xy((rot @ cc.T).T + cxy)
    dyn_cont.set_visible(tlk)
    dyn_cont_e.set_visible(tlk)

    # Visibilidad de camiones
    for tp, present, has_load in zip(_truck_patches, truck_presence, truck_loads):
        for p in tp['body']:
            p.set_visible(present)
        for p in tp['load']:
            p.set_visible(present and has_load)


    # Containers en el barco — show/hide según count
    for col_patches, count in zip(_ship_cont_patches, cont_counts):
        n = min(count, CONT_MAX_STACK)
        for k, (fill, edge) in enumerate(col_patches):
            vis = k < n
            fill.set_visible(vis)
            edge.set_visible(vis)

    # Panel — variables continuas
    dyn_val_txts['$x_{t,\\mathrm{sim}}$'].set_text(f'{xt_sim:.2f} m')
    dyn_val_txts['$\\theta_{l,\\mathrm{sim}}$'].set_text(f'{np.rad2deg(thl_sim):.2f}°')
    dyn_val_txts['$l_{\\mathrm{sim}}$'].set_text(f'{lh_sim:.2f} m')
    dyn_val_txts['$F_{hw}$'].set_text(f'{f_hw:.1f} N')
    dyn_val_txts['$\\hat{m}$'].set_text(f'{masa_estimada/1000:.2f} t')

    # Panel — variables discretas dinámicas
    for key, val in (('BRK_t', brk_t), ('BRK_h', brk_h),
                     ('BRK_hE', brk_he), ('TLK', tlk), ('SWAY_CTR', sway_ctr)):
        label, clr = _disc_style(key, val)
        pill = dyn_disc_txts[key]
        pill.set_text(f'  {label}  ')
        pill.get_bbox_patch().set_facecolor(clr)

    # Panel izquierdo — controlador PS4
    MAX_TC = 4.0; MAX_HC = 1.5
    if ctrl_ok:
        dyn_ctrl_conn.set_text('  CONECTADO  ')
        dyn_ctrl_conn.get_bbox_patch().set_facecolor(_CPG)
    else:
        dyn_ctrl_conn.set_text('  DESCONECTADO  ')
        dyn_ctrl_conn.get_bbox_patch().set_facecolor(_CNR)

    # Barras de velocidad (normalizadas, origen en x=0.5 en transAxes)
    n_tc = float(np.clip(tc / MAX_TC, -1.0, 1.0))
    n_hc = float(np.clip(hc / MAX_HC, -1.0, 1.0))
    half = 0.45   # mitad del ancho disponible (0.05..0.95)
    dyn_bar_carro.set_x(0.5 + min(0.0, n_tc) * half)
    dyn_bar_carro.set_width(abs(n_tc) * half)
    dyn_bar_carro.set_facecolor(_CPG if n_tc >= 0 else _CNR)
    dyn_bar_izaje.set_x(0.5 + min(0.0, n_hc) * half)
    dyn_bar_izaje.set_width(abs(n_hc) * half)
    dyn_bar_izaje.set_facecolor(_CPG if n_hc >= 0 else _CNR)
    dyn_txt_carro.set_text(f'{tc:+.2f} m/s')
    dyn_txt_izaje.set_text(f'{hc:+.2f} m/s')

    # Estado del sistema
    def _cs(key, txt, clr): dyn_ctrl_status[key].set_text(txt); dyn_ctrl_status[key].set_color(clr)
    _cs('sys',  'CONECTADO' if sim_ok else 'DESCONECTADO', _CPG if sim_ok else _CNR)
    _cs('csys', 'ON'     if c_sys  else 'OFF',    _CPG if c_sys  else '#888888')
    _cs('mode', 'AUTO'   if modo_val == 1 else 'MANUAL', _CAC if modo_val == 1 else '#f39c12')
    _cs('tlk',  'CERR'   if c_tlk  else 'ABTO',  _CPG if c_tlk  else '#e67e22')
    _cs('sway', 'ON'     if c_sway else 'OFF',    '#8e44ad' if c_sway else '#888888')
    _cs('emg',  '⚠ EMRG' if c_emg  else 'OK',    _CNR if c_emg  else _CPG)

    # Indicador modo
    if modo_val == 1:
        dyn_modo_txt.set_text('  MODO: AUTOMÁTICO  ')
        dyn_modo_txt.get_bbox_patch().set_facecolor('#27ae60')
    else:
        dyn_modo_txt.set_text('  MODO: MANUAL  ')
        dyn_modo_txt.get_bbox_patch().set_facecolor('#e67e22')

    # Indicador escenario
    _elbl, _eclr = _ESC_INFO.get(escenario, _ESC_INFO[-1])
    dyn_esc_txt.set_text(f'  {_elbl}  ')
    dyn_esc_txt.get_bbox_patch().set_facecolor(_eclr)

    # Indicador SIMULINK
    if sim_ok:
        dyn_sim_txt.set_text('  SIMULINK: CONECTADO  ')
        dyn_sim_txt.get_bbox_patch().set_facecolor('#27ae60')
    else:
        dyn_sim_txt.set_text('  SIMULINK: DESCONECTADO  ')
        dyn_sim_txt.get_bbox_patch().set_facecolor('#c0392b')

ani = animation.FuncAnimation(fig, update_frame, interval=SIM_UPDATE_MS,
                               cache_frame_data=False)

plt.savefig('grua_STS_2D.png', dpi=150, bbox_inches='tight',
            facecolor=fig.get_facecolor())
print("Imagen guardada en grua_STS_2D.png")
plt.show()
