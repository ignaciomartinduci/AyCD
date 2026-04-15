%% CONTROLADOR TRASLACIÓN CARRO

w_t = -b_tEq/(M_tEq);
dseta_t = 0.7071;
n_t = 1+2*dseta_t;
w_des_t = 3*abs(w_t);

b_ta = r_td/i_t*M_tEq*w_des_t*(1+n_t+n_t^2)-r_td/i_t*b_tEq;
k_tsa = r_td/i_t*M_tEq*w_des_t^2*n_t*(1+n_t+n_t^2);
k_tsia = r_td/i_t*M_tEq*w_des_t^3*n_t^3;

disp("Las ganancias de lazo cerrado para el controlador del carro son: ");
disp(b_ta);
disp(k_tsa);
disp(k_tsia);


%% CONTROLADOR IZAJE

w_h = -b_hEq/J_hEq;

dseta_h = 0.7071;
n_h = 1+2*dseta_h;
w_des_h = 3*abs(w_h);

A_h = J_hEq/i_h+m_l*g*r_hd/(2*i_h);

b_ha = A_h*(w_des_h)*(1+n_h+n_h^2)-b_hEq/i_h
k_hsa = A_h*w_des_h^2*(n_h+n_h^2+n_h^3)
k_hsia = A_h*n_h^3*w_des_h^3

disp("Las ganancias de lazo cerrado para el controlador del izaje son: ");
disp(b_ha);
disp(k_hsa);
disp(k_hsia);


%% CONTROLADOR OSCILACIÓN

dseta_o = 1;
w_o = 25;

k_osa = w_o^2;
b_oa = 2*dseta_o*w_o;




    