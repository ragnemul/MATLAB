function steps = insert_movs_360
global ground;

if (length(ground) == 0)
    steps_before = 0;
else
    steps_before = length(ground.motion);
end
%angle = ground.motion(steps_before).x(3);

for step = steps_before: steps_before+3
    % incremental angel over the last position
    %angle = mod(angle + pi/2,2*pi);
    ground.motion(step+1).x = [0 0 pi/2]';
    ground.motion(step+1).P = diag([0.03 0.03 2.5*pi/180].^2);   
    ground.motion(step+1).planifica = false;
end

% se pide planificación para el ultimo punto
ground.motion(step+1).planifica = true;

steps = length(ground.motion);