function result = vectorRadians(P)

    alpha = abs(asin(P(2)/sqrt(P(1)^2+P(2)^2)));
    if P(1) >= 0
        if P(2) >= 0
            % primer cuadrante
            result = alpha;
        else
            % cuarto cuadrante
            result = 2*pi-alpha;
        end
    elseif P(2) >= 0
        % segundo cuadrante
        result = pi - alpha;
    else
        % tercer cuadrante
        result = pi + alpha;
    end
end