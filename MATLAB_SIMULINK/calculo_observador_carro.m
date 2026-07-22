%% CÁLCULO DEL OBSERVADOR DE ESTADOS - PARTE 1: Matrices y Observabilidad
% 1. Ecuaciones equivalentes reflejadas al eje del motor
% (Se utilizan los parámetros cargados previamente en el Workspace)
J_eq_m = J_tm_tb + (J_td / i_t^2);
b_eq_m = b_tm + (b_td / i_t^2);
rel = r_td / i_t;

% 2. Construcción de Matrices de Espacio de Estados
% Matriz A (Dinámica del sistema)
At = [ 0, 1, 0, 0;
     -(rel^2 * K_tw)/J_eq_m,  -(b_eq_m + rel^2 * b_tw)/J_eq_m,   (rel * K_tw)/J_eq_m,   (rel * b_tw)/J_eq_m;
      0, 0, 0, 1;
      (rel * K_tw)/M_t,        (rel * b_tw)/M_t,                -K_tw/M_t,             -(b_tw + b_t)/M_t ];

% Matriz Bc (Entradas de Control: Torque del Motor y Freno)
Bct = [ 0, 0;
       1/J_eq_m, 1/J_eq_m;
       0, 0;
       0, 0 ];

% Matriz Bd (Entrada de Perturbación: Fuerza del péndulo)
Bdt = [ 0;
       0;
       0;
       2/M_t ];

% Matriz C (Salida Medida: Posición del encoder)
Ct = [ 1, 0, 0, 0 ];


%% CÁLCULO DEL OBSERVADOR DE ESTADOS - PARTE 2: Ganancias (L)

% 1. Extraemos la frecuencia dominante deseada del PID de tu script
% (Asume que w_des_t ya está calculada en el Workspace)
frecuencia_pid = abs(w_t); 

% 2. Aplicamos la regla de diseño: Observador 4 veces más rápido que el PID
factor_obs = 10; % 10 0k
polo_base = -factor_obs * frecuencia_pid;

% 3. Ubicación de los 4 polos
% Los separamos ligeramente (5%) para que el comando 'place' no tire error
% por multiplicidad de polos superior al rango de la matriz C.
polos_deseados = [polo_base, polo_base*1.02, polo_base*1.05, polo_base*1.07]; 

% disp('--- PARTE 2: SINTONÍA DEL OBSERVADOR ---');
% fprintf('Frecuencia deseada del PID (w_des_t): %.4f rad/s\n', frecuencia_pid);
% disp('Polos seleccionados para el observador:');
% disp(polos_deseados);

% 4. Cálculo de la matriz L
Lt = place(At', Ct', polos_deseados)';

