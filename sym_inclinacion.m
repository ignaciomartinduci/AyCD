syms s I H n0 d1 d0 kp kd Z w r ki a
 
Pdes = simplify(s^2 + 2*Z*w*s + w^2)

Ncar = (s*I+n0);
Dcar = (H*s^2+s*d1+d0);
K = (kp+kd*s);
% Igualo polinomios: Dcar + K*Ncar = a*Pdes
poly_eq = expand(Dcar + K*Ncar) - a*Pdes;

% Igualo coeficientes en s^2, s^1, s^0
eqs = coeffs(poly_eq, s) == 0;

% Resuelvo para kp, kd y a
sol = solve(eqs, [kp, kd, a]);

simplify(sol.kp)
simplify(sol.kd)
simplify(sol.a)
