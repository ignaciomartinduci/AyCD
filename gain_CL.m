%% CONTROLADOR TRASLACIÓN CARRO

w_t = -b_tEq/(M_tEq);
dseta_t = 1;
n_t = 1+2*dseta_t;
w_des_t = 3*abs(w_t);

b_ta = M_tEq*w_des_t*(1+n_t+n_t^2)-b_tEq;
k_tsa = M_tEq*w_des_t^2*n_t*(1+n_t+n_t^2);
k_tsia = M_tEq*w_des_t^3*n_t^3;

disp("Las ganancias de lazo cerrado para el controlador del carro son: ");
disp(b_ta);
disp(k_tsa);
disp(k_tsia);


%% CONTROLADOR IZAJE

w_h = -b_hEq/(J_hEq+r_hd/2/i_h*m_l);

dseta_h = 1;
n_h = 1+2*dseta_h;
w_des_h = 5*abs(w_h);

b_ha = -(J_hEq + (r_hd/(2*i_h))*m_l) * w_des_h*(1 + n_h + n_h^2) + b_hEq;
k_hsa = -(J_hEq + (r_hd/(2*i_h))*m_l) * w_des_h^2*(n_h + n_h^2 + n_h^3);
k_hsia = -(J_hEq + (r_hd/(2*i_h))*m_l) * n_h^3 * w_des_h^3;
% k

disp("Las ganancias de lazo cerrado para el controlador del izaje son: ");
disp(b_ha);
disp(k_hsa);
disp(k_hsia);


% %% CONTROLADOR OSCILACIÓN
% 
% wo_0 = sqrt(g/); % maximo largo de cable, a -20, dentro del barco.
% wo_1 = 3*w_des_t; % w_des_t del carro
%   
% wo = 5*wo_0;



    