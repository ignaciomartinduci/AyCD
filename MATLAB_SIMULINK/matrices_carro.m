parametros;
A = [
0 1 0 0
-(r_td/i_t)^2*K_tw/(J_tm_tb+J_td/i_t^2)     -(b_tm+b_td/i_t^2+(r_td/i_t)^2*b_tw)/(J_tm_tb+J_td/i_t^2)       (r_td/i_t)*K_tw/(J_tm_tb+J_td/i_t^2)       (r_td/i_t)*b_tw/(J_tm_tb+J_td/i_t^2)
0 0 0 1
(r_td/i_t)*K_tw/(M_t)       (r_td/i_t)*b_tw/(M_t)   -K_tw/M_t   -(b_tw+b_t)/(M_t)
];

B_c = [
0   0
1/(J_tm_tb+J_td/i_t^2)  1/(J_tm_tb+J_td/i_t^2)
0   0
0   0
];

B_d = [
0
0
0
2/M_t
];

C = [1 0 0 0];

