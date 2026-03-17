% Parámetros
ancho_contenedor = 2.5;  % Ancho del contenedor en metros
alto_contenedor = 2.5;   % Alto del contenedor en metros
num_contenedores_barco = 10;  % Número de contenedores en el barco

% Crear el muelle
muelle_ancho = 50;
muelle_alto = 5;
muelle = zeros(muelle_alto, muelle_ancho);

% Crear el barco con contenedores aleatorios
barco_ancho = 30;
barco_fondo = -7.5;
barco = zeros(muelle_alto, barco_ancho);

% Posicionar contenedores en el barco de manera aleatoria
for i = 1:num_contenedores_barco
    x = randi(barco_ancho - round(ancho_contenedor) + 1);
    y = randi(muelle_alto - round(alto_contenedor) + 1);
    barco(y:y+round(alto_contenedor)-1, x:x+round(ancho_contenedor)-1) = 1;
end

% Mostrar el mapa de obstáculos
figure;
imshow([muelle, zeros(muelle_alto, 10), barco], 'InitialMagnification', 'fit', 'Colormap', [1 1 1; 0 0 0]);
title('Mapa de obstáculos con contenedores en el muelle y el barco');
xlabel('Posición en metros');
ylabel('Altura en metros');
