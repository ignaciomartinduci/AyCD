"""
diagnostico_control.py
Muestra en tiempo real TODOS los ejes y botones detectados por pygame.
Ejecutar ANTES de usar controller_reader.py para verificar índices.

Uso: python diagnostico_control.py
"""

import os
os.environ['PYGAME_HIDE_SUPPORT_PROMPT'] = '1'

import threading
import time
import pygame
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from matplotlib.gridspec import GridSpec
from matplotlib.patches import Rectangle

UPDATE_MS = 50
MAX_AXES  = 4
MAX_BTNS  = 16

# ══════════════════════════════════════════════════════════════════════
#  Estado compartido (hilo pygame → hilo matplotlib)
# ══════════════════════════════════════════════════════════════════════
shared = {
    'connected':   False,
    'name':        '',
    'n_axes':      0,
    'n_btns':      0,
    'axes':        [0.0] * MAX_AXES,
    'buttons':     [False] * MAX_BTNS,
    'last_btn':    None,
}


# ══════════════════════════════════════════════════════════════════════
#  Hilo pygame (daemon)
# ══════════════════════════════════════════════════════════════════════
def _pygame_loop():
    pygame.init()
    pygame.joystick.init()
    joystick = None

    while True:
        try:
            pygame.event.pump()

            if pygame.joystick.get_count() == 0:
                if joystick is not None:
                    print("[DIAG] Control desconectado.")
                joystick = None
                shared['connected'] = False
                time.sleep(UPDATE_MS / 1000.0)
                continue

            if joystick is None:
                joystick = pygame.joystick.Joystick(0)
                joystick.init()
                shared['name']   = joystick.get_name()
                shared['n_axes'] = min(joystick.get_numaxes(), MAX_AXES)
                shared['n_btns'] = min(joystick.get_numbuttons(), MAX_BTNS)
                shared['connected'] = True
                print(f"[DIAG] Conectado: {shared['name']}")

            for i in range(shared['n_axes']):
                shared['axes'][i] = joystick.get_axis(i)

            for i in range(shared['n_btns']):
                pressed = bool(joystick.get_button(i))
                shared['buttons'][i] = pressed
                if pressed:
                    shared['last_btn'] = i

        except BaseException as e:
            print(f"[DIAG] Error: {e}")
            joystick = None
            shared['connected'] = False

        time.sleep(UPDATE_MS / 1000.0)


# ══════════════════════════════════════════════════════════════════════
#  Figura
# ══════════════════════════════════════════════════════════════════════
BG       = '#0f0f1a'
PANEL_BG = '#16213e'
GRID_COL = '#2a2a4a'
TEXT_COL = '#e0e0e0'
ACCENT   = '#00b4d8'
POS_COL  = '#2ecc71'
NEG_COL  = '#e74c3c'
IDLE_COL = '#2d2d4e'

fig = plt.figure(figsize=(14, 8), facecolor=BG)
try:
    fig.canvas.manager.set_window_title('Diagnostico - Control PS4')
except Exception:
    pass

plt.rcParams.update({'font.family': 'monospace', 'text.color': TEXT_COL})

gs = GridSpec(2, 1, figure=fig,
              left=0.05, right=0.97, top=0.88, bottom=0.06,
              hspace=0.50)

fig.text(0.5, 0.96, 'Diagnostico de Control',
         ha='center', va='top', fontsize=13, fontweight='bold', color=ACCENT)
device_txt = fig.text(0.05, 0.935, '[~] Buscando control...',
                      ha='left', va='center', fontsize=9, color='#888888')

# ── Panel de ejes ─────────────────────────────────────────────────────
ax_axes = fig.add_subplot(gs[0])
ax_axes.set_facecolor(PANEL_BG)
ax_axes.set_xlim(-0.5, MAX_AXES - 0.5)
ax_axes.set_ylim(-1.3, 1.3)
ax_axes.set_title('Ejes analogicos  (mover sticks)',
                  color=TEXT_COL, fontsize=10, pad=6)
ax_axes.axhline(0, color='#444', lw=0.8)
ax_axes.axhline( 1, color=GRID_COL, lw=0.5, ls='--')
ax_axes.axhline(-1, color=GRID_COL, lw=0.5, ls='--')
ax_axes.set_xticks(range(MAX_AXES))
ax_axes.set_xticklabels([f'Eje {i}' for i in range(MAX_AXES)],
                         fontsize=8, color='#888')
ax_axes.set_yticks([-1, -0.5, 0, 0.5, 1])
ax_axes.set_yticklabels(['-1', '-0.5', '0', '+0.5', '+1'],
                         fontsize=8, color='#555')
for sp in ax_axes.spines.values():
    sp.set_edgecolor(GRID_COL)

axis_bars = []
axis_txts = []
for i in range(MAX_AXES):
    bar = Rectangle((i - 0.35, 0), 0.7, 0, fc=POS_COL, ec='none', zorder=3)
    ax_axes.add_patch(bar)
    axis_bars.append(bar)
    txt = ax_axes.text(i, 0.05, '0.00', ha='center', va='bottom',
                       fontsize=7, color=ACCENT, zorder=4)
    axis_txts.append(txt)

# ── Panel de botones ──────────────────────────────────────────────────
ax_btns = fig.add_subplot(gs[1])
ax_btns.set_facecolor(PANEL_BG)
ax_btns.set_xlim(-0.5, MAX_BTNS - 0.5)
ax_btns.set_ylim(-0.5, 1.5)
ax_btns.set_title('Botones  (presionar cada uno para ver su indice)',
                  color=TEXT_COL, fontsize=10, pad=6)
ax_btns.set_xticks(range(MAX_BTNS))
ax_btns.set_xticklabels([f'{i}' for i in range(MAX_BTNS)],
                          fontsize=9, color='#888')
ax_btns.set_yticks([])
for sp in ax_btns.spines.values():
    sp.set_edgecolor(GRID_COL)

btn_patches = []
btn_txts    = []
for i in range(MAX_BTNS):
    rect = Rectangle((i - 0.40, 0.1), 0.8, 0.8,
                     fc=IDLE_COL, ec='#333', lw=1.2, zorder=2)
    ax_btns.add_patch(rect)
    btn_patches.append(rect)
    t = ax_btns.text(i, 0.5, str(i), ha='center', va='center',
                     fontsize=9, color='#555', fontweight='bold', zorder=3)
    btn_txts.append(t)

last_btn_txt = fig.text(0.5, 0.025, 'Ultimo boton presionado: --',
                         ha='center', va='bottom', fontsize=10, color=ACCENT)


# ══════════════════════════════════════════════════════════════════════
#  Actualización (solo lee shared, sin tocar pygame)
# ══════════════════════════════════════════════════════════════════════
def update(_frame):
    try:
        if not shared['connected']:
            device_txt.set_text('[~] Sin control — conectar y esperar...')
            device_txt.set_color('#e74c3c')
            return

        device_txt.set_text(
            f'● Conectado: {shared["name"]}  '
            f'({shared["n_axes"]} ejes, {shared["n_btns"]} botones)'
        )
        device_txt.set_color('#2ecc71')

        for i, (bar, txt) in enumerate(zip(axis_bars, axis_txts)):
            v = shared['axes'][i]
            bar.set_y(min(0.0, v))
            bar.set_height(abs(v))
            bar.set_facecolor(POS_COL if v >= 0 else NEG_COL)
            txt.set_text(f'{v:+.2f}')
            txt.set_y(v + (0.04 if v >= 0 else -0.12))
            txt.set_color(POS_COL if v >= 0 else NEG_COL)

        for i, (rect, txt) in enumerate(zip(btn_patches, btn_txts)):
            if i < shared['n_btns']:
                pressed = shared['buttons'][i]
                rect.set_facecolor('#f39c12' if pressed else IDLE_COL)
                rect.set_alpha(1.0)
                txt.set_color('black' if pressed else '#555')
            else:
                rect.set_alpha(0.1)
                txt.set_color('#222')

        if shared['last_btn'] is not None:
            last_btn_txt.set_text(
                f'Ultimo boton presionado: indice {shared["last_btn"]}'
            )

    except Exception as e:
        print(f"[WARN] {e}")


# ══════════════════════════════════════════════════════════════════════
#  Main
# ══════════════════════════════════════════════════════════════════════
t = threading.Thread(target=_pygame_loop, daemon=True)
t.start()

ani = animation.FuncAnimation(
    fig, update,
    interval=UPDATE_MS,
    cache_frame_data=False,
)

print("=" * 55)
print("  DIAGNOSTICO DE CONTROL")
print("=" * 55)
print("  Mover cada stick → ver que indice de eje se mueve")
print("  Presionar cada boton → ver que indice se ilumina")
print("  Cerrar ventana para salir")
print("=" * 55)

try:
    plt.show()
except KeyboardInterrupt:
    pass
