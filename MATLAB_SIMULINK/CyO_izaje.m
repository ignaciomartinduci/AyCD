matrices_izaje;
disp("===== CONTROLABILIDAD DE IZAJE =====");
W_c = ctrb(A, B_c(:,1));
rango_W_c = rank(W_c);
n = size(A,1);
if rango_W_c == n
    disp("El sistema es controlable desde T_hm")
else
    disp("El sistema no es controlable desde T_hm");
end

disp("===== OBSERVABILIDAD DESDE theta_hm =====");

W_o = obsv(A, C);
rango_W_o = rank(W_o);

if rango_W_o == n
    disp("El sistema es completamente observable desde theta_hm")
else
    disp("El sistema no es completamente observable desde theta_hm");
end

