% Flags de ejecución
escenario = 1; % 0: espera- 1: ciclo simple carga - 2: ciclo simple descarga - 3: ciclo doble (carga + descarga)

% Parámetros dados
Y_t0 = 45; %  [m] Altura fija de poleas de suspension de izaje en el carro
H_c = 2.59; % [m] Altura del container estandar
W_c = 2.44; % [m] Ancho del contenedor estandar
Y_sb = 5.0; % [m] Despeje sobre borde de muelle
M_s = 15000; % [kg] Masa de spreader + headblock
M_cmax = 50000; % [kg] Masa de container máxima a cargar (lleno)
M_cmin = 2000; % [kg] Masa de container mínima a cargar (vacío)
g = 9.80665; % [m/s2] Aceleración gravitatoria

% Máximos y mínimos de parámetros

a_t_max = 0.8; % [m/s^2] Módulo de aceleración máxima del carro
a_t_max_al = 0.15; % [m/s^2] Mitad del módulo de aceleración máxima del carro

x_t_min = -30; % [m] Límite traslación carro mínimo
x_t_max = 50; % [m] Límite traslación carro mínimo
x_t_minE = x_t_min-0.5; % [m] Límite traslación carro mínimo emergencia
x_t_maxE = x_t_max+0.5; % [m] Límite traslación carro máximo emergencia

v_t_max = 4; % [m/s] Límite de velocidad de traslación carro

y_h_min = -20; % [m] Límite traslación izaje mínimo
y_h_max = 40; % [m] Límite traslación izaje máximo
y_h_minE = y_h_min-0.5; % [m] Límite traslación izaje mínimo emergencia
y_h_maxE = y_h_max+0.5; % [m] Límite traslación izaje máximo emergencia
l_h_min = Y_t0-y_h_max; % [m] Mínima extensión de cable de izaje
l_h_max = Y_t0-y_h_min; % [m] Máxima extensión de cable de izaje
l_h_minE = l_h_min-0.5;
l_h_maxE = l_h_max+0.5;

v_h_max_noload = 3; % [m/s] Límite de velocidad de izaje sin carga
v_h_max_load = 1.5; % [m/s] Límite de velocidad de izaje con carga nominal


% Entre la carga y su apoyo (suelo) existe una reacción que no es 100%
% rígida y perfecta, está definida mediante:
K_cy = 1.8e9; % [N/m] Rigidez de compresión por contacto vertical
b_cy = 1e7; % [N/(m/s)] Fricción interna o amortiguamiento de compresión por contacto vertical
b_cx = 1e6; % [N/(m/s)] Fricción de arrastre horizontal por contactovertical

% Cable de acero de izaje
k_wu = 2.36e8; % [N/m] Rigidez unitaria a tracción, la tensión la da el peso de la carga
b_wu = 150; % [(N/m/s)/m] Fricción interna o amortiguamiento a tracción
L_h0 = 110; % [m] Longitud de despliegue fijo del wirerope de izaje, esto no cambia con el izaje. 

% Accionamiento del sistema de izaje
r_hd = 0.75; % [m] Radio primitivo del tambor, enrollado helicoidal con una sola corrida de cable.
J_hd_hEb = 3800; % [kg.m2] Momento de inercia equivalente del eje lento, tambor + freno + salida de caja reductora
b_hd = 8; % [Nm/(rad/s)] Coeficiente de fricción mecánica viscosa equivalente del eje lento
b_hEb = 2.2e9; % [Nm/(rad/s)] Coeficiente de fricción viscosa equivalente del Freno de emergencia
T_hEbMax = 1.1e6; % [Nm] Torque máximo de frenado del Freno de emergencia
i_h = 22; % [:1] Relación de transmisión total de la caja reductora
J_hm_hb  = 30; % [kg.m^2] Momento de inercia equivalente del eje rápido (motor + freno + entrada de caja)
b_hm = 18; % [Nm/(rad/s)] Coeficiente de fricción mecánica viscosa equivalente del eje rápido
b_hb = 1e8; % [Nm/(rad/s)] Coeficiente de fricción viscosa equivalente del Freno de operación       
T_hbMax = 5e4; % [Nm] Torque máximo de frenado del Freno de operación
tau_hm   = 1e-3; % [s] Constante de tiempo del modulador de torque en motor-drive de izaje
T_hmMax  = 2e4;% [Nm] Torque máximo de motorización/frenado regenerativo del motor

% Carro y cable de acero del carro equivalente
M_t = 30000; % [kg] Masa equivalente de carro, ruedas, catenaria, etc.
b_t = 90; % [N/(m/s)] Coeficiente de fricción mecánica viscosa equivalente del carro
K_tw = 4.8e5; % [N/m] Rigidez total a tracción del cable tensado del carro
b_tw = 3e3; % [N/(m/s)] Fricción interna (amortiguamiento) del cable tensado del carro

%Accionamiento de traslación del    carro
r_td = 0.50; % [m] Radio primitivo del tambor (1 sola corrida de cable)
J_td = 1200; % [kg*m^2] Momento de inercia equivalente del eje lento (tambor + salida de caja)
b_td = 1.8; % [N*m/(rad/s)] Coeficiente de fricción mecánica viscosa equivalente del eje lento
i_t = 30; % [-] Relación de transmisión total de la caja reductora
J_tm_tb = 7; % [kg*m^2] Momento de inercia equivalente del eje rápido (motor + freno + entrada de caja)
b_tm = 6; % es 6[N*m/(rad/s)] Coeficiente de fricción mecánica viscosa equivalente del eje rápido
b_tb = 5e6; % [N*m/(rad/s)] Coeficiente de fricción viscosa equivalente del Freno de operación
T_tbMax = 5e3; % [N*m] Torque máximo de frenado del Freno de operación
tau_tm = 1e-3; % [s] Constante de tiempo del modulador de torque en motor-drive de carro
T_tmMax = 4e3; % [N*m] Torque máximo de motorización/frenado regenerativo del motor
w_hm_rated = v_h_max_load*2*i_h/r_hd; % [rad/s] Velocidad nominal del motor

% Lidar
x_lidar_offset = 3.0; % [m] Distancia del lidar respecto del carro, adelante.

%% Definiciones adicionales

% Nivel 2

m_l = M_s;

M_tEq = i_t/r_td*(J_tm_tb+J_td/i_t^2)+r_td/i_t*(M_t+m_l); % Considera motor + tambor + carro + carga colgando
b_tEq = i_t/r_td*(b_tm+b_td/i_t^2)+r_td/i_t*b_t; % Considera motor + tambor + carro
% 
% J_hEq = 2/r_hd*(i_h^2*J_hm_hb+J_hd_hEb); % Considera motor + tambor + carro
% b_hEq = 2/r_hd*(i_h^2*b_hm+b_hd); % Considera motor + tambor + carro

J_hEq = 2*i_h/r_hd*(J_hm_hb+J_hd_hEb/i_h^2);
b_hEq = 2*i_h/r_hd*(b_hm+b_hd/i_h^2);

% Parámetros discretos
T_hs = (b_hEq/J_hEq)/2/pi/100;
T_ts = (b_tEq/M_tEq)/2/pi/100;

T_s = 0.001;
T_s0 = 0.001;
T_s1 = 0.020;
T_s2 = 0.020;

% Generación perfil de suelo 
x_c0_left = -35;
x_c0_right = 55;
ship_load_percentage = 25; 
max_containers = 16;
container_pillars = randi([0 max_containers*ship_load_percentage/100], 1, 19);
container_pillars(1) = 0;    % fuerza que al menos uno sea el minimo
container_pillars(end) = max_containers*ship_load_percentage/100; % fuerza que al menos uno sea el maximo
container_pillars = container_pillars(randperm(19)); % opcional: mezclar posiciones
trucks0 = [0, 0, 0, 0, 0];
H_truck = 1;
x_containers_left_lim = 1.5;
x_containers_right_lim= 48.5;

% Péndulo

tau_wl = 1 / (2 * pi * 2);

% Condiciones iniciales

v_lx0 = 0;
v_ly0 = 0;

v_t0 = 0;
x_t0 = -15;
w_tm0 = (v_t0)*i_t/r_td;
theta_tm0 = (x_t0)*i_t/r_td;    

x_l0 = x_t0;
y_l0 = 7;
l_h0 = (Y_t0-y_l0);
theta_hm0 = -l_h0*i_h*2/r_hd;
w_hm0 = 0;

% Parámetros de NIVEL 1

w_hm_min_BRK = 999999999;
w_tm_min_BRK = 999999999;

% Parámetros adicionales de NIVEL 1

dx_grid_lidar = 0.01;
lidar_grid_size = numel(x_c0_left:dx_grid_lidar:x_c0_right);
PES_dy = 1.5; 
truck_pickup_height = 3.59;
l_h_safe = 11;
pickup_safety_margin = 2.5;
placement_safety_margin = H_c + 2.5;

% Parámetros de NIVEL 0

x_t_safety_min = x_t_minE + 3;
x_t_safety_max = x_t_maxE - 3;
l_h_safety_max = l_h_maxE - 3;
l_h_safety_min = l_h_minE + 3;


