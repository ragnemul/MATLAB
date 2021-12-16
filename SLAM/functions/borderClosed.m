% Verifica si el perímetro está cerrado (result = true)
% si no está cerrado devuelve el punto p del recorrido realizado
% con mayor conectividad sobre el segmento abierto del recorrido
function [result,p, target] = borderClosed (border_line)
global ground;
global map;

    result = false;
    p = [];
    target = [];

    fprintf("Comprobando si el perímetro está cerrado\n");
    distances=[];
    for i=1:length(border_line)-1
        dist = pdist([border_line(i,:);border_line(i+1,:)],'euclidean');
        if (dist > 1.1)
            segmento=[{border_line(i,:)},{border_line(i+1,:)},dist];
            distances = [distances;segmento];
        end

    end



    % condición de salida
    [r,c]=size(distances);

    % si todas las distancias son menores de 1.1 hemos terminado
    if (r == 0)
        result = true;
        return;
    else
        distances = sortrows(distances,3,'descend');
        % si la distancia mayor es inferior a dos se da por concluido
        if (distances{1,3} <= 2)
            result = true;
            return;
        end
    end


    recorrido = getTrajectory;
    obstacles = getObstacles;

    fprintf ("El perímetro está abierto\n");
    fprintf("Buscando puntos del recorrido con visibilidad al hueco\n");
    % para cada segmento que muestra un hueco
    for i=1:length(distances(:,1,:))

        % extremos del segmento
        p1 = distances{i,1};
        p2 = distances{i,2};

        % puntos del segmento según distancia entre sus puntos
        [xx,yy] = fillLine(p1,p2,2 + round(distances{i,3}));
        puntos_segmento=[xx;yy]';

        % se localiza el punto ya recorrido (ground.motion) más
        % cercano con vista directa a cualquiera de los puntos del
        % segmento

        candidates=[];
        for j=1:length(recorrido)
            % para cada punto del recorrido hecho
            fprintf("%d: ",j);
            for k=1:length(puntos_segmento)
                % para cada punto del segmento, se coprueba si el punto del
                % recorrido tiene conectividad con cada punto del segmento
                valid_point = directView(obstacles,recorrido(j,1:2),puntos_segmento(k,1:2),0.5);
                if (valid_point)
                    % draws the free path
%                     plot([recorrido(j,1),puntos_segmento(k,1)],[recorrido(j,2),puntos_segmento(k,2)],'g');
                    candidates = [candidates; recorrido(j,1:2)];
                    fprintf("*");
                else
                    fprintf(".");
%                     plot([recorrido(j,1),puntos_segmento(k,1)],[recorrido(j,2),puntos_segmento(k,2)],'r');
                end
            end
            fprintf("\n");
        end

        fprintf("\nLocalizando punto target sobre el hueco del perímetro\n");
        if (length(candidates))
            % posiciones al principio el punto actual de exploración
            candidates = flipud(candidates);

            % punto del recorrido con más conectividad
            [C,ia,ib]=unique(candidates,'rows','stable');
            [val,idx]=max(hist(ib,max(ib)));
            p = C(idx,:);

            [xx,yy] = fillLine(p1,p2,3);
            puntos_segmento=[xx;yy]';
            target = puntos_segmento(2,:);
            
            break;
        end

    end



end

