function result = closedToSegment(a,b,c,color)

    hold on;
    

    plot([a(1) b(1)],[a(2) b(2)],color);
    
    result=CircleIntersect(c,0.5,a,b);

    h=plot(c(1),c(2),'*g');
    if (result)
        set(h,'Color',color);
    else
        set(h,'Color','r');
    end
end