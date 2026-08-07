function [perfil_vel_x,perfil_vel_y , sx, sy]  = generar_Trayectoria(obstaculos, punto_inicial, punto_final, Carga_Descarga_) 

%===================================================PERFIL DE VELOCIDAD
    %________________Aceleraciones y velocidades
    

    perfil_vel_x = [0];
    perfil_vel_y = [];
    
    amax_Y = 0.75;
    vmax_Y = 3;
    vmax_X = 4;
    amax_X = 1;
    
    
%===================================================PERFIL DE TRAYECTORIA
    %________________Definir inicio contenedores y el factor de seguridad
    factor_seguridad = 3;
    inicio_contenedores = [2.5, -20];
    contador = 0;
    
    separacion_contenedores = 0.5;
    pared_barco = zeros(length(obstaculos(:,1)),1);
    pared_barco(1:2, 1) = [1, 1];
    obstaculos = [pared_barco, obstaculos];
    
    %________________Definir las dimensiones de los contenedores y el incremento de altura y posición
    ancho_contenedor = 2.5;
    alto_contenedor = 2.5;
    incremento_altura = 2;
    incremento_posicion = 0.625;
    incremento_altura_vuelta = 1;
    incremento_altura_bajada = 3;
    punto_final_aux = 0;
    
    
    % Inicializar el perfil de trayectoria como un vector vacío
    perfil_trayectoria = [punto_inicial];

    % Verificar cual es el obstáculo más alto
    obstaculo_mas_alto = max(sum(obstaculos, 1));

    % Calcular la altura del obstáculo más alto en metros
    if Carga_Descarga_ == 0
        altura_obstaculo_mas_alto = obstaculo_mas_alto * alto_contenedor + factor_seguridad*2 + inicio_contenedores(1, 2);
    else
        posicion = encontrar_posicion(punto_inicial, obstaculos);
        if posicion > 1
            contenedores_por_fila = cant_contenedores(obstaculos(:,posicion-1));
            altura_obstaculo_mas_alto = contenedores_por_fila * alto_contenedor + factor_seguridad*2 + inicio_contenedores(1, 2);
        elseif posicion == 1
            contenedores_por_fila = cant_contenedores(obstaculos(:,posicion+1));
            altura_obstaculo_mas_alto = contenedores_por_fila * alto_contenedor + factor_seguridad*2 + inicio_contenedores(1, 2);
        else
            altura_obstaculo_mas_alto = 7;
        end
    end

    if (punto_inicial(1, 1) < punto_final(1,1))
        disp('hola')
        punto_final = modificacion_punto_final(obstaculos,punto_final,  ancho_contenedor,alto_contenedor, factor_seguridad, separacion_contenedores);

% PRIMER TRAMO    
        
        % Buscar una línea que una el punto inicial con un punto P2 ubicado en x en la pared del barco y con una altura igual a la del obstáculo más alto
        P2 = [0 + ancho_contenedor/2, altura_obstaculo_mas_alto];
        P2_cte = P2;
        % Verificar si la línea colisiona con el perfil de obstáculos
        
        colision = verificar_colision_SUBIDA_IDA(obstaculos, punto_inicial, P2, ancho_contenedor, alto_contenedor, factor_seguridad);
        
        %===================================================PERFIL DE VELOCIDAD
        
        [sx, sy, perfil_vel_y, perfil_vel_x]  = obtener_perfil_vel_SUBIDA_IDA(punto_inicial, P2, vmax_Y);
        
        %===================================================PERFIL DE TRAYETORIA
        plot(perfil_vel_y)
        % Si hay colisión, elevar el punto inicial 2 metros y volver a buscar la línea
        while colision
            contador = 1;
            punto_inicial(2) = punto_inicial(2) + incremento_altura;
            colision = verificar_colision_SUBIDA_IDA(obstaculos, punto_inicial, P2, ancho_contenedor, alto_contenedor, factor_seguridad);
            
        end
        % Agregar el punto al perfil de trayectoria
        if (contador ~= 0)
            perfil_trayectoria = [perfil_trayectoria; punto_inicial; P2];
            contador = 0;
        else
            perfil_trayectoria = [perfil_trayectoria; P2];
        end
        
% SEGUNDO TRAMO

        % Buscar una línea que una el punto P2 con el punto final
        colision = verificar_colision_BAJADA_IDA(obstaculos, P2, punto_final, ancho_contenedor, alto_contenedor, factor_seguridad);

        % Si hay colisión, mover el punto P2 2 metros en el eje x y buscar una nueva línea
        punto_final_aux = punto_final + [0, 1.5];
        i_ = 1;
        
        while colision
            contador = 1;
            if (i_ == 4 || i_ == 7 || i_ ==10 || i_ ==13 || i_ ==16 || i_ ==19 || i_ ==21)
                P2(1) = P2(1) + 0.5;
            else
                P2(1) = P2(1) + incremento_posicion;
            end
            i_ = i_+1;
            punto_final_aux(2) = punto_final_aux(2) + 0.5;
            colision = verificar_colision_BAJADA_IDA(obstaculos, P2, punto_final_aux, ancho_contenedor, alto_contenedor, factor_seguridad);
        end
                

        % Agregar la línea al perfil de trayectoria
        if (contador ~= 0)
            perfil_trayectoria = [perfil_trayectoria; P2; punto_final_aux; punto_final];
            [sx_aux, sy_aux, perfil_vel_y_aux, perfil_vel_x_aux]  = obtener_perfil_vel_BAJADA_IDA(P2_cte, punto_final_aux, punto_final, vmax_Y, perfil_vel_y, perfil_vel_x);
            sx(end)
            sy(end)
            sx = [sx, sx_aux];
            sy = [sy, sy_aux];
            perfil_vel_x = [perfil_vel_x, perfil_vel_x_aux];
            perfil_vel_y = [perfil_vel_y, perfil_vel_y_aux];
            disp('--')

            
            contador = 0;
        else
            perfil_trayectoria = [perfil_trayectoria;punto_final_aux; punto_final];
            [sx_aux, sy_aux, perfil_vel_y_aux, perfil_vel_x_aux]  = obtener_perfil_vel_BAJADA_IDA(P2_cte, punto_final_aux, punto_final, vmax_Y, perfil_vel_y, perfil_vel_x);

            sx = [sx, sx_aux];
            sy = [sy, sy_aux];
            perfil_vel_x = [perfil_vel_x, perfil_vel_x_aux];
            perfil_vel_y = [perfil_vel_y, perfil_vel_y_aux];
            disp('----')
        end
        disp(punto_final)
        if(punto_final(1) == -10 && punto_final(2) == 10.5)
            disp('adentro x2')
            perfil_trayectoria = [punto_inicial;punto_inicial + [0, altura_obstaculo_mas_alto]; punto_final]
        end
        
        
    else
        % Buscar una línea que una el punto inicial con un punto P2 ubicado en x en el primer contenedor y con una altura igual a la del obstáculo más alto
        P2 = [punto_inicial(1,1) - ancho_contenedor, altura_obstaculo_mas_alto];
        punto_inicial(1,1);

        % Verificar si la línea colisiona con el perfil de obstáculos
        colision = verificar_colision_SUBIDA_VUELTA(obstaculos, punto_inicial, P2, ancho_contenedor, alto_contenedor, factor_seguridad);

        % Si hay colisión, elevar el punto inicial 2 metros y volver a buscar la línea
        while colision
            
            contador = 1;
            punto_inicial(2) = punto_inicial(2) + incremento_altura_vuelta;
            colision = verificar_colision_SUBIDA_VUELTA(obstaculos, punto_inicial, P2, ancho_contenedor, alto_contenedor, factor_seguridad);
        end
        
        % Agregar el punto al perfil de trayectoria
        if (contador ~= 0)
            perfil_trayectoria = [perfil_trayectoria; punto_inicial; P2];
            contador = 0;
        else
            perfil_trayectoria = [perfil_trayectoria; P2];
        end
        % Buscar una línea que una el punto P2 con el punto final
        colision = verificar_colision_BAJADA_VUELTA(obstaculos, P2, punto_final, ancho_contenedor, alto_contenedor, factor_seguridad);

        % Si hay colisión, mover el punto P2 2 metros en el eje x y buscar una nueva línea
        punto_final_aux = punto_final;
        while colision
            contador = 1;
            P2(1) = P2(1) - incremento_posicion;
            punto_final_aux(2) = punto_final(2) + incremento_altura_bajada;
            colision = verificar_colision_BAJADA_VUELTA(obstaculos, P2, punto_final, ancho_contenedor, alto_contenedor, factor_seguridad);
            
        end

        % Agregar la línea al perfil de trayectoria
        if (contador ~= 0)
            perfil_trayectoria = [perfil_trayectoria; P2;punto_final_aux; punto_final];
            contador = 0;
        else
            perfil_trayectoria = [perfil_trayectoria; punto_final];
        end
    end
    %plot(perfil_trayectoria(:, 1),perfil_trayectoria(:, 2), 'b');
    %perfil_trayectoria = perfil_trayectoria';
%_____________________________________________________________________________________________________________________
%___________________________________________________FUNCIONES_________________________________________________________
%_____________________________________________________________________________________________________________________

%===================================================PERFIL DE TRAYECTORIA
    % Definir una función auxiliar para verificar la colisión entre una línea y el perfil de obstáculos
    function colision = verificar_colision_SUBIDA_IDA(obstaculos, punto_a, punto_b, ancho_contenedor, alto_contenedor, factor_seguridad)
        % Calcular la ecuación de la recta que pasa por los dos puntos
        m = (punto_b(2) - punto_a(2)) / (punto_b(1) - punto_a(1));      % Pendiente de la recta
        b = punto_a(2) - m * punto_a(1);

        % Inicializar la variable de colisión como falsa
        colision = false;

        % Recorrer las columnas de la matriz de obstáculos
        % Calcular la posición x del contenedor
        x = 0 - factor_seguridad;                                       % En realidad es inicio_contenedor pero tiene el mismo valor

        % Calcular la posición y de la recta en esa posición x
        y = m * x + b;

        % Recorrer las filas de la matriz de obstáculos
        y_contenedor = cant_contenedores(obstaculos(:,1)) * alto_contenedor + factor_seguridad - 20;
        if y <= y_contenedor
            % Si es así, hay colisión
            colision = true;
        end
    end
    
    function colision = verificar_colision_BAJADA_IDA(obstaculos, punto_a, punto_b, ancho_contenedor, alto_contenedor, factor_seguridad)
        % Calcular la ecuación de la recta que pasa por los dos puntos
        m = (punto_b(2) - punto_a(2)) / (punto_b(1) - punto_a(1));      % Pendiente de la recta
        b = punto_a(2) - m * punto_a(1);

        % Inicializar la variable de colisión como falsa
        colision = false;

        % Recorrer las columnas de la matriz de obstáculos
        for i = 1:size(obstaculos, 2)-1
            % Calcular la posición x del contenedor
            
            x = (ancho_contenedor)*(i+1) + factor_seguridad/2 + 0.5*(i-1);
            x_real = (ancho_contenedor)*(i+1) + 0.5*(i-1);
  
            % Calcular la posición y de la recta en esa posición x
            y = m * x + b;

            % Recorrer las filas de la matriz de obstáculos
            y_contenedor = cant_contenedores(obstaculos(:, i+1)) * alto_contenedor + factor_seguridad -20;


            if y <= y_contenedor && x <= (punto_b(1)+ 0)
                % Si es así, hay colisión
                disp('colision') 
                colision = true;
                % Salir del bucle
                break;
            end
        end
    end

% Definir una función auxiliar para verificar la colisión entre una línea y el perfil de obstáculos
    function colision = verificar_colision_SUBIDA_VUELTA(obstaculos, punto_a, punto_b, ancho_contenedor, alto_contenedor, factor_seguridad)
        % Calcular la ecuación de la recta que pasa por los dos puntos
        m = (punto_b(2) - punto_a(2)) / (punto_b(1) - punto_a(1));      % Pendiente de la recta
        b = punto_a(2) - m * punto_a(1);

        % Inicializar la variable de colisión como falsa
        colision = false;

        for i = 1:size(obstaculos, 2)-1
            % Calcular la posición x del contenedor
            
            x = (ancho_contenedor)*(i+1) + 1 + 0.5*(i-1);
  
            % Calcular la posición y de la recta en esa posición x
            y = m * x + b;

            % Recorrer las filas de la matriz de obstáculos
            y_contenedor = cant_contenedores(obstaculos(:, i+1)) * alto_contenedor + factor_seguridad/2 -20;

            if y <= y_contenedor && x <= (punto_a(1)+ 0)
                % Si es así, hay colisión
                colision = true;
                % Salir del bucle
                break;
            end
        end
    end
    
    function colision = verificar_colision_BAJADA_VUELTA(obstaculos, punto_a, punto_b, ancho_contenedor, alto_contenedor, factor_seguridad)
        % Calcular la ecuación de la recta que pasa por los dos puntos
        m = (punto_b(2) - punto_a(2)) / (punto_b(1) - punto_a(1)) ;     % Pendiente de la recta
        b = punto_a(2) - m * punto_a(1);
        % Inicializar la variable de colisión como falsa
        colision = false;

        % Recorrer las columnas de la matriz de obstáculos
        for i = 1:size(obstaculos, 2)
            % Calcular la posición x del contenedor
            x = ancho_contenedor*i - factor_seguridad - ancho_contenedor;                                     

            % Calcular la posición y de la recta en esa posición x
            %disp('--')
            y = m * x + b;

            % Recorrer las filas de la matriz de obstáculos
            y_contenedor = cant_contenedores(obstaculos(:, i)) * alto_contenedor + factor_seguridad -20;
            
            if y <= y_contenedor
                % Si es así, hay colisión
                colision = true;
                % Salir del bucle
                break;
            end
            
        end
    end


    function contenedores_por_fila = cant_contenedores(fila)
        contenedores_por_fila = 0;
        for i = 1:length(fila)
            if fila(i) == 1
                contenedores_por_fila = contenedores_por_fila + 1;
            end
        end
    end


    function punto_final_modificado = modificacion_punto_final(obstaculos,punto_final,  ancho_contenedor, alto_contenedor, factor_seguridad, separacion_contenedores)
        punto_final_modificado = [0, 0];
        obstaculos = obstaculos(:, 2:end);
        for i = 1: length(obstaculos(1,:))
            if(obstaculos(1,i) == 1)
                if i ~= 1
                    x_izquierdo = ancho_contenedor*(i) + separacion_contenedores*(i-1);
                    x_derecho = ancho_contenedor*i + ancho_contenedor + separacion_contenedores*(i-1);
                else
                    x_izquierdo = ancho_contenedor*i;
                    x_derecho = ancho_contenedor*i + ancho_contenedor;
                end
                if (punto_final(1) >= x_izquierdo && punto_final(1) <= x_derecho)
                    punto_final_modificado(1) = x_izquierdo + ancho_contenedor/2;

                    y_contenedor = cant_contenedores(obstaculos(:,i)) * alto_contenedor + factor_seguridad - 20;
                    if (punto_final(2) < y_contenedor)
                        punto_final_modificado(2) = y_contenedor;
                    else 
                        punto_final_modificado(2) = punto_final(2);
                    end
                    break;
                else
                    punto_final_modificado(1) = punto_final(1);
                    y_contenedor = cant_contenedores(obstaculos(:,i)) * alto_contenedor + factor_seguridad - 20;
                    if (punto_final(2) < y_contenedor)
                        punto_final_modificado(2) = y_contenedor;
                    else 
                        punto_final_modificado(2) = punto_final(2);
                    end
                end                                
            end
        end  
        
    end

    function posicion = encontrar_posicion(punto_inicial, obstaculos)
        posicion = 0;
        for j = 1:size(obstaculos, 2)-1
            % Calcular la posición x del contenedor
            ancho = 2.5;
            
            x_real_izq = (ancho)*(j) + 1 + 0.5*(j-1);
            x_real_der = (ancho)*(j+1) + 0.5*(j-1);
            
            if punto_inicial(1) > x_real_izq
                posicion = posicion + 1;
                if punto_inicial(1) < x_real_der
                    break;
                end
            end
        end
    end

%===================================================PERFIL DE VELOCIDAD
    function [sx, sy, perfil_vel_y, perfil_vel_x]  = obtener_perfil_vel_SUBIDA_IDA(punto_i, punto_f, vmax_Y_)
        %%% ---> EN Y VAMOS A TENER UN PERFIL TRAPEZOIDAL Y EN X UN PERFIL
        %%% SOLO DE SUBIDA CON ACELERACION MAXIMA
        %________________Definir variables
        vmax_X_ = 4;
        amax_X_ = 1;
        amax_Y_ = 0.75;
        perfil_vel_x = [0];
        % perfil_vel_y = [];
        
        
        
        %________________Definir variación de posición
        dy = punto_f(1,2) - punto_i(1,2);
        dx = punto_f(1,1) - punto_i(1,1);
        
        
        
        %________________Definir tiempos de perfiles
        %___ EN X
        Tx1 = vmax_X_/amax_X_;                                                 % TIEMPO HASTA VELOCIDAD MAX
        Tx3 = (abs(dx) - 0.5*(Tx1^2)*amax_X_)/vmax_X_;
        %___ EN Y
        Ty1 = vmax_Y_/amax_Y_;
        Ty3 = (abs(dy) - 2*0.5*(Ty1^2)*amax_Y_)/vmax_Y_;
        Ty = 2*Ty1 + Ty3;  % TIEMPO PERFIL TRAPEZOIDAL
        
        if (Tx3>0)
            Tx = Tx1 + Tx3;
        else
            Tx = Tx1;      % QUEREMOS QUE TEMRINE CON MAX VELOCIDAD
        end
        
        % SIEMPRE TY VA A SER MAS GRANDE EN LA SUBIDA
        T = Ty - Tx;

        
        %________________Definir PERFIL VELOCIDAD EN Y
        perfil_vel_y = [linspace(0, vmax_Y_, Ty1/0.005), linspace(vmax_Y_, vmax_Y_, Ty3/0.005), linspace(vmax_Y_, 0, Ty1/0.005)];
        
        
        %________________Definir PERFIL VELOCIDAD EN X
        if (Tx3>=0) % Acelerar y mantener la velocidad constante
             perfil_vel_x = [perfil_vel_x, linspace(0, 0, T/0.005), linspace(0, vmax_X_, (Tx1)/0.005), linspace(vmax_X_, vmax_X_, (Tx3)/0.005)];
        else        % Acelerar
             perfil_vel_x = [perfil_vel_x, linspace(0, 0, T/0.005), linspace(0, vmax_X_, (Tx)/0.005)];
        end
        
        
        %________________Definir PERFIL TRASLACION EN X E Y
        %%% ---> Inicializar variables
        sx = linspace(0, 0, length(perfil_vel_x));          % Es indistinto si es perfil en X o Y para la longitud
        sy = linspace(0, 0, length(perfil_vel_x));
        sx(1, 1) = punto_i(1,1);
        sy(1, 1) = punto_i(1,2);
        
        
        for ii = 2: length(perfil_vel_y)                    % Es indistinto si es perfil en X o Y para la longitud
            %___ EN Y
                                                            % 0.005 es el tiempo de simulink (statechart)
            if 0.005*ii <= (Ty1)                            % Aceleracion                         
                %s = s(i-1) + 1/2 * a(max) *dt^2 + v(i-1)*dt
                sy(ii) = sy(ii-1) + 0.5 * amax_Y_ * (0.005*ii - 0.005*(ii-1))^2 + perfil_vel_y(ii-1)*(0.005*ii-0.005*(ii-1)); 
            elseif 0.005*ii > (Ty1) && 0.005*ii <= (Ty1 + Ty3) % Velocidad constante
                %s = s(i-1) + v(max)*dt
                sy(ii) = sy(ii-1) + vmax_Y_*(0.005*ii-0.005*(ii-1));
            else                                            % Desaceleracion
                %s = s(i-1) - 1/2 * a(max) *dt^2 + v(i-1)*dt
                sy(ii) = sy(ii-1) - 0.5 * amax_Y_ * (0.005*ii - 0.005*(ii-1))^2 + perfil_vel_y(ii-1)*(0.005*ii-0.005*(ii-1));
            end
            
            %___ EN X
            if 0.005*ii <= T
                sx(ii) = sx(1);
            else
                if (Tx3>0)
                    if 0.005*ii <= (Tx1 + T)
                        disp('hola2')
                        %s = s(i-1) + 1/2 * a(max) *dt^2 + v(i-1)*dt
                        sx(ii) = sx(ii-1) + 0.5 * amax_X_ * (0.005*ii - 0.005*(ii-1))^2 + perfil_vel_x(ii-1)*(0.005*ii-0.005*(ii-1));
                    else 
                        %s = s(i-1) + v(max)*dt
                        sx(ii) = sx(ii-1) + vmax_X_*(0.005*ii-0.005*(ii-1));
                    end
                else
                    %s = s(i-1) + 1/2 * a(max) *dt^2 + v(i-1)*dt
                    sx(ii) = sx(ii-1) + 0.5 * amax_X_ * (0.005*ii - 0.005*(ii-1))^2 + perfil_vel_x(ii-1)*(0.005*ii-0.005*(ii-1)); 
                end
            end
        end
%         t = linspace(0, Ty, Ty/0.005);
%         length(t)
%         length(perfil_vel_x)
%         length(perfil_vel_y)
%         length(perfil_vel_x)
%         figure(4)
%         plot(t, perfil_vel_y)
%         figure(5)
%         plot(t, perfil_vel_x)
        
    end

    function [sx, sy, perfil_vel_y, perfil_vel_x]  = obtener_perfil_vel_BAJADA_IDA(punto_i, punto_int, punto_f, vmax_Y_, perfil_vel_y_, perfil_vel_x_)
            %%% ---> EN Y VAMOS A TENER UN PERFIL TRAPEZOIDAL Y EN X UN PERFIL
            %%% SOLO DE SUBIDA CON ACELERACION MAXIMA
            %________________Definir variables
            vmax_X_ = 4;
            amax_X_ = 1;
            amax_Y_ = 0.75;



            %________________Definir variación de posición horizontal
            
            dx = punto_int(1,1) - punto_i(1,1);
            dy = punto_f(1,2) - punto_i(1,2);
            



            %________________Definir tiempos de perfiles
            %___ EN X
            Tx1 = vmax_X_/amax_X_;                                                 % TIEMPO HASTA VELOCIDAD MAX
            Tx3 = (abs(dx) - 0.5*(Tx1^2)*amax_X_)/vmax_X_;
            %___ EN Y
            Ty1 = vmax_Y_/amax_Y_;
            Ty3 = (abs(dy) - 2*0.5*(Ty1^2)*amax_Y_)/vmax_Y_;
            if (Ty3>0)
                Ty = 2*Ty1 + Ty3;  % TIEMPO PERFIL TRAPEZOIDAL
            else 
                Ty = 2*Ty1;  % TIEMPO PERFIL TRAPEZOIDAL
            end

            
            if (Tx3>0)
                Tx = Tx1 + Tx3;
                %________________Definir PERFIL VELOCIDAD EN X
                perfil_vel_x = [linspace(vmax_X_, vmax_X_, Tx3/0.005), linspace(vmax_X_, 0, Tx1/0.005), linspace(0, 0, (Ty-Tx*0.5)/0.005)];
            else
                Tx = Tx1;      % QUEREMOS QUE TEMRINE CON MIN VELOCIDAD
                perfil_vel_x = [linspace(vmax_X_, 0, Tx1/0.005), linspace(0, 0, (Ty-Tx*0.5)/0.005)];
            end
            T = Tx*0.50;

           

            %________________Definir PERFIL VELOCIDAD EN Y
            if (Ty3>=0) % Acelerar y mantener la velocidad constante y desacelerar
                 perfil_vel_y = [linspace(0, 0, T/0.005), linspace(0, -vmax_Y_, (Ty1)/0.005), linspace(-vmax_Y_, -vmax_Y_, (Ty3)/0.005), linspace(-vmax_Y_, 0, (Ty1)/0.005)];
                 
            else        % Acelerar y desacelerar
                dy_aux = 2*amax_Y_*(Ty1^2)/2;
                if dy_aux ~= dy
                    amax_Y_ = dy/(2*(Ty1^2));
                    vmax_Y_ = Ty1 * amax_Y_;
                end
                perfil_vel_y = [linspace(0, 0, T/0.005), linspace(0, vmax_Y_, (Tx)/0.005)];
            end


            %________________Definir PERFIL TRASLACION EN X E Y
            %%% ---> Inicializar variables
            sx = linspace(0, 0, length(perfil_vel_x));          % Es indistinto si es perfil en X o Y para la longitud
            sy = linspace(0, 0, length(perfil_vel_x));
            sx(1, 1) = punto_i(1,1);
            sy(1, 1) = punto_i(1,2);


            for ii = 2: length(perfil_vel_y)                    % Es indistinto si es perfil en X o Y para la longitud
                %___ EN Y
                                                                % 0.005 es el tiempo de simulink (statechart)
                if (0.005*ii <= T)
                    sy(ii) = sy(ii-1);
                else
                    if 0.005*ii <= (Ty1)                            % Desaceleracion                         
                        %s = s(i-1) + 1/2 * a(max) *dt^2 + v(i-1)*dt
                        sy(ii) = sy(ii-1) - 0.5 * amax_Y_ * (0.005*ii - 0.005*(ii-1))^2 + perfil_vel_y(ii-1)*(0.005*ii-0.005*(ii-1)); 
                    elseif 0.005*ii > (Ty1) && 0.005*ii <= (Ty1 + Ty3) % Velocidad constante
                        %s = s(i-1) + v(max)*dt
                        sy(ii) = sy(ii-1) + vmax_Y_*(0.005*ii-0.005*(ii-1));
                    else                                            % Aceleracion
                        %s = s(i-1) - 1/2 * a(max) *dt^2 + v(i-1)*dt
                        sy(ii) = sy(ii-1) + 0.5 * amax_Y_ * (0.005*ii - 0.005*(ii-1))^2 + perfil_vel_y(ii-1)*(0.005*ii-0.005*(ii-1));
                        
                    end
                    
                end
                
                %___ EN X
                if 0.005*ii >= Tx
                    sx(ii) = sx(ii-1);
                else
                    if (Tx3>0)
                        if 0.005*ii >= (Tx3)% + T)
                            %s = s(i-1) + 1/2 * a(max) *dt^2 + v(i-1)*dt
                            sx(ii) = sx(ii-1) - 0.5 * amax_X_ * (0.005*ii - 0.005*(ii-1))^2 + perfil_vel_x(ii-1)*(0.005*ii-0.005*(ii-1));
                        else 
                            %s = s(i-1) + v(max)*dt
                            sx(ii) = sx(ii-1) + vmax_X_*(0.005*ii-0.005*(ii-1));
                        end
                    else % Desaceleracion
                        %s = s(i-1) + 1/2 * a(max) *dt^2 + v(i-1)*dt
                        sx(ii) = sx(ii-1) - 0.5 * amax_X_ * (0.005*ii - 0.005*(ii-1))^2 + perfil_vel_x(ii-1)*(0.005*ii-0.005*(ii-1)); 
                    end
                end
                
            end
            if (sy(end) == 0 || sy(end) - sy(end-1)> 1)
                sy(end) = sy(end-1);
            end
            if (sx(end) == 0 || sx(end) - sx(end-1)> 1)
                sx(end) = sx(end-1);
            end

        end
        
%_____________________________________________________________________________________________________________________
%__________________________________________________END FUNCIONES______________________________________________________
%_____________________________________________________________________________________________________________________


end