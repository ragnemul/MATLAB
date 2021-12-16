function observations = get_observations (ground, sensor, step)
%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2004
%-------------------------------------------------------
%-------------------------------------------------------
global configuration;


twr = ground.trajectory(end).x;
% Se calcula la localización inversa para este punto. Ver doc Caste_AMR_2006.pdf
trw = tinv(twr);


xp = []; yp = [];


twp = [ground.points [xp; yp]];
trp = tpcomp(trw, twp);


x = trp(1:2:end);
y = trp(2:2:end);

[tita, rho] = cart2pol (x, y);

% los indices que cumplen el criterio están en visibles
visible = find((rho < sensor.range) & (tita >= sensor.minangle) & (tita <= sensor.maxangle));

%xv toma el valor de las x que cumplen el criterio de visibilidad
xv = x(visible);
%yv toma el valor de las y que cumplen el criterio de visibilidad
yv = y(visible);
%idem rhov
rhov = rho(visible);
%idem titav
titav = tita(visible);

observations.ground = [xv; yv];

srho = rhov * sensor.srho;
stita = ones(size(titav)) * sensor.stita;
xn = [];
yn = [];
Rn = [];

for i=1:length(srho),
    Ri = diag([srho(i)^2 stita(i)^2]);
    
    Ji = [cos(titav(i)) -rhov(i)*sin(titav(i))
        sin(titav(i))  rhov(i)*cos(titav(i))];
    
    if configuration.noise
        ni = gaussian_noise(Ri);
    else
        ni = [ 0; 0];
    end
    
    rhoi = rhov(i) + ni(1);
    titai = titav(i) + ni(2);
    [xi, yi] = pol2cart(titai,rhoi);
    xn = [xn; xi];
    yn = [yn; yi];
    Ri = Ji * Ri * Ji';  
    Rn = blkdiag(Rn, Ri);
end


trp = [xn'; yn'];
trp = reshape(trp, [], 1);

observations.m = length(srho);
observations.z = trp;
observations.R = Rn;
observations.ground_id = visible .* [visible <= ground.n];
