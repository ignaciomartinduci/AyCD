"""
diagnostico_control.py
Muestra en tiempo real TODOS los ejes y botones detectados por pygame.
Ejecutar ANTES de usar controller_reader.py para verificar índices.

Uso: python diagnostico_control.py
"""

import os
os.environ['PYGAME_HIDE_SUPPORT_PROMPT'] = '1'

import pygame
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from matplotlib.gridspec import GridSpec
from matplotlib.patches import Rectangle
import numpy as np

UPDATE_MS = 50

# ══════════════════════════════════════════════════════════════════════
#  Inicialización
# ══════════════════════════════════════════════════════════════════════
pygame.init()
pygame.joystick.init()

joystick = None
n_axes   = 0
n_btns   = 0


def init_joystick():
    global joystick, n_axes, n_btns
    if pygame.joystick.get_count() == 0:
        return False
    joystick = pygame.joystick.Joystick(0)
    joystick.init()
    n_axes = joystick.get_numaxes()
    n_btns = joystick.get_numbuttons()
    return True


init_joystick()

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

MAX_AXES = 12
MAX_BTNS = 16

fig = plt.figure(figsize=(14, 8), facecolor=BG)
try:
    fig.canvas.manager.set_window_title('Diagnóstico – Control PS4')
except Exception:
    pass

plt.rcParams.update({'font.family': 'monospace', 'text.color': TEXT_COL})

gs = GridSpec(2, 1, figure=fig,
              left=0.05, right=0.97, top=0.88, bottom=0.06,
              hspace=0.50)

# ── Título y texto de estado ──────────────────────────────────────────
title_txt = fig.text(0.5, 0.96, 'Diagnóstico de Control',
                     ha='center', va='top', fontsize=13,
                     fontweight='bold', color=ACCENT)
device_txt = fig.text(0.5, 0.91, '⏳ Buscando control...',
                      ha='center', va='top', fontsize=9, color='#888888')

# ── Panel de ejes ─────────────────────────────────────────────────────
ax_axes = fig.add_subplot(gs[0])
ax_axes.set_facecolor(PANEL_BG)
ax_axes.set_xlim(-0.5, MAX_AXES - 0.5)
ax_axes.set_ylim(-1.3, 1.3)
ax_axes.set_title('Ejes analógicos  (mover sticks y gatillos)',
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

# Barras para ejes (una por eje)
axis_bars  = []
axis_txts  = []
axis_idxs  = []   # textos de índice arriba

for i in range(MAX_AXES):
    bar = Rectangle((i - 0.35, 0), 0.7, 0,
                    fc=POS_COL, ec='none', zorder=3)
    ax_axes.add_patch(bar)
    axis_bars.append(bar)

    txt = ax_axes.text(i, 0.05, '0.00',
                       ha='center', va='bottom',
                       fontsize=7, color=ACCENT, zorder=4)
    axis_txts.append(txt)

    idx_txt = ax_axes.text(i, -1.22, f'{i}',
                            ha='center', va='bottom',
                            fontsize=8, color='#555', fontweight='bold')
    axis_idxs.append(idx_txt)

# ── Panel de botones ──────────────────────────────────────────────────
ax_btns = fig.add_subplot(gs[1])
ax_btns.set_facecolor(PANEL_BG)
ax_btns.set_xlim(-0.5, MAX_BTNS - 0.5)
ax_btns.set_ylim(-0.5, 1.5)
ax_btns.set_title('Botones digitales  (presionar cada botón para ver su índice)',
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
                     fc=IDLE_COL, ec='#333', lw=1.2,
                     zorder=2)
    ax_btns.add_patch(rect)
    btn_patches.append(rect)

    t = ax_btns.text(i, 0.5, str(i),
                     ha='center', va='center',
                     fontsize=9, color='#555',
                     fontweight='bold', zorder=3)
    btn_txts.append(t)

# Texto de último botón presionado
last_btn_txt = fig.text(0.5, 0.025,
                         'Último botón presionado: —',
                         ha='center', va='bottom',
                         fontsize=10, color=ACCENT)
last_pressed = {'btn': None}


# ══════════════════════════════════════════════════════════════════════
#  Actualización
# ══════════════════════════════════════════════════════════════════════
def update(_frame):
    global joystick, n_axes, n_btns

    pygame.event.pump()

    # Reconexión en caliente
    if joystick is None:
        if not init_joystick():
            device_txt.set_text('⏳ Ningún control detectado — conectar y esperar...')
            device_txt.set_color('#e74c3c')
            return
        device_txt.set_text(
            f'● Conectado: {joystick.get_name()}  '
            f'({n_axes} ejes, {n_btns} botones)'
        )
        device_txt.set_color('#2ecc71')

    try:
        # ── Ejes ──────────────────────────────────────────────────────
        for i, (bar, txt) in enumerate(zip(axis_bars, axis_txts)):
            if i < n_axes:
                v = joystick.get_axis(i)
                # barra desde 0 hasta v
                bar.set_y(min(0.0, v))
                bar.set_height(abs(v))
                bar.set_facecolor(POS_COL if v >= 0 else NEG_COL)
                bar.set_alpha(1.0)
                txt.set_text(f'{v:+.2f}')
                txt.set_y(v + (0.04 if v >= 0 else -0.12))
                txt.set_color(POS_COL if v >= 0 else NEG_COL)
            else:
                bar.set_height(0)
                bar.set_alpha(0.15)
                txt.set_text('')

        # ── Botones ───────────────────────────────────────────────────
        for i, (rect, txt) in enumerate(zip(btn_patches, btn_txts)):
            if i < n_btns:
                pressed = bool(joystick.get_button(i))
                rect.set_facecolor('#f39c12' if pressed else IDLE_COL)
                rect.set_alpha(1.0)
                txt.set_color('black' if pressed else '#555')
                if pressed:
                    last_pressed['btn'] = i
            else:
                rect.set_alpha(0.1)
                txt.set_color('#222')

        if last_pressed['btn'] is not None:
            last_btn_txt.set_text(
                f'Último botón presionado: índice {last_pressed["btn"]}'
            )

    except pygame.error:
        joystick = None
        device_txt.set_text('⚠ Control desconectado')
        device_txt.set_color('#e74c3c')


ani = animation.FuncAnimation(
    fig, update,
    interval=UPDATE_MS,
    cache_frame_data=False,
)

print("=" * 55)
print("  DIAGNÓSTICO DE CONTROL")
print("=" * 55)
print("  Mover cada stick/gatillo → ver qué índice de eje se mueve")
print("  Presionar cada botón     → ver qué índice se ilumina")
print("  Cerrar ventana para salir")
print("=" * 55)

try:
    plt.show()
except KeyboardInterrupt:
    pass
finally:
    pygame.quit()
