function [perfil_vel_x, perfil_vel_y, cantidad_puntos] = obtener_perfil_velocidad(puntos_x, puntos_y, v_h_max)
    parametros = struct(...
        'x', struct('a_max', 1, 'v_max', 4), ...
        'y', struct('a_max', 0.75, 'v_max', v_h_max) ...
    );

    perfil_vel_x = [];
    perfil_vel_y = [];

    perfil_vel_x = obtener_perfil_vel(puntos_x, puntos_y, 'x', parametros);
    perfil_vel_y = obtener_perfil_vel(puntos_y, puntos_x, 'y', parametros);

    tiempo_total = perfil_vel_x(1, end);
    
    cantidad_puntos = floor(tiempo_total / 5e-3);

    perfil_vel_x = interpolar_perfil(perfil_vel_x, cantidad_puntos);
    perfil_vel_y = interpolar_perfil(perfil_vel_y, cantidad_puntos);

    function perfil_vel = obtener_perfil_vel(puntos, puntos_aux, tipo, parametros)
        perfil_vel = [
            0; 
            0];
        t_ant = 0;
        for i = 1:numel(puntos)-1
            t1 = obtener_tiempo_espera(i, puntos, tipo, parametros);
            if tipo == 'x'
                t2 = obtener_tiempo_espera(i, puntos_aux, 'y', parametros);
            else
                t2 = obtener_tiempo_espera(i, puntos_aux, 'x', parametros);
            end

            if t1 >= t2
                v_max = parametros.(tipo).v_max;
                a_max = parametros.(tipo).a_max;
                perfil_velocidad = obtener_perfil_vel_aux(i, puntos, puntos_aux, tipo, t_ant, v_max, a_max);
            else
                v = 2 * abs(puntos(i+1) - puntos(i)) / t2;
                a = v / (t2 / 2);
                perfil_velocidad = obtener_perfil_vel_aux(i, puntos, puntos_aux, tipo, t_ant, v, a);
            end
            perfil_vel = [perfil_vel, perfil_velocidad];
            t_ant = perfil_vel(1, end); 
        end
    end

    function perfil_velocidad = obtener_perfil_vel_aux(i, puntos, puntos_aux, tipo, t_ant, v_max, a_max)
        t_trans = v_max / a_max;
        dist = (puntos(i+1) - puntos(i))
        t_cte = abs(dist) / v_max - t_trans;
        umbral = 5e-3;
        if t_cte > umbral
            perfil_velocidad = [
                t_ant + t_trans, t_ant + t_trans + t_cte, t_ant + t_trans*2 + t_cte;
                sign(dist)*v_max, sign(dist)*v_max, 0];
        elseif abs(t_cte) <= umbral
            perfil_velocidad = [
                t_ant + t_trans, t_ant + t_trans*2; 
                sign(dist)*v_max, 0];
        else
            if dist ~= 0
                v_x = sqrt(a_max*dist)
                t_x = dist/v_x;
                perfil_velocidad = [
                    t_ant + t_x, t_ant + t_x*2;
                    sign(dist)*v_x, 0];
            else
                tiempo = obtener_tiempo_espera(i, puntos_aux, tipo, parametros);
                perfil_velocidad = [
                    t_ant + tiempo;
                    0];
            end
        end
    end

    function tiempo = obtener_tiempo_espera(i, puntos, tipo, parametros)
        v_max = parametros.(tipo).v_max;
        a_max = parametros.(tipo).a_max;
        t_trans = v_max / a_max;
        tiempo = 0;
        dist = abs(puntos(i+1) - puntos(i));
        t_cte = dist / v_max - t_trans;
        if t_cte > 0
            tiempo = t_trans*2 + t_cte;
        elseif t_cte == 0
            tiempo = t_trans*2;
        else
            if dist ~= 0
                tiempo = sqrt(dist/a_max) * 2;
            end
        end
    end

    function perfil_interp = interpolar_perfil(perfil, cantidad_puntos)
        t_vals_discretizados = linspace(perfil(1, 1), perfil(1, end), cantidad_puntos);
        v_vals_discretizados = interp1(perfil(1, :), perfil(2, :), t_vals_discretizados, 'linear');
        perfil_interp = [t_vals_discretizados', v_vals_discretizados'];
    end
end