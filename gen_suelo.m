x_inicial = -100;
x_final = 100;
res = 0.01;
elementos = (x_final-x_inicial)/res;

x = linspace(x_inicial,x_final,elementos);
y = zeros(size(x));

for i=1:length(y)

    if x(i) >= 0+res

        y(i) = -20;

    end

end

ground_profile = [x',y'];

% figure;
% plot(x,y);
% grid on;
% xlabel("x [m]");
% ylabel("y [m]");
% legend("Perfil de suelo");
% title("Perfil de suelo inicial generado");
% 
% save('terreno_inicial.mat', 'ground_profile');
