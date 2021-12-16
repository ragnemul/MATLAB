function candidates = FreeWay(sampling,r)
    global map;
    x = [];
    y = [];
    candidates = [];
    
    hold on;
    % get the list of nearby obstacles
    for i=4:2:(map.n+1)*2
        if InsideCircle(map.x(i:i+1),map.estimated(end).x(1:2),r)
%             plot(map.x(i),map.x(i+1),'*r');
            x = [x;map.x(i)];
            y = [y;map.x(i+1)];
        else
%             plot(map.x(i),map.x(i+1),'*b');
        end
    end
    
    nearby_obstacles = [x,y];
    
    % for each sampling point 
    for s_i=1:length(sampling)
        % for each nearby obstacle
        valid_point = directView(nearby_obstacles,map.x(1:2),sampling(s_i,1:2),0.5);
        if (valid_point)               
            % draws the free path
            plot([map.x(1),sampling(s_i,1)],[map.x(2),sampling(s_i,2)],'r');
            candidates = [candidates; sampling(s_i,1:2)];
        end
    end
end