---
name: rt-view-context
description: Estado actual del módulo RT_VIEW — arquitectura, variables, archivos y decisiones de diseño
metadata:
  type: project
---

## Archivos

| Archivo | Rol |
|---|---|
| `RT_VIEW/visualizacion_grua.py` | Visualización 2D animada principal (matplotlib + FuncAnimation) |
| `RT_VIEW/udp_send_xt.m` | MATLAB Function para enviar x_t_hat por UDP (alternativa, no usada actualmente) |
| `RT_VIEW/gen_xt_trayectoria.m` | MATLAB Function: genera perfil trapezoidal x_t(t) para pruebas, conectar a UDP Send block |

## Arquitectura de comunicación

- **Dirección**: Simulink → Python (UDP)
- **IP/Puerto**: `127.0.0.1:5010`
- **Formato**: `double` little-endian (`<d`, 8 bytes) — default del bloque UDP Send de Simulink
- **Detección automática de formato**: el receptor acepta 4B (float32) u 8B (double) según tamaño del paquete
- **Intervalo de animación**: 50 ms (`SIM_UPDATE_MS`)
- **Timeout desconexión**: 1.0 s sin paquete → SIMULINK: DESCONECTADO

## Variables recibidas de Simulink (hasta ahora)

| Variable | Descripción | Unidad |
|---|---|---|
| `x_t_hat` | Posición estimada del carro | m |

## Variables de estado (demo/hardcoded por ahora)

| Variable | Descripción | Unidad |
|---|---|---|
| `l_h` | Longitud de cable de izaje | m |
| `theta_l` | Ángulo de balanceo | rad |
| `masa_est` | Masa estimada de la carga | kg |
| `modo` | AUTOMÁTICO / MANUAL | — |
| `BRK_t/h/hE` | Frenos carro/izaje/emergencia | bool |
| `TLK` | Twistlock (carga enganchada) | bool |
| `SWAY_CTR` | Controlador de balanceo activo | bool |

## Geometría del sistema (de parametros.m)

- `Y_t0 = 45 m` — altura de poleas (boom)
- `x_t ∈ [-30, 50] m` — rango del carro
- `y_h ∈ [-20, 40] m` — rango de izaje
- `DOCK_X_END = 0 m` — borde del muelle
- `SHIP_X_START = 2.5 m`, `SHIP_X_END = 47.5 m` — barco
- 5 camiones en x = [-25, -20, -15, -10, -5] m (borde izquierdo, ancho = W_c = 2.44 m)
- `H_truck = 1.0 m` — altura del camión

## Panel de estado (pax — axes derecho)

- Sección "Continuas": x̂_t, l_h, y_h, θ_l, m̂
- Sección "Discretas": BRK_t, BRK_h, BRK_hE, TLK, SWAY_CTR (pastillas ON/OFF verde/rojo)
- Indicador SIMULINK fuera del plot (fig.text) — verde/rojo
- Indicador MODO dentro del plot esquina superior izquierda — verde (auto) / naranja (manual)

## Artistas dinámicos (actualizados en update_frame)

`dyn_trolley`, `dyn_trolley_edge`, `dyn_wheel_l/r`, `dyn_pulley`, `dyn_cable`, `dyn_spr`, `dyn_spr_e`, `dyn_cont`, `dyn_cont_e`, `dyn_val_txts`, `dyn_sim_txt`

## Próximos pasos acordados

- Ir agregando más variables de Simulink progresivamente (l_h, theta_l, discretas, etc.)
- Mejorar la visualización con más detalle visual
