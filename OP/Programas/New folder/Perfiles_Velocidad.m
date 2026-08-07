
function [velocidad_X, velocidad_Y, x, y, cantidad_puntos] = Perfiles_Velocidad(puntos_trayectoria, v_h_max)
    velocidad_X = 0;
    velocidad_Y = 0;
    vmax_X = 4;
    vmax_Y = v_h_max;
    amax_X = 1;
    amax_Y = 0.75;
    
    Tx1 = vmax_X/amax_X;
    Tx3 = vmax_X/amax_X;
    
    Ty1 = vmax_Y/amax_Y;
    Ty3 = vmax_Y/amax_Y;
    tiempo = 0;
    vx = 0;
    vy = 0;
    x = puntos_trayectoria(1, 1);
    y = puntos_trayectoria(1, 2);
    
    % Análisis por tramos
    for i = 2: length(puntos_trayectoria(:, 1))
        dx = puntos_trayectoria(i,1) - puntos_trayectoria(i-1,1);
        dy = puntos_trayectoria(i,2) - puntos_trayectoria(i-1,2);
        
        if (dx ~= 0 && dy ~= 0)
            Tx2 = (abs(dx) - Tx1*vmax_X - Tx3*vmax_X)/vmax_X;
            Ty2 = (abs(dy) - Ty1*vmax_Y - Ty3*vmax_Y)/vmax_Y;

            Tx = Tx1 + Tx2 + Tx3;
            Ty = Ty1 + Ty2 + Ty3;
            if Tx >= Ty
                [t, sx, velocidad_X] = generar_perfil_trapezoidal(0, vmax_X, amax_X, dx, x(1,end));
                [t, sy, velocidad_Y] = generar_perfil_trapezoidal_modificado(0, t(1,end), dy, y(1,end));
                auxT = (tiempo(1,end)):5e-3:(tiempo(1,end) + t(1,end));
            
                tiempo = [tiempo, auxT];
                vx = [vx, velocidad_X];
                vy = [vy, velocidad_Y];
                x = [x, sx];
                y = [y, sy];
            elseif Ty > Tx
                [t, sy, velocidad_Y] = generar_perfil_trapezoidal(0, vmax_Y, amax_Y, dy, y(1,end));
                [t, sx,velocidad_X] = generar_perfil_trapezoidal_modificado(0, t(1,end), dx, x(1,end));
                auxT = (tiempo(1,end)):5e-3:(tiempo(1,end) + t(1,end));

                tiempo = [tiempo, auxT];
                vx = [vx, velocidad_X];
                vy = [vy, velocidad_Y];
                x = [x, sx];
                y = [y, sy];
            end
        elseif (dx ~= 0 && dy == 0) % listo
            [t, sx,velocidad_X] = generar_perfil_trapezoidal(0, vmax_X, amax_X, dx, x(1,end));
            velocidad_Y = zeros(size(velocidad_X));
            sy = y(1,end)*ones(size(sx));
            auxT = (tiempo(1,end)):5e-3:(tiempo(1,end) + t(1,end));
            tiempo = [tiempo, auxT];
            vx = [vx, velocidad_X];
            vy = [vy, velocidad_Y];
            x = [x, sx];
            y = [y, sy];
        elseif (dx ==0 && dy ~= 0) % listo
            [t, sy,velocidad_Y] = generar_perfil_trapezoidal(0, vmax_Y, amax_Y, dy, y(1,end));
            velocidad_X = zeros(size(velocidad_Y));
            sx = x(1,end)* ones(size(sy));
            auxT = (tiempo(1,end)):5e-3:(tiempo(1,end) + t(1,end));
            tiempo = [tiempo, auxT];
            vx = [vx, velocidad_X];
            vy = [vy, velocidad_Y];
            x = [x, sx];
            y = [y, sy];
        end
        
    end
length(tiempo)
cantidad_puntos = size(tiempo, 2);
%     size(x)
%     size(y)
%     figure
%     plot(tiempo, vx)
%     xlabel('Tiempo');
%     ylabel('Velocidad');
%     figure
%     plot(tiempo, vy);
%     xlabel('Tiempo');
%     ylabel('Velocidad');
%     figure
%     plot(x, y);
%     xlabel('X');
%     ylabel('Y');
%     
end

function [t, s, v] = generar_perfil_trapezoidal(ti, vmax, amax, d, si)
    % Calcula el tiempo de aceleración y desaceleración
    t_acel_dacel = vmax / amax; % Tiempo de aceleración
    % Calcula la distancia recorrida en ese tiempo (con velocidad inicial 0)
    d13 = 2*amax*(t_acel_dacel^2)/2;
    
    if (d-d13) == 0
        % Genera el vector de tiempo
        t_total = t_acel_dacel*2;
        t = ti:5e-3:t_total;
        
        % Calcula el perfil de posición
        s = zeros(size(t));
        v = zeros(size(t));
        s(1,1) = si;
        
        for i = 2:length(t)
            if t(i) < (ti + t_acel_dacel)
                % Fase de aceleración
                s(i) = s(i-1) + 0.5 * amax * (t(i) - t(i-1))^2 + v(i-1)*(t(i)-t(i-1));
                v(i) = v(i-1) + amax * (t(i) - t(i-1));
            else 
                % Fase de desaceleración
                s(i) = s(i-1) - 0.5 * amax * (t(i) - t(i-1))^2 + v(i-1)*(t(i)-t(i-1));
                v(i) = v(i-1) - amax * (t(i) - t(i-1));
            end
        end
    elseif (d-d13) > 0
        % Genera el vector de tiempo
        t_vel_cte = (d-d13)/vmax;
        t_total = t_acel_dacel*2 + t_vel_cte;
        t = ti:5e-3:t_total;
        
        % Calcula el perfil de posición
        s = zeros(size(t));
        v = zeros(size(t));
        s(1,1) = si;
        for i = 2:length(t)
            if t(i) < (ti + t_acel_dacel)
                % Fase de aceleración
                s(i) = s(i-1) + 0.5 * amax * (t(i) - t(i-1))^2 + v(i-1)*(t(i)-t(i-1));
                v(i) = v(i-1) + amax * (t(i) - t(i-1));
            elseif t(i) > (ti + t_acel_dacel) && t(i) < (ti + t_acel_dacel + t_vel_cte)
                % Fase de velocidad constante
                s(i) = s(i-1) + vmax*(t(i)-t(i-1));
                v(i) = vmax;
            else 
                % Fase de desaceleración
                s(i) = s(i-1) - 0.5 * amax * (t(i) - t(i-1))^2 + v(i-1)*(t(i)-t(i-1));
                v(i) = v(i-1) - amax * (t(i) - t(i-1));
            end
        end
        
    elseif (d-d13) < 0
        
        t_total = t_acel_dacel*2;
        t = ti:5e-3:t_total;
        
        % Calcula el perfil de posición
        s = zeros(size(t));
        v = zeros(size(t));
        s(1,1) = si;
        
        amax = (d/2)*2/((t_total/2)^2);
        for i = 2:length(t)
            if t(i) < (ti + t_acel_dacel)
                % Fase de aceleración
                s(i) = s(i-1) + 0.5 * amax * (t(i) - t(i-1))^2 + v(i-1)*(t(i)-t(i-1));
                v(i) = v(i-1) + amax * (t(i) - t(i-1));
            else 
                % Fase de desaceleración
                s(i) = s(i-1) - 0.5 * amax * (t(i) - t(i-1))^2 + v(i-1)*(t(i)-t(i-1));
                v(i) = v(i-1) - amax * (t(i) - t(i-1));
            end
        end    
    end
    % Ajusta el último valor de la velocidad a 0 para evitar errores numéricos
    v(end) = 0;
end
function [t, s, v] = generar_perfil_trapezoidal_modificado(ti, t_total, d, si)
    
    t = ti:5e-3:t_total;

    % Calcula el perfil de posición
    s = zeros(size(t));
    v = zeros(size(t));
    s(1,1) = si;

    amax = (d/2)*2/((t_total/2)^2);
    for i = 2:length(t)
        if t(i) < (ti + t_total/2)
            % Fase de aceleración
            s(i) = s(i-1) + 0.5 * amax * (t(i) - t(i-1))^2 + v(i-1)*(t(i)-t(i-1));
            v(i) = v(i-1) + amax * (t(i) - t(i-1));
        else 
            % Fase de desaceleración
            s(i) = s(i-1) - 0.5 * amax * (t(i) - t(i-1))^2 + v(i-1)*(t(i)-t(i-1));
            v(i) = v(i-1) - amax * (t(i) - t(i-1));
        end
    end    

    % Ajusta el último valor de la velocidad a 0 para evitar errores numéricos
    v(end) = 0;
end
