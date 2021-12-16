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