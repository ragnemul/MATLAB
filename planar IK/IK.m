% LUIS MENENDEZ
% ragnemul@gmail.com

% Se asumen lo siguiente
% 1: el robot no tiene limitación de movimientos
% 2: el objetivo debe estar en el rango de alcance del robot. Si 
%   el objetivo cae fuera del alcance, el bucle no terminará
% La cofniguración original del robot se pinta en azul. 
% El asteristo (*) azul indica el objetivo
% El simbolo más (+) indica el efector
% la configuración final se dibuja en verde

close all;
clear all;
hold on;
axis([-50 50 -50 50])

% Longitud de los segmentos
a1 = 10;
a2 = 10;
a3 = 10;

% angulos de las articulaciones
q1=0.10;
q2=0.10;
q3=0.10;

% Objetivo
Xf=5;
Yf=15;
plot(Xf,Yf,"b*");

% valores actuales
Xi=0;
Yi=0;

% actualizaciones 
Xd = Xi - Xf;
Yd = Yi - Yf;

% Se fija el error respecto al objetivo
Xe = 0.1;
Ye = 0.1;

% Se dibuja la posicion inicial
dibuja_robot ([a1,a2,a3],[q1,q2,q3]);

continuar = true;
while (continuar)
    J=[-a1*sin(q1)-a2*sin(q1+q2)-a3*sin(q1+q2+q3)   -a2*sin(q1+q2)-a3*sin(q1+q2+q3)     -a3*sin(q1+q2+q3);
        a1*cos(q1)+a2*cos(q1+q2)+a3*cos(q1+q2+q3)   a2*cos(q1+q2)+a3*cos(q1+q2+q3)      a3*cos(q1+q2+q3);
        1                                           1                                   1];

    Jinv = inv(J);

    % actualización velocidad efector
    Pd = [Xi;Yi;1];

    % actualización velocidad articulaciones
    Qd = Jinv * Pd;

    % actualización ángulos
    q1 = q1 + Qd(1);
    q2 = q2 + Qd(2);
    q3 = q3 + Qd(3);

    % actualización posición actual (DK)
    Xi = a1*cos(q1) + a2*cos(q1+q2) + a3*cos(q1+q2+q3);
    Yi = a1*sin(q1) + a2*sin(q1+q2) + a3*sin(q1+q2+q3);
    
    Xd = Xi - Xf;
    Yd = Yi - Yf;
    
    if (abs(Xd) <= Xe) && (abs(Yd) <= Ye)
        plot(Xi,Yi,"b+");
        dibuja_robot ([a1,a2,a3],[q1,q2,q3]);
        hold on;
  
        continuar=false;
    end
    
end



function dibuja_robot(segmentos,angulos)
    x(1) = 0;
    y(1) = 0;
    plot(x(1),y(1),"r*");
    
    x(2) = x(1) + segmentos(1) * cos(angulos(1));
    y(2) = y(1) + segmentos(1) * sin(angulos(1));
    plot(x(2),y(2),"r*");
    
    x(3) = x(2) + segmentos(2) * cos(angulos(1) + angulos(2));
    y(3) = y(2) + segmentos(2) * sin(angulos(1) + angulos(2));
    plot(x(3),y(3),"r*");
    
    x(4) = x(3) + segmentos(3) * cos(angulos(1) + angulos(2) + angulos(3));
    y(4) = y(3) + segmentos(3) * sin(angulos(1) + angulos(2) + angulos(3));
    plot(x(4),y(4),"r+");
    
    plot(x,y);
    xlim([0 70]);
    ylim([0 70]);
    grid on;
end
