%% CONTROLADOR TRASLACIÓN CARRO

w_t = -b_tEq/J_tEq;
dseta_t = 1;
n_t = 2.5;
w_des_t = 5*abs(w_t); 

b_ta = (n_t*w_des_t+2*dseta_t*w_des_t)*(J_tEq)-b_tEq;
k_tsa = (w_des_t^2+2*dseta_t*w_des_t)*(J_tEq);
k_tsia = (w_des_t^3)*(J_tEq);

disp("Las ganancias de lazo cerrado para el controlador del carro son: ");
disp(b_ta);
disp(k_tsa);
disp(k_tsia);


%% CONTROLADOR IZAJE

w_h = -b_hEq/J_hEq;

dseta_h = 1;
n_h = 2.5;
w_des_h = 10*abs(w_h);

b_ha = (n_h*w_des_h+2*dseta_h*w_des_h)*(J_hEq)-b_hEq;
k_hsa = (w_des_h^2+2*dseta_h*w_des_h)*(J_hEq);
k_hsia = (w_des_h^3)*(J_hEq);

disp("Las ganancias de lazo cerrado para el controlador del izaje son: ");
disp(b_ha);
disp(k_hsa);
disp(k_hsia);


%% CONTROLADOR OSCILACIÓN

dseta_o = 1;
w_o = 25;

k_osa = w_o^2;
b_oa = 2*dseta_o*w_o;




    