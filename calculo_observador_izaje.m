%% CÁLCULO DEL OBSERVADOR DE ESTADOS - IZAJE
gain_CL;
parametros;
% 1. Parámetros equivalentes (reflejados al motor)
J_eq_h = J_hm_hb + (J_hd_hEb / i_h^2);
b_eq_h = b_hm + (b_hd / i_h^2);

% 2. Matrices del Espacio de Estados
Ah = [0, 1; 
      0, -b_eq_h / J_eq_h];

Bch = [0, 0, 0;
       1/J_eq_h, 1/J_eq_h, 1/(i_h*J_eq_h)];

Bdh = [0; 
      -r_hd / (i_h * J_eq_h)];

Ch = [1, 0];

% 3. Sintonía de Ganancias Lh
% Se utiliza la frecuencia de diseño calculada en gain_CL.m
frecuencia_control_h = abs(w_des_h); 
factor_obs_h = 6; 
polo_h_base = -factor_obs_h * frecuencia_control_h;

% Ubicación de polos (se separan un 5% para estabilidad del comando place)
polos_h = [polo_h_base, polo_h_base * 1.05];

% Cálculo de la matriz de ganancias Lh
Lh = place(Ah', Ch', polos_h)';

disp('--- RESULTADOS OBSERVADOR IZAJE ---');
fprintf('Frecuencia PID Izaje (w_des_h): %.4f rad/s\n', frecuencia_control_h);
disp('Matriz de Ganancias Lh:');
disp(Lh);