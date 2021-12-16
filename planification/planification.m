close all;
clear all;

NUM_MAP=11;

ORIGEN_X = [3   3   5   5   4	3   4   3   4   4   4   3];     % lineas
ORIGEN_Y = [3   3	11  15  16  3   10  3   10  10  16  3];    % columnas

DESTINO_X = [8  11  5   5   4   11  4   11  4   4   4   11];     % lineas
DESTINO_Y = [3  8   15  11  10  18  16  18  16  16  10  18];    % columnas

path=strcat(strcat(strcat(strcat('master-ipr-master/map',num2str(NUM_MAP)),'/map'),num2str(NUM_MAP)),'.csv');
map = csvread(path);


[rows, cols] = size(map);
origin=[ORIGEN_X(NUM_MAP), ORIGEN_Y(NUM_MAP)];
goal=[DESTINO_X(NUM_MAP), DESTINO_Y(NUM_MAP)]; 


% mapa sin bordes para identificar los obstaculos dentro del mapa 
borderless_map = map(2:rows-1,2:cols-1);
[rows_r, cols_r] = size(borderless_map);

map = borderless_map;

axis on;

% Set 1 (obstacles) to black
myColormap(1,:) = [1,1,1];
% Set 0 (free) to white
myColormap(2,:) = [0,0,0];

imshow(borderless_map,'InitialMagnification',20000);
colormap(myColormap);



hold on;
plot(origin(2),origin(1),"r*");
plot(goal(2),goal(1),"g*");

%k = waitforbuttonpress;


% because of the small map resolution, we can sample all the points 
% in Cfree ;-)
Cfree = find(borderless_map < 1);

% another random


map(map==1)=2;
[m,n] = size(map);
A=logical(randi([0,1],[m,n]));
sampling=(A+map)==1;
Cfree = find(sampling == 1);


%{
Sampling over narrow passages
%}
B1 = [0 0 0;1 0 1;0 0 0];
B2 = [1 1 1;0 1 0;1 0 0];
S1 = bwhitmiss(borderless_map,B1,B2);

Cfree = unique([Cfree;find(S1 == 1)]);

Cfree = Cfree(randperm(length(Cfree)));
PaintSampling(rows_r,cols_r,Cfree);






% connected points
% cc.NumObjects
% blob=cc.PixelIdxList(i)
% blob{1} accede a la lista de pixels, desde 1 (1,1) = (col,row)
% avanzando por columnas
cc = bwconncomp(borderless_map);

st2=regionprops(cc,'PixelList');
xy=cat(1,st2.PixelList);
%
plot(xy(:,1),xy(:,2),'r*')

R=blob_rectangles(xy);
%
plot(R(1:1,:),R(2:2,:),'r*')



% Graph initialization
G = graph([[],[]]);


% insert the initial point 'origin' using linear index
origin_lin = sub2ind([rows_r,cols_r],origin(1),origin(2));
G = addnode(G,num2str(origin_lin));

while (~isempty(Cfree))   
    
    p = Cfree(1);
    [p_row,p_col] = ind2sub([rows_r,cols_r],p);
    p_sample=plot(p_col,p_row,'r*');   
    Cfree(1) = [];
    
    
    node2goal = nearest(G,goal,rows_r,xy, R);
    if (length(node2goal) > 0)
        break;
    end
    
    
    node = nearest(G,[p_row,p_col],rows_r,xy, R);
    % si no hay más cercano porque hay obst... 
    % en el primer punto de sampling la prob de que no haya camino directo 
    % con el nodo más cercado (primero) es muy alta
    % También puede ocurrir cuando el sampling es pequeño. En ese caso hay
    % que detectar esta situación y notificarlo.
    if (isempty(node))
        Cfree = [Cfree;p];
        set(p_sample,'Visible','off')
        continue;
    end
    
    % get the node coords
    [node_row,node_col] = ind2sub([rows_r,cols_r],node);
    p_node=plot(node_col,node_row,'g*');
    
    % adds the new vertex to the graph
    G = addedge(G,num2str(node),num2str(p),[1]);
    plot([p_col,node_col],[p_row,node_row]);
    
    drawnow;
end

% Adding the goal
node = nearest(G,goal,rows_r,xy,R);
if (isempty(node))
    fprintf('CAN NOT CONNECT GOAL POINT\n\tIncrease the sampling...')
    return;
else
    [node_row,node_col] = ind2sub([rows_r,cols_r],node);
    goal_lin = sub2ind([rows_r,cols_r],goal(1),goal(2));
    
    G = addedge(G,num2str(node),num2str(goal_lin),[1]);
    plot([node_col,goal(2)],[node_row,goal(1)]);
end

plotGraph(G,rows_r);

P = shortestpath(G,num2str(origin_lin),num2str(goal_lin));
[m,n] = size(P);
%PATH=cell2mat(P);
%[P_row,P_col] = ind2sub([rows_r,cols_r],PATH);
%smoothedP = pchip(P,'gaussian',50);

for i=1:n-1
    p1 = PixelId2MatrixCoord(str2num(P{i}),rows_r);
    p2 = PixelId2MatrixCoord(str2num(P{i+1}),rows_r);
    plot([p1(2),p2(2)],[p1(1),p2(1)],'-og');   
end

function plotGraph(G,rows)
    for i = 1:G.numedges
        p1 = strnode2coord(G.Edges.EndNodes{i,1},rows);
        p2 = strnode2coord(G.Edges.EndNodes{i,2},rows);
        plot([p1(2),p2(2)],[p1(1),p2(1)],'-or');
    end
end

function coord = strnode2coord(strnode,rows)
     p_i = str2num(strnode);
     coord = PixelId2MatrixCoord(p_i,rows);
end

% returns (row, col) in coords
function coord = PixelId2MatrixCoord(xId,rows)
    coord = [mod(xId-1,rows)+1 fix((xId-1)/rows)+1];
end

% returns the ith node of the S(G) nearest to the sampled point alpha-i
% p_sampled: [row,col]
function node = nearest(G, p_sampled,rows, xy, R)
    S=G;
    min_dist = intmax;
    p_min_dist = [];
    for i = 1:S.numnodes
        pidx = str2num(S.Nodes(i,1).Name{1});          
        p = strnode2coord(S.Nodes(i,1).Name{1},rows);
        
        %if ~ArcoLibre([p_sampled(2), p_sampled(1)],[p(2),p(1)],R)
        if ~viablepath([p_sampled(1), p_sampled(2)],[p(1),p(2)],xy)
            continue;
        end
        
        dist = pdist([p; p_sampled],'euclidean');
        if (dist < min_dist) 
            min_dist = dist;
            p_min_dist = pidx;
        end   
    end
    node = p_min_dist;
end

function PaintSampling (rows_r,cols_r,C)
    for i = 1:size(C,1)
        [y,x]=ind2sub([rows_r,cols_r],C(i));
        plot(x,y,'+');
    end
end

%{
p: punto en coordenadas de la matriz
rectangle: los extremos del punto
%}
function rectangle = PixelPerimeter(p)  
    xbox = [p(1)-0.5 p(1)-0.5 p(1)+0.5 p(1)+0.5];
    ybox = [p(2)-0.5 p(2)+0.5 p(2)+0.5 p(2)-0.5];
    %mapshow(xbox,ybox,'DisplayType','polygon','LineStyle','none')
    
    rectangle = [[xbox];[ybox]];
end

%{
blob: BLOB correspondiente a la estructura cc.PixelIdList(i)
    Se pasa como parametro blob{1}
rentnagles: [xi yi], siendo cada elemento el vector de coordenadas de los
    limites del cuadrado que envuelve a cada pixel de CC
%}
function r = blob_rectangles (xy)

    n = size(xy,1); % # elements
    xi= []; % vector con las coordenadas Xi de los vertices del rect.
    yi= []; % vector con las coordenadas Yi de los vertices del rect.
    
    for i=1:n
        p = [xy(i,1), xy(i,2)];
        X = PixelPerimeter(p);
        xi = [xi X(1:1,:)];
        yi = [yi X(2:2,:)];
    end
    r = [xi;yi];
end

%{
Pi: Punto inicial del arco a comprobar (X,Y)
Pf: Punto final del arco a comprobar (X,Y)
R[X;Y]: 
    X: vector de las coordenadas X de los extremos de cada punto
    Y: vector de las coord. Y de los extremos de cada punto
    R(1:1,1:4),R(2:2,1:4) son los extremos del primer pixel de un blob
    R(1:1,5:9),R(2:2,5:9) son los extremos del segundo pixel de un blob  
%}
function libre = ArcoLibre(Pi,Pf,R)
    libre = true;
    
    x = [Pi(1) Pf(1)];
    y = [Pi(2) Pf(2)];
    
    %plot(Pi(1),Pi(2),"r*");
    %plot(Pf(1),Pf(2),"g*");
    %mapshow(x,y,'Marker','+');
    
    [m,n] = size(R(1:1,:)); %n/4 is the num of bloqs
    i=1;
    
    for i=1:(n/4)
        If = i*4;
        Ii = (If)-3;
        xbox = [R(1:1,Ii:If),R(1:1,Ii:Ii)]; % cinco coordenadas X para los cuatro tramos del rectangulo
        ybox = [R(2:2,Ii:If),R(2:2,Ii:Ii)]; % cinco coordenadas Y para los cuatro tramos del rectangul
        %mapshow(xbox,ybox,'DisplayType','polygon','LineStyle','--');

        [xi,yi] = polyxpoly(x,y,xbox,ybox,'unique');
        %mapshow(xi,yi,'DisplayType','point','Marker','o');
        
        libre = isempty(xi) & isempty(yi);
        
        if ~libre
            break
        end
    end
    
end



