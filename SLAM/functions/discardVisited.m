function result = discardVisited(candidates,r)
global map;

    x = [];
    y = [];
    result = [];
    
    robot_position = map.estimated(end).x(1:2);

    hold on;
    % get the list of nearby visited points
    for i=1:length(map.estimated)
        visited_point = map.estimated(i).x(1:2);
        if InsideCircle(visited_point,robot_position,r)
%             plot(visited_point(1),visited_point(2),'.r');
            x = [x;visited_point(1)];
            y = [y;visited_point(2)];
        else
%             plot(visited_point(1),visited_point(2),'.g');
        end
    end
    
    nearby_visited_points = [x,y];
    nearby_visited_points = unique(round(nearby_visited_points,2),'rows');

    
    % for each reachable candidate point
    for i=1:length(candidates)
        candidate = candidates(i,:);
        % si la circ del candidato corta con circ de puntos visitados (r=1)
        % el punto se descarta
        if (~closeEnough(candidate,nearby_visited_points,0.5))
            % draws the free path
            % plot([robot_position(1),candidate(1)],[robot_position(2),candidate(2)],'g');
            result = [result; candidate];
        end
    end
    
end