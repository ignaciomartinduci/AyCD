%% CÁLCULO DEL OBSERVADOR DE ESTADOS - IZAJE

% 1. Parámetros equivalentes (reflejados al motor)
% J_eq_h = J_hm_hb + (J_hd_hEb / i_h^2);
% b_eq_h = b_hm + (b_hd / i_h^2);
% 
% % 2. Matrices del Espacio de Estados
% Ah = [0, 1; 
%       0, -b_eq_h / J_eq_h];
% 
% Bch = [0, 0, 0;
%        1/J_eq_h, 1/J_eq_h, 1/(i_h*J_eq_h)];
% 
% Bdh = [0; 
%       -r_hd / (i_h * J_eq_h)];
% 
% Ch = [1, 0];
% 
% % 3. Sintonía de Ganancias Lh
% % Se utiliza la frecuencia de diseño calculada en gain_CL.m
% frecuencia_control_h = abs(w_des_h); 
% factor_obs_h = 30; 
% polo_h_base = -factor_obs_h * frecuencia_control_h;
% 
% % Ubicación de polos (se separan un 5% para estabilidad del comando place)
% polos_h = [polo_h_base, polo_h_base * 1.05];
% 
% % Cálculo de la matriz de ganancias Lh
% Lh = place(Ah', Ch', polos_h)';
% %%


Ah = [0 1
    0 -(b_hm+b_hd/i_h^2)/(J_hm_hb+J_hd_hEb/i_h^2)];

Bch = [0 
    1/(J_hm_hb+J_hd_hEb/i_h^2)];

Bdh = [0    
    -r_hd/i_h/(J_hm_hb+J_hd_hEb/i_h^2)];

Ch = [1 0];

polo_h_la = abs(min(eig(Ah)));

factor_obs_h = 10; 
polo_h_base = -factor_obs_h * polo_h_la;

polos_h = [polo_h_base, polo_h_base * 1.10];

Lh = place(Ah', Ch', polos_h)';
disp("=======================")

disp(polo_h_la)
disp(eig(Ah-Lh*Ch))
disp(Ah-Lh*Ch)
disp("=======================")
