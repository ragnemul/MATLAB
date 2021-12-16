function [perimetro,superficie,puntos_recorrer]=superficieRecorrida
global ground;
global map;

    disp 'Analizando superficie recorrida...';

    perimetro = 0;
    superficie = 0;
    puntos_recorrer=[];

    hold on;

    T = getTrajectory';

    % area of the perimeter convexhull
    X=getObstacles';
    obsxx = [X(1,:),T(1,:)];
    obsyy = [X(2,:),T(2,:)];
    k=convhull(obsxx,obsyy);

    xx = obsxx(k);
    yy = obsyy(k);
    plot(xx,yy,'g');

    aX = polyarea(xx,yy);

    % area of the minimun square box
    C=minBoundingBox([xx;yy]);
    plot(C(1,:),C(2,:),'r');

    aC=polyarea(C(1,:),C(2,:));

    % superficie recorrida
    perimetro = aX / aC;

    % matrix que refleja la ocupación de las rejillas regillas
    R = zeros(5,5);

    x = [min(C(1,:)),max(C(1,:))];
    dx = (x(2)-x(1)) / 5;

    y = [min(C(2,:)),max(C(2,:))];
    dy = (y(2)-y(1)) / 5;

    % punto del centro de la regilla sin referencias (obs. o recorrido)
    ptos_recorrer=[];

    area_no_recorrida = 0;

    c=1; % col for the cell
    % se recorren todas las celdas
    for i=x(1):dx:(x(2)-dx)
        r=5; % row for the cell
        for j=y(1):dy:(y(2)-dy)
            % rejilla (i,j) -> (i+dx,j+dy)
            xx = [round(i), round(i), round(i+dx),round(i+dx)];
            yy = [round(j), round(j+dy),round(j+dy), round(j)];
           
%             plot(xx,yy,'r');
            
            % obstaculos y recorrido dentro de cada regilla
            [in,out] = inpolygon(obsxx,obsyy,xx,yy);
            val = sum(in>0) + sum(out>0);
            
            % ver si cada tramo recorrido pasa por la regilla     
            if pasaPorRegilla(T,xx,yy)
                val = val + 20;
            end

            R(r,c) = val;

            if (val == 0)
                centro = [min(xx)+(max(xx)-min(xx))/2,min(yy)+(max(yy)-min(yy))/2];
                puntos_recorrer=[puntos_recorrer;centro];
                area_no_recorrida = area_no_recorrida + polyarea(xx,yy);
            end
            r = r - 1;
        end
        c = c + 1;
    end

    superficie = (aC - area_no_recorrida) / aC;
end

function result = pasaPorRegilla(T,xx,yy)
    poly = polyshape(xx,yy);
    % plot(poly);
    
    result = 0;
    
    for i=1:length(T(1,:))-1
        lineseg = [T(1,i) T(2,i); T(1,i+1) T(2,i+1)];
        [in,out] = intersect(poly,lineseg);
        
        %plot([T(1,i) T(1,i+1)],[T(2,i) T(2,i+1)],'r');
        
        result = result + length(in);
    end
    
    result = result > 0;    
end