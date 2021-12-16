function result = Route(PGoal,sampling)
    global map;
    global ground;
    
    fprintf("Buscando ruta...");
    
    % punto inicial es la posiciñon actual del robot
    Pini = ground.trajectory(end).x(1:2)';

    if (sampling)
        % puntos del sampling
        CfreePoints = navSampling;
    else
        CfreePoints = [];
    end
    
    % se añaden los puntos ini y fin o todo el espacio recorrido
    CfreePoints = [CfreePoints;Pini];
    CfreePoints = [CfreePoints;PGoal];
    
    
    % puntos de la trayectoria del robot, incluyen giros por lo que tienen
    % la misma posición varias veces
    X=[ground.trajectory.x]';
    CfreePoints = [CfreePoints;X(:,1:2)];
    
    % puntos unicos
    CfreePoints = unique(CfreePoints(:,1:2),'rows');
    
    
    
    CfreeIdx = [1:length(CfreePoints)]';
        
    % Graph initialization
    G = graph([[],[]]);
    
    % inserta el string correspondiente al indice dentro de CfreePoints
    % que tiene el punto Pini
    Pini_idx_str = num2str(posIdx(Pini,CfreePoints));
    G= addnode(G,Pini_idx_str);
    
    while (~isempty(CfreeIdx))
        % primer punto del conjunto de muestreo
        p_idx = CfreeIdx(1);
        p = CfreePoints(p_idx,:);
        CfreeIdx(1) = [];
        % p_sample=plot(p(1),p(2),'*g');
        
        % Si en el grafo generado hay conectividad con el punto final hemos terminado
        node2goal = nearestPoint(G,PGoal,CfreePoints);
        if (length(node2goal) > 0)
            break;
        end
        
        % No hay punto cercano porque no hay path libre, o por sampling
        % muy escaso. 
        node = nearestPoint(G,p,CfreePoints);
        if (isempty(node))
            
            CfreeIdx = [CfreeIdx;p_idx];
            % set(p_sample,'Visible','off');
            continue;
        end
        
        % get the node coordenates
        node_coords = CfreePoints(node,:);
        p_node = plot (node_coords(1),node_coords(2),'g*');
        
        % adds the new vertex to the graph
        dist = pdist([p;node_coords],'euclidean');
        G = addedge(G,num2str(node),num2str(p_idx),[1]);
        plot([p(1),node_coords(1)],[p(2),node_coords(2)],'k','LineWidth',4);
        
        drawnow;
    end
    
    % adding the goal
    node = nearestPoint(G,PGoal,CfreePoints);
    if (isempty(node))
        fprintf('CAN NOT CONNECT GOAL POINT\n\tIncrease the sampling...')
        return;
    else
        PGoal_idx = posIdx(PGoal,CfreePoints);
        PGoal_idx_str = num2str(PGoal_idx);
        node_coords = CfreePoints(node,:);
        
        % add the vertex to the goal node
        dist = pdist([PGoal;node_coords],'euclidean');
        G = addedge(G,num2str(node),PGoal_idx_str,[1]);
        
        plot([PGoal(1),node_coords(1)],[PGoal(2),node_coords(2)],'k','LineWidth',4);
    end

    % shows the graph
%     plotGraph(G,CfreePoints,CfreeIdx);
    
    % gets the shortest route
    result = getShortestPath(G,Pini_idx_str,PGoal_idx_str,CfreePoints);
    
end

function plotGraph(G,CfreePoints,CfreeIdx)
    for i = 1:G.numedges
        p1_idx = str2num(G.Edges.EndNodes{i,1});
        p1 = CfreePoints(p1_idx,:);
        
        p2_idx = str2num(G.Edges.EndNodes{i,2});
        p2 = CfreePoints(p2_idx,:);
        
        plot([p1(1),p2(1)],[p1(2),p2(2)],'-og');
    end
end

function result = getShortestPath(G,Pini_idx_str,PGoal_idx_str,CfreePoints)
    result = [];

    P = shortestpath(G,Pini_idx_str,PGoal_idx_str);
    [m,n] = size(P);
    
    for i=1:n-1
        p1 = CfreePoints(str2num(P{i}),:);
        p2 = CfreePoints(str2num(P{i+1}),:);
        result=[result;p2];
        plot([p1(1),p2(1)],[p1(2),p2(2)],'-og','LineWidth',4);
    end
end


