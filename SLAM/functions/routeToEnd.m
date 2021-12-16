
% busca una routa al punto p, y si hay puntos la incluye en la estructura
% ground.motion planificando los movimientos
% p=[2,2]
function result = routeToEnd(p,step,steps)
% ruta sobre el espacio muestreado para volver al origen sin hacer
        % sampling
        points_to_origin = Route(p,false);
        % no hay ruta al origen y nos hemos quedado atascados
        if (length(points_to_origin) == 0)
            % se anade ruta al punto origen planificando de nuevo al final
            [steps,step,pos_actual] = addRoute(points_to_origin,step,steps,true,false,[0;0;0]);
        end
end