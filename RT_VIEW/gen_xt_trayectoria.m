function x_t = gen_xt_trayectoria(t)
% GEN_XT_TRAYECTORIA  Genera x_t [m] siguiendo un perfil trapezoidal
%   de velocidad que va y vuelve entre x_inicio y x_fin.
%
%   Entrada : t  — tiempo de simulación [s]  (scalar)
%   Salida  : x_t — posición del carro [m]
%
%   Conectar salida al bloque UDP Send apuntando a 127.0.0.1:5010.

    % ── Parámetros de trayectoria ─────────────────────────────────────
    x_inicio =  -25.0;   % [m]
    x_fin    =   45.0;   % [m]
    v_max    =    4.0;   % [m/s]   límite de velocidad del carro
    a_max    =    0.8;   % [m/s²]  límite de aceleración

    % ── Perfil trapezoidal (ida y vuelta en bucle) ────────────────────
    distancia = abs(x_fin - x_inicio);

    % Tiempo de rampa (aceleración / frenado)
    t_rampa = v_max / a_max;
    d_rampa = 0.5 * a_max * t_rampa^2;

    if 2 * d_rampa >= distancia
        % Perfil triangular (no alcanza v_max)
        t_rampa  = sqrt(distancia / a_max);
        v_pico   = a_max * t_rampa;
        t_cruise = 0;
    else
        v_pico   = v_max;
        t_cruise = (distancia - 2 * d_rampa) / v_max;
    end

    T_ida    = 2 * t_rampa + t_cruise;   % duración de un sentido
    T_ciclo  = 2 * T_ida;                % ida + vuelta

    % Tiempo dentro del ciclo actual
    t_mod = mod(t, T_ciclo);

    % Determinar sentido
    if t_mod < T_ida
        tau = t_mod;
        sentido = 1;   % ida
    else
        tau = t_mod - T_ida;
        sentido = -1;  % vuelta
    end

    % Posición dentro del segmento (perfil trapezoidal)
    if tau < t_rampa
        % Aceleración
        d = 0.5 * a_max * tau^2;
    elseif tau < t_rampa + t_cruise
        % Velocidad constante
        d = d_rampa + v_pico * (tau - t_rampa);
    else
        % Frenado
        dt = tau - t_rampa - t_cruise;
        d  = distancia - 0.5 * a_max * (t_rampa - dt)^2;
    end

    d = max(0, min(distancia, d));

    if sentido == 1
        x_t = x_inicio + d;
    else
        x_t = x_fin    - d;
    end

end
