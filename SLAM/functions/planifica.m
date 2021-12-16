function result = planifica (step)
global sensor;
global map;
global ground;

   
    % Si se puede hacer sampling y ruta
    if ground.motion(step).planifica == true

        % hacemos un sampling de los puntos sobre la zona cercana
        sampling_points=sampling([0,2*pi],[1 sensor.range-1],map.estimated(end).x(1:2),70);

        % se obtienen los puntos libres de colisiones desde la pos. act.
        candidates = FreeWay(sampling_points,sensor.range);
        
        if (length(candidates) > 0)
            % se descartan los candidatos que estén cerca de zonas visitadas
            candidates = discardVisited(candidates,sensor.range);
            
            num_motions = length(ground.motion);
            
            if (length(candidates) > 0)
                target = selectCandidate(candidates,'euclidean');
                giro = calcTurn(map.estimated(end).x,target);
                
                % se planifica un giro hacia el nuevo punto
                ground.motion(num_motions+1).x = [0,0,giro]';
                ground.motion(num_motions+1).P = diag([0.03 0.03 2.5*pi/180].^2);
                ground.motion(num_motions+1).planifica = false;
                
                % se planifica un movimiento hacia el punto
                target_distance = getStepDistance(giro,map.estimated(end).x(1:2),target,'euclidean');
                
                ground.motion(num_motions+2).x = [target_distance;0;0];
                ground.motion(num_motions+2).P = zeros(3,3);
                ground.motion(num_motions+2).planifica = true;
            end
        end
    end
    
    result = length(ground.motion);
end