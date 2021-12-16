function target_distance = getStepDistance(result,robot_position,target,distance)
    if (abs(result) > (pi/2))
        target_distance = 0;
    else
        target_distance = pdist([robot_position';target],distance);
    end
end