function valid_point = directView(obstacles, position, candidate,r)
%     plot (candidate(1),candidate(2),'+r');  
    valid_point = true;
    
    % draws the line
    %h1 = plot([position(1) candidate(1)],[position(2) candidate(2)],'g');
        
    i=1;
    while (i <= length(obstacles))
        if CircleIntersect(obstacles(i,1:2),r,position,candidate)
            valid_point = false;
            break;
        end
        i = i +1;
    end
    
    if (~valid_point)
        %set(h1,'Visible','off');
    end
end