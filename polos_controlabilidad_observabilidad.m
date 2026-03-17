%% SCRIPT PARA CALCULAR POLOS DE LAZO ABIERTO

parametros;
OL_matrixes;

%% ACCIONAMIENTO CARRO

disp("Polos de lazo abierto del accionamiento del carro");
poles_A_t_ol = eigs(A_t_ol);
disp(poles_A_t_ol);

ctrb_t = ctrb(A_t_ol, B_c_t);
obsv_t = obsv(A_t_ol, C_t);

if det(ctrb_t) == 0
    disp("El accionamiento del sistema del carro NO es controlable desde la entrada T_tm")
else
    disp("El accionamiento del sistema del carro SI es controlable desde la entrada T_tm")
end

if det(obsv_t) == 0
    disp("El sistema carro NO es completamente observable desde la salida x_t");
else
    disp("El sistema carro SI es completamente observable desde la salida x_t");
end

