l = l_h0;
m_l = M_s;

%% O_1 [0 I 0 0]

x_t = 0;
dx_t = 0;
theta = 0*180/pi;
dtheta = 0*180/pi;
F_tw = 0;
    

D = M_t+m_l-m_l*cos(theta)^2;
A = -b_t/D;
B = (2*m_l*l*dtheta*sin(theta))/D;

aux_1 = m_l*l*dtheta^2*cos(theta)+m_l*g*(cos(theta)^2-sin(theta)^2);
aux_2 = F_tw-b_t*dx_t+m_l*l*dtheta^2*sin(theta)+m_l*g*cos(theta)*sin(theta);
C = (aux_1*D-aux_2*2*m_l*cos(theta)*sin(theta))/(D^2);

E = (b_t*cos(theta))/(l*D);
F = (-2*m_l*l*dtheta*sin(theta)*cos(theta))/(l*D);
aux_3 = F_tw*sin(theta)-b_t*sin(theta)*dx_t+m_l*l*dtheta*(sin(theta)^2-cos(theta)^2)-m_l*g*(cos(theta)^3-2*cos(theta)*sin(theta)^2);
aux_4 = -F_tw*cos(theta)+b_t*cos(theta)*dx_t-m_l*dtheta^2*sin(theta)*cos(theta)-m_l*g*cos(theta)^2*sin(theta);
G = (aux_3*l*D-aux_4*2*m_l*cos(theta)*sin(theta)*l)/(l^2*D^2)-g*cos(theta)/l;

H = 1/D;
I = -cos(theta)/(l*D);

s1 = (-(B*I-H*F)+sqrt((B*I-H*F)^2-4*H*(C*I-H*G)))/(2*H);
s2 = (-(B*I-H*F)-sqrt((B*I-H*F)^2-4*H*(C*I-H*G)))/(2*H);

dseta = 1;
w_d = 10*max(abs([s1,s2]));

A = 2*dseta*w_d;
n_0 = H*E-A*I;
d_0 = C*I-H*G;
d_1 = B*I-H*F;

k_p_inc_O1 = -(d_0*n_0 + I*d_1*w_d^2 - H*n_0*w_d^2 - 2*I*dseta*d_0*w_d)/(n_0^2 - 2*dseta*I*n_0*w_d + I^2*w_d^2);
k_d_inc_O1 = (- H*I*w_d^2 + 2*H*dseta*n_0*w_d - d_1*n_0 + d_0*I)/(n_0^2 - 2*dseta*I*n_0*w_d + I^2*w_d^2);

str = "Ganancias de controlador paralelo de oscilación Kp = "+string(k_p_inc_O1)+", Kd = "+string(k_d_inc_O1);
disp(str);

%% O_2 [2 I 0 -4.66]

x_t = 0;
dx_t = 2;
theta = -4.66*180/pi;
dtheta = 0*180/pi;
F_tw = 3618;
    

D = M_t+m_l-m_l*cos(theta)^2;
A = -b_t/D;
B = (2*m_l*l*dtheta*sin(theta))/D;

aux_1 = m_l*l*dtheta^2*cos(theta)+m_l*g*(cos(theta)^2-sin(theta)^2);
aux_2 = F_tw-b_t*dx_t+m_l*l*dtheta^2*sin(theta)+m_l*g*cos(theta)*sin(theta);
C = (aux_1*D-aux_2*2*m_l*cos(theta)*sin(theta))/(D^2);

E = (b_t*cos(theta))/(l*D);
F = (-2*m_l*l*dtheta*sin(theta)*cos(theta))/(l*D);
aux_3 = F_tw*sin(theta)-b_t*sin(theta)*dx_t+m_l*l*dtheta*(sin(theta)^2-cos(theta)^2)-m_l*g*(cos(theta)^3-2*cos(theta)*sin(theta)^2);
aux_4 = -F_tw*cos(theta)+b_t*cos(theta)*dx_t-m_l*dtheta^2*sin(theta)*cos(theta)-m_l*g*cos(theta)^2*sin(theta);
G = (aux_3*l*D-aux_4*2*m_l*cos(theta)*sin(theta)*l)/(l^2*D^2)-g*cos(theta)/l;

H = 1/D;
I = -cos(theta)/(l*D);

s1 = (-(B*I-H*F)+sqrt((B*I-H*F)^2-4*H*(C*I-H*G)))/(2*H);
s2 = (-(B*I-H*F)-sqrt((B*I-H*F)^2-4*H*(C*I-H*G)))/(2*H);

dseta = 1;
w_d = 5*max(abs([s1,s2]));

A = 2*dseta*w_d;
n_0 = H*E-A*I;
d_0 = C*I-H*G;
d_1 = B*I-H*F;

k_p_inc_O2 = -(d_0*n_0 + I*d_1*w_d^2 - H*n_0*w_d^2 - 2*I*dseta*d_0*w_d)/(n_0^2 - 2*dseta*I*n_0*w_d + I^2*w_d^2);
k_d_inc_O2 = (- H*I*w_d^2 + 2*H*dseta*n_0*w_d - d_1*n_0 + d_0*I)/(n_0^2 - 2*dseta*I*n_0*w_d + I^2*w_d^2);

str = "Ganancias de controlador paralelo de oscilación Kp = "+string(k_p_inc_O2)+", Kd = "+string(k_d_inc_O2);
disp(str);

%% O_3 [2 I 0 4.66]

x_t = 0;
dx_t = 2;
theta = 4.66*180/pi;
dtheta = 0*180/pi;
F_tw = 3618;
    

D = M_t+m_l-m_l*cos(theta)^2;
A = -b_t/D;
B = (2*m_l*l*dtheta*sin(theta))/D;

aux_1 = m_l*l*dtheta^2*cos(theta)+m_l*g*(cos(theta)^2-sin(theta)^2);
aux_2 = F_tw-b_t*dx_t+m_l*l*dtheta^2*sin(theta)+m_l*g*cos(theta)*sin(theta);
C = (aux_1*D-aux_2*2*m_l*cos(theta)*sin(theta))/(D^2);

E = (b_t*cos(theta))/(l*D);
F = (-2*m_l*l*dtheta*sin(theta)*cos(theta))/(l*D);
aux_3 = F_tw*sin(theta)-b_t*sin(theta)*dx_t+m_l*l*dtheta*(sin(theta)^2-cos(theta)^2)-m_l*g*(cos(theta)^3-2*cos(theta)*sin(theta)^2);
aux_4 = -F_tw*cos(theta)+b_t*cos(theta)*dx_t-m_l*dtheta^2*sin(theta)*cos(theta)-m_l*g*cos(theta)^2*sin(theta);
G = (aux_3*l*D-aux_4*2*m_l*cos(theta)*sin(theta)*l)/(l^2*D^2)-g*cos(theta)/l;

H = 1/D;
I = -cos(theta)/(l*D);

s1 = (-(B*I-H*F)+sqrt((B*I-H*F)^2-4*H*(C*I-H*G)))/(2*H);
s2 = (-(B*I-H*F)-sqrt((B*I-H*F)^2-4*H*(C*I-H*G)))/(2*H);

dseta = 1;
w_d = 5*max(abs([s1,s2]));

A = 2*dseta*w_d;
n_0 = H*E-A*I;
d_0 = C*I-H*G;
d_1 = B*I-H*F;

k_p_inc_O3 = -(d_0*n_0 + I*d_1*w_d^2 - H*n_0*w_d^2 - 2*I*dseta*d_0*w_d)/(n_0^2 - 2*dseta*I*n_0*w_d + I^2*w_d^2);
k_d_inc_O3 = (- H*I*w_d^2 + 2*H*dseta*n_0*w_d - d_1*n_0 + d_0*I)/(n_0^2 - 2*dseta*I*n_0*w_d + I^2*w_d^2);

str = "Ganancias de controlador paralelo de oscilación Kp = "+string(k_p_inc_O3)+", Kd = "+string(k_d_inc_O3);
disp(str);


%% O_4 [-2 I 0 4.66]

x_t = 0;
dx_t = -2;
theta = 4.66*180/pi;
dtheta = 0*180/pi;
F_tw = 3618;
    

D = M_t+m_l-m_l*cos(theta)^2;
A = -b_t/D;
B = (2*m_l*l*dtheta*sin(theta))/D;

aux_1 = m_l*l*dtheta^2*cos(theta)+m_l*g*(cos(theta)^2-sin(theta)^2);
aux_2 = F_tw-b_t*dx_t+m_l*l*dtheta^2*sin(theta)+m_l*g*cos(theta)*sin(theta);
C = (aux_1*D-aux_2*2*m_l*cos(theta)*sin(theta))/(D^2);

E = (b_t*cos(theta))/(l*D);
F = (-2*m_l*l*dtheta*sin(theta)*cos(theta))/(l*D);
aux_3 = F_tw*sin(theta)-b_t*sin(theta)*dx_t+m_l*l*dtheta*(sin(theta)^2-cos(theta)^2)-m_l*g*(cos(theta)^3-2*cos(theta)*sin(theta)^2);
aux_4 = -F_tw*cos(theta)+b_t*cos(theta)*dx_t-m_l*dtheta^2*sin(theta)*cos(theta)-m_l*g*cos(theta)^2*sin(theta);
G = (aux_3*l*D-aux_4*2*m_l*cos(theta)*sin(theta)*l)/(l^2*D^2)-g*cos(theta)/l;

H = 1/D;
I = -cos(theta)/(l*D);

s1 = (-(B*I-H*F)+sqrt((B*I-H*F)^2-4*H*(C*I-H*G)))/(2*H);
s2 = (-(B*I-H*F)-sqrt((B*I-H*F)^2-4*H*(C*I-H*G)))/(2*H);

dseta = 1;
w_d = 5*max(abs([s1,s2]));

A = 2*dseta*w_d;
n_0 = H*E-A*I;
d_0 = C*I-H*G;
d_1 = B*I-H*F;

k_p_inc_O4 = -(d_0*n_0 + I*d_1*w_d^2 - H*n_0*w_d^2 - 2*I*dseta*d_0*w_d)/(n_0^2 - 2*dseta*I*n_0*w_d + I^2*w_d^2);
k_d_inc_O4 = (- H*I*w_d^2 + 2*H*dseta*n_0*w_d - d_1*n_0 + d_0*I)/(n_0^2 - 2*dseta*I*n_0*w_d + I^2*w_d^2);

str = "Ganancias de controlador paralelo de oscilación Kp = "+string(k_p_inc_O4)+", Kd = "+string(k_d_inc_O4);
disp(str);

%% O_5 [-2 I 0 -4.66]

x_t = 0;
dx_t = -2;
theta = -4.66*180/pi;
dtheta = 0*180/pi;
F_tw = 3618;
    

D = M_t+m_l-m_l*cos(theta)^2;
A = -b_t/D;
B = (2*m_l*l*dtheta*sin(theta))/D;

aux_1 = m_l*l*dtheta^2*cos(theta)+m_l*g*(cos(theta)^2-sin(theta)^2);
aux_2 = F_tw-b_t*dx_t+m_l*l*dtheta^2*sin(theta)+m_l*g*cos(theta)*sin(theta);
C = (aux_1*D-aux_2*2*m_l*cos(theta)*sin(theta))/(D^2);

E = (b_t*cos(theta))/(l*D);
F = (-2*m_l*l*dtheta*sin(theta)*cos(theta))/(l*D);
aux_3 = F_tw*sin(theta)-b_t*sin(theta)*dx_t+m_l*l*dtheta*(sin(theta)^2-cos(theta)^2)-m_l*g*(cos(theta)^3-2*cos(theta)*sin(theta)^2);
aux_4 = -F_tw*cos(theta)+b_t*cos(theta)*dx_t-m_l*dtheta^2*sin(theta)*cos(theta)-m_l*g*cos(theta)^2*sin(theta);
G = (aux_3*l*D-aux_4*2*m_l*cos(theta)*sin(theta)*l)/(l^2*D^2)-g*cos(theta)/l;

H = 1/D;
I = -cos(theta)/(l*D);

s1 = (-(B*I-H*F)+sqrt((B*I-H*F)^2-4*H*(C*I-H*G)))/(2*H);
s2 = (-(B*I-H*F)-sqrt((B*I-H*F)^2-4*H*(C*I-H*G)))/(2*H);

dseta = 1;
w_d = 5*max(abs([s1,s2]));

A = 2*dseta*w_d;
n_0 = H*E-A*I;
d_0 = C*I-H*G;
d_1 = B*I-H*F;

k_p_inc_O5 = -(d_0*n_0 + I*d_1*w_d^2 - H*n_0*w_d^2 - 2*I*dseta*d_0*w_d)/(n_0^2 - 2*dseta*I*n_0*w_d + I^2*w_d^2);
k_d_inc_O5 = (- H*I*w_d^2 + 2*H*dseta*n_0*w_d - d_1*n_0 + d_0*I)/(n_0^2 - 2*dseta*I*n_0*w_d + I^2*w_d^2);

str = "Ganancias de controlador paralelo de oscilación Kp = "+string(k_p_inc_O5)+", Kd = "+string(k_d_inc_O5);
disp(str);


