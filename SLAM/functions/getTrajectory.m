function result = getTrajectory
    global ground;
    
    recorrido = [];
    [t]={ground.trajectory(:).x}';
    for j=1:length(t)
        recorrido=[recorrido;t{j}(1:2)'];
    end
    result = unique(recorrido,'row','stable');
end
