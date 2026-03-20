Y_t0 = 45; %  [m] Altura fija de poleas de suspension de izaje en el carro
H_c = 2.5; % [m] Alto y ancho de container estandar
M_s = 15000; % [kg] Masa de spreader + headblock
M_cmax = 50000; % [kg] Masa de container máxima a cargar (lleno)
M_cmin = 2000; % [kg] Masa de container mínima a cargar (vacío)
g = 9.80664; % [m/s2] Aceleración gravitatoria

% Entre la carga y su apoyo (suelo) existe una reacción que no es 100%
% rígida y perfecta, está definida mediante:
K_cy = 1.8e9; % [N/m] Rigidez de compresión por contacto vertical
b_cy = 1e7; % [N/(m/s)] Fricción interna o amortiguamiento de compresión por contacto vertical
b_cx = 1e6; % [N/(m/s)] Fricción de arrastre horizontal por contactovertical

% Cable de acero de izaje
k_wu = 2.35e8; % [N/m] Rigidez unitaria a tracción, la tensión la da el peso de la carga
b_wu = 150; % [N/m/s)] Fricción interna o amortiguamiento a tracción

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
T_nmMax  = 2e4;% [Nm] Torque máximo de motorización/frenado regenerativo del motor

% Carro y cable de acero del carro equivalente
M_t = 30000; % [kg] Masa equivalente de carro, ruedas, catenaria, etc.
b_t = 90; % [N/(m/s)] Coeficiente de fricción mecánica viscosa equivalente del carro
K_tw = 4.8e5; % [N/m] Rigidez total a tracción del cable tensado del carro
b_tw = 3e3; % [N/(m/s)] Fricción interna (amortiguamiento) del cable tensado del carro

%Accionamiento de traslación del carro
r_td = 0.50; % [m] Radio primitivo del tambor (1 sola corrida de cable)
J_td = 1200; % [kg*m^2] Momento de inercia equivalente del eje lento (tambor + salida de caja)
b_td = 1.8; % [N*m/(rad/s)] Coeficiente de fricción mecánica viscosa equivalente del eje lento
i_t = 30; % [-] Relación de transmisión total de la caja reductora
J_tm_tb = 7; % [kg*m^2] Momento de inercia equivalente del eje rápido (motor + freno + entrada de caja)
b_tm = 6; % [N*m/(rad/s)] Coeficiente de fricción mecánica viscosa equivalente del eje rápido
b_tb = 5e6; % [N*m/(rad/s)] Coeficiente de fricción viscosa equivalente del Freno de operación
T_tbMax = 5e3; % [N*m] Torque máximo de frenado del Freno de operación
tau_tm = 1e-3; % [s] Constante de tiempo del modulador de torque en motor-drive de carro
T_tmMax = 3e3; % [N*m] Torque máximo de motorización/frenado regenerativo del motor

%% Definiciones adicionales

m_l = M_s;

J_tEq = M_t*i_t^2*J_tm_tb/r_td^2+J_td/r_td^2+m_l; % Considera motor + tambor + carro + carga colgando
b_tEq = i_t^2*b_tm/r_td^2+b_td/r_td; % Considera motor + tambor + carro

J_hEq = J_hm_hb+J_hd_hEb/i_h^2+m_l*r_hd^2/4/i_h^2; % Considera motor + tambor + carro
b_hEq = b_hm+b_hd/i_h^2; % Considera motor + tambor + carro

% Parámetros discretos
T_s = (b_hEq/J_hEq)/2/pi/100;

% Condiciones iniciales
y_l0 = 25;
l_h0 = (Y_t0-y_l0);
theta_hm0 = -l_h0*i_h*2/r_hd;

w_tm0 = (0)*i_t/r_td;

% Otros parámetros

a_t_max = 0.8; % [m/s^2] Módulo de aceleración máxima del carro
a_t_max_al = 0.15; % [m/s^2] Mitad del módulo de aceleración máxima del carro
