function [new_border] = borderLine(s,c)
    global map;

    items = map.n*2+3;
    [x] = map.x(4:2:items);
    [y] = map.x(5:2:items);

    k=boundary(x,y,s);

    hold on;
    plot(x(k),y(k),c);

    border_line = [x([k]),y([k])];
    new_border = [];

    tolerance = .2;
    for i=1:length(border_line)-1

        p1 = border_line(i,:);
        p2 = border_line(i+1,:);
        line = plot([p1(1),p2(1)],[p1(2),p2(2)],'g');

        % lista de puntos a añadir
        p_add=[];

        % para cada obstáculo detectado
        for o_i=1:length(x)

            % tomamos un punto del conjunto de obstáculos
            p = [x(o_i),y(o_i)];
            h = plot(p(1),p(2),'*r');

            % Si el punto está cerca del segmento lo insertamos
            if CircleIntersect(p,tolerance,p1,p2);
                set (h,'Color','g');
                p_add = [p_add;[{p},norm(p-p1)]];
            else
                set (h,'Visible','off');
            end
        end

        if (length(p_add) > 0)
            % se ordenan los puntos a añadir al segmento
            p_add=sortrows(p_add,2);

            % se añaden todos los puntos
            new_border = [new_border,p_add{:,1}];
        end

        set (line,'color','r');
    end

    items=length(new_border);
    x=new_border(1:2:items)';
    y=new_border(2:2:items+1)';

    new_border=[x,y];

end
