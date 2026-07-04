function [A, B, C] = matrices_oscilacion(theta_l, l, dl_dt)
parametros;
A = [
0                                       1   
-g*sin(theta_l)/l/theta_l           -2*dl_dt/l
];

B=[
0
-cos(theta_l)/l
];

C=[1 0];

end