%% insice = InsiceCircle(P,C,r)
% devuelve true si el punto P=[x,y] está dentro de la circunferencia
% definida por el centro C=[x0,y0] de radio r
%}
function inside = InsideCircle(P,C,r)
    inside = (P(1)-C(1))^2+(P(2)-C(2))^2 <= r^2;
end