theta_l = 0.000001*pi/180;
l = 0.000001;
dl_dt = 0.000001;
[A,B,C] = matrices_oscilacion(theta_l, l, dl_dt);

disp("===== CONTROLABILIDAD DE OSCILACIÓN =====");
W_c = ctrb(A, B);
rango_W_c = rank(W_c);
n = size(A,1);
if rango_W_c == n
    disp("El sistema es controlable desde ddx_t/dt")
else
    disp("El sistema no es controlable desde ddx_t/dt");
end