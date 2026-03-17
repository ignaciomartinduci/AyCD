parametros;
%% ACCIONAMIENTO DEL CARRO

A_t_ol = [ -(r_td*b_tw + b_tEq)/J_tEq , -(r_td*K_tw)/J_tEq ,  (r_td*b_tw)/J_tEq ,  (r_td*K_tw)/J_tEq   ;
       1                        ,  0                  ,  0                 ,  0                        ;
       b_tw/M_t                 ,  K_tw/M_t           , -(b_tw+b_t)/M_t   , -K_tw/M_t                  ;
       0                        ,  0                  ,  1                 ,  0                        ;];
B_c_t = [i_t/J_tEq;
        0;
        0;
        0];

B_d_t = [i_t/J_tEq,     0;
        0,              0;
        0,              2/M_t;
        0,              0;];   

C_t = [ 0 1 0 0 ];

E_r = [0;
       0;
       0;
       0;
       1];