%% Intersect = CircleIntersect(C,r,P1,P2)
% ans = CircleInterSect([5 5],1,[-2 -2],[2 2])
% devuelve 1 si hay una intersección entre el segmento delimitado por P1 y
% P2 y la circunferencia definida por el radio r con centro C
function Intersect = CircleIntersect(C,r,P1,P2)
    

    hold on;

    
    % draws the circle
%     theta = 0:pi/50:2*pi;
%     x = r * cos(theta) + C(1);
%     y = r * sin(theta) + C(2);
%     cir = plot (x,y,'g');
%     plot(C(1),C(2),'r*');
    

    if (P2(1)==P1(1))
        P2(1) = P2(1)-0.1;
    end
    m = (P2(2)-P1(2))/(P2(1)-P1(1));
    b = P2(2)-m*P2(1);
    
%     coefficients = polyfit([P1(1), P2(1)], [P1(2), P2(2)], 1);
%     m = coefficients (1);
%     b = coefficients (2);
    
    %{
    seg_x=P1(1):0.25:P2(1);
    seg_y=m*(seg_x-P1(1))+P1(2);
    seg=plot(seg_x,seg_y,'r-');
    %}
    
    [x,y]=linecirc(m,b,C(1),C(2),r);
    
    x_max = max(P1(1), P2(1));
    x_min = min(P1(1), P2(1));
    y_max = max(P1(2), P2(2));
    y_min = min(P1(2), P2(2));
    
    if (x(1) >= x_min && x(1) <= x_max && y(1) >= y_min && y(1) <= y_max) || (x(2) >= x_min && x(2) <= x_max && y(2) >= y_min && y(2) <= y_max)
       Intersect = 1;
    else
        Intersect = 0;
    end
    
    
%     set(cir,'Visible','off');
%     set(seg,'Visible','off');
    

    
    
    
    
    