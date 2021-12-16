function result = navSampling
    global map;
    
    % obtenemos el polígono frontera de los puntos explorados
    border = borderLine(0,'g');
    
    XY_min = min(border);
    XY_max = max(border);
    
    % puntos aleatorios
    xq =  (XY_max(1)-XY_min(1)).*rand(200,1) + XY_min(1);
    yq =  (XY_max(2)-XY_min(2)).*rand(200,1) + XY_min(2);
    
    in = inpolygon(xq,yq,border(:,1),border(:,2));
    
    % sampling dentro del polígono del límite
    sampling = [xq(in),yq(in)];
    num_sampligs = length(sampling);
    
    obstacles = getObstacles;
    num_obstacles = length(obstacles);
    
    % calcula la distancia entre cada sampling y los obstáculos
    distances = zeros(num_sampligs,num_obstacles);
    for r=1:num_sampligs
        for c=1:num_obstacles
            distances(r,c)=pdist([sampling(r,:);obstacles(c,:)],'euclidean');
        end
    end
    
    out = [];
    for r=1:num_sampligs
        if sum(distances(r,:)<1.5) > 2
            out = [out;1];
        else
            out = [out;0];
        end
    end
    
    x=sampling(:,1);
    y=sampling(:,2);
    result=[x(~out),y(~out)];
    
    hold on;
%     plot(result(:,1),result(:,2),'*r');
end