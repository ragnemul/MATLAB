function target = selectCandidate (candidates,criteria)
    global map;
    
    % posición del robot
    r_pos = map.estimated(end).x(1:2);
    
    distances = [];
    for i=candidates'
        distances = [distances,pdist([r_pos';i'],criteria)];
    end
    
    [val, idx] = max(distances, [], 2);
    target = candidates(idx,:);
end