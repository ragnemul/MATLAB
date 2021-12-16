function H = ONE (prediction, observations, compatibility)
%-------------------------------------------------------
% Funcion completada por Luis Menendez (100341264\alumnos.uc3m.es)
% Universidad Carlos III de Madrid (UC3M)
% Trabajo Individual Robots Moviles
%-------------------------------------------------------

global configuration;

H = zeros(1, observations.m);
% You have observations.m observations, and prediction.n
% predicted features.
%
% For every observation i, check whether it has only one neighbour,
% feature, and whether that feature j  has only that one neighbour
% observation i.  If so, H(i) = j.
%
% You will need to check the compatibility.ic matrix
% for this:
%
% compatibility.ic(i,j) = 1 if observation i is a neighbour of
% feature j.

for i = 1:observations.m,
    % number of neighbours features for each observation i
    Nf = find(compatibility.ic(i,:));
    if (length(Nf) > 1) || (length(Nf) == 0)
        continue;
    end
    
    % number of neighbours observations for each feature
    No = sum(compatibility.ic(:,Nf(1)));
    if (No > 1) || (No == 0)
        continue;
    end
    
    H(i) = Nf(1);
end

configuration.name = 'ONLY NEIGHBOUR';
