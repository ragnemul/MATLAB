%Necesita esto en la cabecera de SLAM
%Se llama esta funció al final de cada step
% filename = 'filename.csv';
% [i,j] = size(mymap);
% z = zeros((i+1), (j+1));
function [z, refMap1] = ImprimeMapaObstaculos(map, z,csvfile)
      
     [fila, columna] = size(z);
     [filas, columnas] = size(map.x);
    
    Obstaculos = zeros(2, ((filas-3)/2));
    contador = 1; 
    for j = 3: 2 :((size(map.x)-3))

                Obstaculos(:,contador) = [map.x(j+1); map.x(j+2)];
%                 Obstaculos(1,contador) = Obstaculos(1,contador)*10;
%                 Obstaculos(2,contador) = Obstaculos(2,contador)*10;
                
                b =ceil(Obstaculos(1,contador));
                a = ceil(Obstaculos(2,contador));
                
                
                z(fila-a+1, b) = 1;


         contador = contador+1;

         
        
    end
    
    
   csvwrite(csvfile,z);
   mapPath1 = csvfile;
   simpleMap1 = csvread(mapPath1);
   refMap1 = binaryOccupancyMap(simpleMap1,1);
  
end
