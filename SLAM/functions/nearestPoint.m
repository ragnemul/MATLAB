function node = nearestPoint (G,p1,CfreePoints)

    min_dist = intmax;
    p_min_dist = [];
    
    obstacles = getObstacles;
    
    for i = 1:G.numnodes
        pidx = str2num(G.Nodes(i,1).Name{1});
        p = CfreePoints(pidx,:);
        
        if ~directView (obstacles,p1,p,0.5)
            continue;
        end

        dist = pdist([p; p1],'euclidean');
        if (dist < min_dist)
            min_dist = dist;
            p_min_dist = pidx;
        end
    end
    node = p_min_dist;
end