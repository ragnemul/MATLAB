function viable = viablepath (pA, pB, obstacles)

% esta función evalúa la viabilidad de un camino entre dos puntos: A y B
% dentro de un mapa con obstáculos (obtacles)
% recibe las coordenadas (x, y) de dos puntos (A, B) y un
% vector de obtáculos (2 x el nº de obtáculos).
% devuelve la confirmación de viabilidad del camino.

% y=m*x+b

m=(pB(1)-pA(1))/(pB(2)-pA(2)); % Problemas con la pendiente infinita  
b=pA(1)-m*pA(2);
vectorAB=pB-pA;
rows = size(obstacles,1);
viable=1;
for i = 1:(rows)  
    inside=0;
    obstaclepoint=obstacles(i,:);
    yC=m*obstaclepoint(1)+b;
    if ((yC<=obstaclepoint(2)+1) && (yC>=obstaclepoint(2)-1))  % Se comprueba todo el rango de y
        inside=1;
    end
    xC=(obstaclepoint(2)-b)/m;
    if ((xC<=obstaclepoint(1)+1) && (xC>=obstaclepoint(1)-1))  % Se comprueba todo el rango de x
        inside=1;
    end
    if (m==inf || m==-inf)
        if (pA(2)==obstaclepoint(1) || pB(2)==obstaclepoint(1))
            long=min(pA(1),pB(1)):max(pA(1),pB(1));
            inside=find(long==obstaclepoint(2));
            if inside~=0
                viable=0;
                break;
            end
        end
    end    
    if (inside==1) % Si pertenece a la recta
        vectorAC=[(obstaclepoint(2)-pA(1)),(obstaclepoint(1)-pA(2))];
        dotAC=dot(vectorAB, vectorAC);
        dotAB=dot(vectorAB, vectorAB);
        if dotAC > 0 && dotAC < dotAB
            viable=0;
            break
        end
    end 
end
end