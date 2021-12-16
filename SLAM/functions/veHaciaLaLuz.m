function [closed,p,steps,step,pos_actual]=veHaciaLaLuz(step,steps,n)
global ground;
global map;

    closed = false;
    p = 0;
    pos_actual = [];

    if (mod(step-1,n) == 0) % 16 para map1, 20 para map2
        border_points = borderLine(0,'r');

        % closed indica si se ha completado el mapa, p el punto del
        % recorrido que esta mejor conectado con el hueco del mapa, y
        % target es el punto medio del segmento abierto del mapa
        [closed,p,target] = borderClosed(border_points);
        if closed || length(p) == 0
            return
        end
        
        % go back to the route point with more conectivity with the
        % unexplored area, without plan at the end step
        points2go = Route(p,false);
        if length(points2go) == 0
            % Se elimina la planificacion recien hecha
            ground.motion=ground.motion(1:steps-2);
            steps = steps-2;

            % Se actualiza la posicion actual que sera necesaria
            % para adelantar el paso hacia el hueco
            pos_actual = map.estimated(end).x;
        else
            [steps,step,pos_actual] = addRoute(points2go,step,steps,false,false,[0;0;0]);
        end
        % insert the points that connect with the middle of the
        % unexplored area with a little step (last true value)

        [steps,step,pos_actual] = addRoute(target,step,steps,true,true,pos_actual);

    end
end