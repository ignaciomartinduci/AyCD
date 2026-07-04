"""
controller_reader.py
Lectura de control PS4 y visualización en tiempo real.
Proyecto: Control de Grúa Portacontenedores – AyCD 2025

Instalación: pip install pygame matplotlib numpy
"""

import os
os.environ['PYGAME_HIDE_SUPPORT_PROMPT'] = '1'

import socket
import struct
import threading
import time
import pygame
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from matplotlib.gridspec import GridSpec
from matplotlib.patches import Circle, Rectangle, FancyBboxPatch

# ══════════════════════════════════════════════════════════════════════
#  Configuración
# ══════════════════════════════════════════════════════════════════════
DEADBAND      = 0.12

# ── UDP ───────────────────────────────────────────────────────────────
UDP_IP   = '127.0.0.1'
UDP_PORT = 5005
# Formato del paquete (14 bytes, big-endian):
#   float  trolley_cmd  [m/s]
#   float  hoist_cmd    [m/s]
#   uint8  system_on
#   uint8  mode_auto
#   uint8  twistlock_closed
#   uint8  sway_ctrl
#   uint8  emergency
#   uint8  emgy_ack
UDP_FMT  = '!ffBBBBBB'
MAX_VEL_CARRO = 4.0    # m/s  (Sec. 3.3)
MAX_VEL_IZAJE = 1.5    # m/s  (nominal, cargado)
UPDATE_MS     = 50     # intervalo de animación [ms]

# Ejes PS4 (pygame, DS4 USB/BT – puede variar según OS)
AXIS_L_X, AXIS_L_Y = 0, 1
AXIS_R_X, AXIS_R_Y = 2, 3

# Botones: nombre → (índice pygame, símbolo, color activo, etiqueta)
BUTTONS = {
    'cross':    (0,  '✕',   '#27ae60', 'Sistema ON/OFF'),
    'circle':   (1,  '○',   '#e67e22', 'Reset Emerg.'),
    'square':   (2,  '□',   '#2980b9', 'Twistlock'),
    'triangle': (3,  '△',   '#16a085', 'Manual / Auto'),
    'l1':       (9,  'L1',  '#8e44ad', 'Balanceo'),
    'options':  (6,  'OPT', '#c0392b', 'Emergencia'),
    'r1':       (10, 'R1',  '#f39c12', 'EMG Global ACK'),
}

# ── Paleta (dark theme) ───────────────────────────────────────────────
BG        = '#0f0f1a'
PANEL_BG  = '#16213e'
GRID_COL  = '#2a2a4a'
TEXT_COL  = '#e0e0e0'
ACCENT    = '#00b4d8'
POS_COL   = '#2ecc71'
NEG_COL   = '#e74c3c'
IDLE_COL  = '#2d2d4e'
DOT_COL   = '#00b4d8'

# ══════════════════════════════════════════════════════════════════════
#  Estado global
# ══════════════════════════════════════════════════════════════════════
state = {
    'lx': 0.0, 'ly': 0.0,
    'rx': 0.0, 'ry': 0.0,
    'trolley_cmd':      0.0,   # [m/s]
    'hoist_cmd':        0.0,   # [m/s]
    'system_on':        False,
    'mode_auto':        False,
    'twistlock_closed': False,
    'sway_ctrl':        False,
    'emergency':        False,
    'emgy_ack':         False,
    'connected':        False,
    'btn_raw': {k: False for k in BUTTONS},
    '_prev':   {k: False for k in BUTTONS},
}

joystick  = None   # pygame.joystick.Joystick
udp_sock  = None   # socket.socket


# ══════════════════════════════════════════════════════════════════════
#  Lectura del control
# ══════════════════════════════════════════════════════════════════════
def _deadband(v):
    if abs(v) < DEADBAND:
        return 0.0
    return (v - np.sign(v) * DEADBAND) / (1.0 - DEADBAND)


def read_controller():
    global joystick

    try:
        pygame.event.pump()
    except Exception:
        state['connected'] = False
        joystick = None
        return

    if pygame.joystick.get_count() == 0:
        if joystick is not None:
            print("[PS4] Control desconectado.")
        state['connected'] = False
        joystick = None
        return

    if joystick is None:
        joystick = pygame.joystick.Joystick(0)
        joystick.init()
        print(f"[PS4] Control conectado: {joystick.get_name()}")

    try:
        state['connected'] = True

        lx = _deadband(joystick.get_axis(AXIS_L_X))
        ly = _deadband(joystick.get_axis(AXIS_L_Y))
        rx = _deadband(joystick.get_axis(AXIS_R_X))
        ry = _deadband(joystick.get_axis(AXIS_R_Y))

        state['lx'], state['ly'] = lx, ly
        state['rx'], state['ry'] = rx, ry

        state['trolley_cmd'] = lx * MAX_VEL_CARRO
        state['hoist_cmd']   = -ry * MAX_VEL_IZAJE  # eje Y invertido en pygame

        for name, (idx, *_) in BUTTONS.items():
            cur  = bool(joystick.get_button(idx))
            prev = state['_prev'][name]
            state['btn_raw'][name] = cur

            if cur and not prev:  # flanco de subida
                if name == 'cross':    state['system_on']        ^= True
                if name == 'triangle': state['mode_auto']        ^= True
                if name == 'square':   state['twistlock_closed'] ^= True
                if name == 'l1':       state['sway_ctrl']        ^= True
                if name == 'options':  state['emergency']         = True
                if name == 'circle':   state['emergency']         = False
                if name == 'r1':       state['emgy_ack']         ^= True

            state['_prev'][name] = cur

    except pygame.error:
        state['connected'] = False
        joystick = None


# ══════════════════════════════════════════════════════════════════════
#  Salida UDP
# ══════════════════════════════════════════════════════════════════════
def send_udp():
    if udp_sock is None:
        return
    s = state
    data = struct.pack(
        UDP_FMT,
        s['trolley_cmd'],
        s['hoist_cmd'],
        int(s['system_on']),
        int(s['mode_auto']),
        int(s['twistlock_closed']),
        int(s['sway_ctrl']),
        int(s['emergency']),
        int(s['emgy_ack']),
    )
    try:
        udp_sock.sendto(data, (UDP_IP, UDP_PORT))
    except OSError:
        pass


# ══════════════════════════════════════════════════════════════════════
#  Hilo de lectura (daemon — muere solo cuando cierra la ventana)
# ══════════════════════════════════════════════════════════════════════
def _ps4_loop():
    global joystick
    pygame.init()
    pygame.joystick.init()

    n = pygame.joystick.get_count()
    print(f"[PS4] Controles detectados: {n}")
    if n > 0:
        joystick = pygame.joystick.Joystick(0)
        joystick.init()
        print(f"      → {joystick.get_name()}")
    else:
        print("      → Ninguno. Esperando conexión en caliente...")

    while True:
        try:
            read_controller()
            send_udp()
        except BaseException as e:
            print(f"[PS4] Error en hilo: {e}")
            joystick = None
            state['connected'] = False
        time.sleep(UPDATE_MS / 1000.0)


# ══════════════════════════════════════════════════════════════════════
#  Construcción de la figura
# ══════════════════════════════════════════════════════════════════════
def _make_stick_ax(fig, pos, title):
    ax = fig.add_subplot(pos, aspect='equal')
    ax.set_facecolor(PANEL_BG)
    ax.set_xlim(-1.3, 1.3)
    ax.set_ylim(-1.3, 1.3)
    ax.set_title(title, color=TEXT_COL, fontsize=9, pad=5)
    ax.set_xticks([])
    ax.set_yticks([])
    for sp in ax.spines.values():
        sp.set_edgecolor(GRID_COL)
    ax.add_patch(Circle((0, 0), 1.0,     fill=False, ec='#3a3a5c', lw=1.5, ls='--'))
    ax.add_patch(Circle((0, 0), DEADBAND, fc=GRID_COL, ec='#444',  lw=1.0))
    ax.axhline(0, color=GRID_COL, lw=0.8)
    ax.axvline(0, color=GRID_COL, lw=0.8)
    return ax


def build_figure():
    plt.rcParams.update({
        'font.family': 'monospace',
        'text.color':  TEXT_COL,
        'axes.labelcolor': TEXT_COL,
    })

    fig = plt.figure(figsize=(13, 7), facecolor=BG)
    try:
        fig.canvas.manager.set_window_title('PS4 – Grúa Portacontenedores')
    except Exception:
        pass

    fig.text(0.5, 0.97,
             'Control PS4  ·  Grúa Portacontenedores  ·  AyCD 2025',
             ha='center', va='top', fontsize=12,
             fontweight='bold', color=ACCENT)

    gs = GridSpec(3, 3, figure=fig,
                  left=0.05, right=0.97, top=0.91, bottom=0.06,
                  wspace=0.40, hspace=0.55)

    # ─── Sticks analógicos ────────────────────────────────────────────
    ax_ls = _make_stick_ax(fig, gs[0:2, 0], 'CARRO   ←  stick izq  →')
    ax_rs = _make_stick_ax(fig, gs[0:2, 1], 'IZAJE   ↑  stick der  ↓')

    dot_ls, = ax_ls.plot([0], [0], 'o', ms=14,
                          color=DOT_COL, mec='white', mew=1.5, zorder=5)
    val_ls  = ax_ls.text(0, -1.2, '0.00 m/s',
                          ha='center', va='top', fontsize=9, color=ACCENT)

    dot_rs, = ax_rs.plot([0], [0], 'o', ms=14,
                          color=DOT_COL, mec='white', mew=1.5, zorder=5)
    val_rs  = ax_rs.text(0, -1.2, '0.00 m/s',
                          ha='center', va='top', fontsize=9, color=ACCENT)

    # ─── Botones ──────────────────────────────────────────────────────
    ax_btn = fig.add_subplot(gs[0:2, 2])
    ax_btn.set_facecolor(PANEL_BG)
    ax_btn.set_xlim(0, 2.0)
    ax_btn.set_ylim(-0.25, 3.6)
    ax_btn.set_title('Botones', color=TEXT_COL, fontsize=9, pad=5)
    ax_btn.set_xticks([])
    ax_btn.set_yticks([])
    for sp in ax_btn.spines.values():
        sp.set_edgecolor(GRID_COL)

    btn_layout = [
        ('triangle', 0.5, 3.05),
        ('circle',   1.5, 3.05),
        ('square',   0.5, 2.15),
        ('cross',    1.5, 2.15),
        ('l1',       0.5, 1.25),
        ('options',  1.5, 1.25),
        ('r1',       1.0, 0.38),   # centrado, fila 4
    ]
    btn_circles  = {}
    btn_sym_txts = {}
    for name, cx, cy in btn_layout:
        _, sym, col, lbl = BUTTONS[name]
        circ = Circle((cx, cy), 0.35, fc=IDLE_COL, ec=col, lw=2.0, zorder=2)
        ax_btn.add_patch(circ)
        sym_t = ax_btn.text(cx, cy, sym,
                            ha='center', va='center',
                            fontsize=10, color=col, fontweight='bold', zorder=4)
        ax_btn.text(cx, cy - 0.47, lbl,
                    ha='center', va='top', fontsize=6.5, color='#777777')
        btn_circles[name]  = circ
        btn_sym_txts[name] = sym_t

    # ─── Barras de velocidad ──────────────────────────────────────────
    ax_bars = fig.add_subplot(gs[2, 0:2])
    ax_bars.set_facecolor(PANEL_BG)
    ax_bars.set_xlim(-1.15, 1.15)
    ax_bars.set_ylim(-0.25, 2.35)
    ax_bars.axvline(0,  color='#555555', lw=1.2)
    ax_bars.axvline(-1, color=GRID_COL,  lw=0.8, ls='--')
    ax_bars.axvline( 1, color=GRID_COL,  lw=0.8, ls='--')
    ax_bars.set_xticks([-1.0, -0.5, 0.0, 0.5, 1.0])
    ax_bars.set_xticklabels(['-100 %', '-50 %', '0', '+50 %', '+100 %'],
                              fontsize=7, color='#555555')
    ax_bars.set_yticks([0.5, 1.5])
    ax_bars.set_yticklabels(['  IZAJE', '  CARRO'], fontsize=8, color=TEXT_COL)
    ax_bars.set_title('Consignas de velocidad  (normalizado respecto al máximo)',
                       color=TEXT_COL, fontsize=9, pad=5)
    ax_bars.tick_params(colors='#555555')
    for sp in ax_bars.spines.values():
        sp.set_edgecolor(GRID_COL)

    # fondos de filas
    ax_bars.add_patch(Rectangle((-1, 1.15), 2, 0.7, fc='#1e2a40', ec='none', zorder=0))
    ax_bars.add_patch(Rectangle((-1, 0.15), 2, 0.7, fc='#1e2a40', ec='none', zorder=0))

    bar_carro = Rectangle((0, 1.15), 0, 0.7, fc=POS_COL, ec='none', zorder=3)
    bar_izaje = Rectangle((0, 0.15), 0, 0.7, fc=POS_COL, ec='none', zorder=3)
    ax_bars.add_patch(bar_carro)
    ax_bars.add_patch(bar_izaje)

    # anotaciones de límites
    for y, vmax, unit in [(1.5, MAX_VEL_CARRO, 'm/s'), (0.5, MAX_VEL_IZAJE, 'm/s')]:
        ax_bars.text(-1.0, y + 0.42, f'−{vmax:.1f} {unit}',
                     ha='left',  va='center', fontsize=6.5, color='#555555')
        ax_bars.text( 1.0, y + 0.42, f'+{vmax:.1f} {unit}',
                     ha='right', va='center', fontsize=6.5, color='#555555')

    txt_carro = ax_bars.text(0, 2.12, '0.00 m/s',
                              ha='center', va='center',
                              fontsize=9, color=ACCENT, fontweight='bold')
    txt_izaje = ax_bars.text(0, 1.05, '0.00 m/s',
                              ha='center', va='center',
                              fontsize=9, color=ACCENT, fontweight='bold')

    # ─── Panel de estado ──────────────────────────────────────────────
    ax_st = fig.add_subplot(gs[2, 2])
    ax_st.set_facecolor(PANEL_BG)
    ax_st.set_xlim(0, 1)
    ax_st.set_ylim(0, 1)
    ax_st.set_xticks([])
    ax_st.set_yticks([])
    ax_st.set_title('Estado del sistema', color=TEXT_COL, fontsize=9, pad=5)
    for sp in ax_st.spines.values():
        sp.set_edgecolor(GRID_COL)

    status_rows = [
        ('conn',      'Controlador:', 0.82),
        ('sys',       'Sistema:',     0.64),
        ('mode',      'Modo:',        0.46),
        ('twistlock', 'Twistlock:',   0.28),
        ('sway',      'Balanceo:',    0.10),
    ]
    status_txts = {}
    for key, lbl, y in status_rows:
        ax_st.text(0.04, y, lbl, ha='left', va='center',
                   fontsize=8, color='#777777')
        status_txts[key] = ax_st.text(0.96, y, '—',
                                       ha='right', va='center',
                                       fontsize=8, color=TEXT_COL,
                                       fontweight='bold')

    # franja de emergencia (top del panel de estado)
    emg_patch = FancyBboxPatch((0.0, 0.92), 1.0, 0.08,
                                boxstyle='round,pad=0.01',
                                fc='none', ec='none', zorder=5,
                                transform=ax_st.transData, clip_on=False)
    ax_st.add_patch(emg_patch)
    emg_text = ax_st.text(0.5, 0.96, '',
                           ha='center', va='center',
                           fontsize=7.5, color='white',
                           fontweight='bold', zorder=6)

    # pie de figura — izquierda: control | derecha: UDP
    conn_text = fig.text(0.05, 0.006, '[~] Buscando control PS4...',
                          ha='left', va='bottom', fontsize=8, color='#555555')
    udp_text  = fig.text(0.95, 0.006, f'UDP → {UDP_IP}:{UDP_PORT}',
                          ha='right', va='bottom', fontsize=8, color=ACCENT)

    artists = {
        'dot_ls': dot_ls, 'val_ls': val_ls,
        'dot_rs': dot_rs, 'val_rs': val_rs,
        'btn_circles':  btn_circles,
        'btn_sym_txts': btn_sym_txts,
        'bar_carro': bar_carro, 'bar_izaje': bar_izaje,
        'txt_carro': txt_carro, 'txt_izaje': txt_izaje,
        'status':    status_txts,
        'emg_patch': emg_patch,
        'emg_text':  emg_text,
        'conn_text': conn_text,
        'udp_text':  udp_text,
    }
    return fig, artists


# ══════════════════════════════════════════════════════════════════════
#  Actualización de animación
# ══════════════════════════════════════════════════════════════════════
def _update_bar(patch, val, max_val):
    n = float(np.clip(val / max_val, -1.0, 1.0))
    patch.set_x(min(0.0, n))
    patch.set_width(abs(n))
    patch.set_facecolor(POS_COL if n >= 0 else NEG_COL)


def _set_status(txts, key, text, color):
    txts[key].set_text(text)
    txts[key].set_color(color)


def update(_frame, artists):
    try:
        s = state

        # ── Sticks (Y invertido: abajo en pygame = abajo en pantalla) ────
        artists['dot_ls'].set_data([s['lx']], [-s['ly']])
        artists['dot_rs'].set_data([s['rx']], [-s['ry']])
        artists['val_ls'].set_text(f"{s['trolley_cmd']:+.2f} m/s")
        artists['val_rs'].set_text(f"{s['hoist_cmd']:+.2f} m/s")

        # Punto naranja al saturar
        for dot, cmd, mx in [
            (artists['dot_ls'], s['trolley_cmd'], MAX_VEL_CARRO),
            (artists['dot_rs'], s['hoist_cmd'],   MAX_VEL_IZAJE),
        ]:
            dot.set_color('#f39c12' if abs(cmd) >= 0.99 * mx else DOT_COL)

        # ── Botones ───────────────────────────────────────────────────────
        toggle_state = {
            'cross':    s['system_on'],
            'circle':   s['btn_raw']['circle'],
            'square':   s['twistlock_closed'],
            'triangle': s['mode_auto'],
            'l1':       s['sway_ctrl'],
            'options':  s['emergency'],
            'r1':       s['emgy_ack'],
        }
        for name, circ in artists['btn_circles'].items():
            _, _, col, _ = BUTTONS[name]
            active = toggle_state[name]
            circ.set_facecolor(col if active else IDLE_COL)
            circ.set_alpha(1.0 if active else 0.5)
            artists['btn_sym_txts'][name].set_color('white' if active else col)

        # ── Barras ────────────────────────────────────────────────────────
        _update_bar(artists['bar_carro'], s['trolley_cmd'], MAX_VEL_CARRO)
        _update_bar(artists['bar_izaje'], s['hoist_cmd'],   MAX_VEL_IZAJE)
        artists['txt_carro'].set_text(f"{s['trolley_cmd']:+.2f} m/s")
        artists['txt_izaje'].set_text(f"{s['hoist_cmd']:+.2f} m/s")

        # ── Estado del sistema ────────────────────────────────────────────
        st = artists['status']

        _set_status(st, 'conn',
                    'CONECTADO'  if s['connected']        else 'SIN CONTROL',
                    '#2ecc71'    if s['connected']         else '#e74c3c')

        _set_status(st, 'sys',
                    'ON'         if s['system_on']         else 'OFF',
                    '#2ecc71'    if s['system_on']         else '#888888')

        _set_status(st, 'mode',
                    'AUTO'       if s['mode_auto']         else 'MANUAL',
                    ACCENT       if s['mode_auto']         else '#f39c12')

        _set_status(st, 'twistlock',
                    'CERRADO'    if s['twistlock_closed']  else 'ABIERTO',
                    '#2ecc71'    if s['twistlock_closed']  else '#e67e22')

        _set_status(st, 'sway',
                    'ON'         if s['sway_ctrl']         else 'OFF',
                    '#8e44ad'    if s['sway_ctrl']         else '#888888')

        # ── Emergencia ────────────────────────────────────────────────────
        if s['emergency']:
            artists['emg_patch'].set_facecolor('#c0392b')
            artists['emg_text'].set_text('[!]  EMERGENCIA  --  presionar O para resetear')
        else:
            artists['emg_patch'].set_facecolor('none')
            artists['emg_text'].set_text('')

        # ── Pie de figura ─────────────────────────────────────────────────
        if s['connected']:
            name = joystick.get_name() if joystick else ''
            artists['conn_text'].set_text(f'● Control activo: {name}')
            artists['conn_text'].set_color('#2ecc71')
        else:
            artists['conn_text'].set_text('[~] Buscando control PS4...')
            artists['conn_text'].set_color('#555555')

        artists['udp_text'].set_color(ACCENT if udp_sock else '#555555')

    except Exception as e:
        print(f"[WARN] Error en frame de animacion: {e}")


# ══════════════════════════════════════════════════════════════════════
#  Main
# ══════════════════════════════════════════════════════════════════════
def main():
    global udp_sock
    udp_sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    print(f"[UDP] Enviando a {UDP_IP}:{UDP_PORT}  ({struct.calcsize(UDP_FMT)} bytes/paquete)")

    t = threading.Thread(target=_ps4_loop, daemon=True)
    t.start()

    fig, artists = build_figure()

    ani = animation.FuncAnimation(      # noqa: F841  (mantener referencia)
        fig, update,
        fargs=(artists,),
        interval=UPDATE_MS,
        cache_frame_data=False,
    )

    print("[PS4] Ventana abierta. Cerrar para salir.")
    try:
        plt.show()
    except KeyboardInterrupt:
        pass
    finally:
        if udp_sock:
            udp_sock.close()
        print("[PS4] Cerrado.")


if __name__ == '__main__':
    main()
