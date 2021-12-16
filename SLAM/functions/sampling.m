%% points = sampling(theta,rad,p,num_points)
% devuelve puntos aleatorios en coordenadas cartesianas dentro del rango 
% de coordenadas polares de los parámetros de entrada.
%
% rad=[radio_inicio radio_fin]. Rango del radio
% theta=[theta_ini, theta_fin]. Rango de los radianes
% p = [5 5]. Punto alrededor del cual se genera el sampling
% [x,y] = sampling([0, 2*pi],[1 5],[5 5])
function points = sampling(theta,rad,p,num_points)
    theta_ini = theta(1);
    theta_end = theta(2);
    coord.theta = (theta_end-theta_ini).*rand(num_points,1) + theta_ini;

    rad_ini=rad(1);
    rad_end=rad(2);
    coord.rad = (rad_end-rad_ini).*rand(num_points,1) + rad_ini;
    
    [x,y] = arrayfun(@(c) pol2cart_off(c.theta,c.rad,p),coord,'UniformOutput',false);
    points = [x{1},y{1}];
% plotting the sampling
% figure;
% hold on;

% draws the circle
% theta_range = theta(1):pi/50:theta(2);
% x_circle = rad(2) * cos(theta_range) + p(1);
% y_circle = rad(2) * sin(theta_range) + p(2);
% plot (x_circle,y_circle,'g');

% draw the sampling points
% plot(p(1),p(2),'r*');
% plot(x{1,1},y{1,1},'g*');

    