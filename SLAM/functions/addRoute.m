function [result,new_step,pos_actual] = addRoute(points_to_go,step,steps,plan,little_step,pos_anterior)
global map;
global ground;


    new_step = step;
    pos_actual = map.estimated(end).x;
    result = length(ground.motion);
    
    if length(points_to_go) == 0
        return;
    end
    
    

    % evitamos la planificación en el último punto
    if (step <= steps)
        % desechamos la ultima planificacion
        if (~little_step)
            ground.motion=ground.motion(1:steps-2);
            new_step = steps-1;
        end
    else
        ground.motion(step-1).planifica = false;
    end
    
    num_motions = length(ground.motion);
    if (little_step)
        pos_actual=pos_anterior;
    else
        pos_actual = map.estimated(end).x;
    end
    
    for i=1:length(points_to_go(:,1))
        target = points_to_go(i,:);
        giro = calcTurn(pos_actual,target);
        
        % se planifica un giro hacia el nuevo punto
        ground.motion(num_motions+1).x = [0,0,giro]';
        ground.motion(num_motions+1).P = diag([0.03 0.03 2.5*pi/180].^2);
        ground.motion(num_motions+1).planifica = false;
        
        % se planifica un movimiento hacia el punto
        if (little_step)
            target_distance = 0.8;
        else
            target_distance=pdist([pos_actual(1:2)';target],'euclidean');     
        end
        ground.motion(num_motions+2).x = [target_distance;0;0];
        ground.motion(num_motions+2).P = zeros(3,3);
        ground.motion(num_motions+2).planifica = false;
        
        % giro acumulado considerando la posición actual
        giro = giro + pos_actual(3);
        % nueva posición
        pos_actual = [target(1);target(2);giro];
        
        num_motions = num_motions+2;
    end
    
    result = length(ground.motion);
    
    if (plan)
        % planifica en el ultimo paso
        ground.motion(result).planifica = true;
    end
end