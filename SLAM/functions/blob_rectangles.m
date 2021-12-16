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