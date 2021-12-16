function result = closeEnough(candidate,nearby_visited_points,r)
    result = false;
    
    for i=1:length(nearby_visited_points)
        visited = nearby_visited_points(i,:);
        [xout,yout] = circcirc(candidate(1),candidate(2),r,visited(1),visited(2),r);
        if (~isnan(xout))
            result = true;
            break;
        end
    end
end