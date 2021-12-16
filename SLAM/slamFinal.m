% Luis Menendez (ragnemul@gmail.com)
% Modificación del proyecto SLAM_Zaragoza para dotarlo de capacidades de navegacion
% y planificación

echo off;

clear all;
close all;

addpath 'tools';
addpath 'functions';
addpath 'maps';

% comentar para obtener repetitividad en los números aleatorios(sampling)
% rng('shuffle','threefry');

%{
map1: stepDistance: euclidean, samplig: 40, r: 1 y 0.75
map2: stepDistance: euclidean, samplig: 40, r: 0.5 y 0.75
map3: stepDistance: euclidean, samplig: 40, r: 1 (se queda en un hueco)
%}


[mymap,landmarks] = load_map("map6.csv");
PINI = [2,2]; % punto de inicio libre en el mapa


% determines execution and display modes
global configuration;

configuration.ellipses = 1;
configuration.tags = 0;
configuration.odometry = 1;
configuration.noise = 1;
configuration.alpha = 0.99;
configuration.step_by_step = 0;

% figure numbers
configuration.ground = 1;
configuration.map = 2;
configuration.observations = 3;
configuration.compatibility = 4;
configuration.ground_hypothesis = 5;
configuration.hypothesis = 6;
configuration.tables = 7;

% variables you need in several places
global map ground sensor chi2 results;

%chi2 = chi2inv(configuration.alpha,1:1000);

load 'data/chi2';
%PONER AQUI EL NOMBRE CON EL QUE QUEREMOS GUARDAR EL CSV
filename = 'mapa.csv';
[i,j] = size(mymap);
z = zeros((i+1), (j+1));



sensor.range = 5;
sensor.minangle = -pi/2;
sensor.maxangle = pi/2;
sensor.srho = 0.01;
sensor.stita = 0.125*pi/180;

% generate the experiment data
%ground = generate_experiment;

insert_movs_360;


% insert the map landmarks
ground.n = numel(landmarks(1,:));
ground.points = landmarks;

ground.trajectory(1).x = [0 0 0]';
ground.trajectory(1).P = zeros(3, 3);
% generate the experiment data

% start with a fresh map
[map, ground] = new_map(PINI,map, ground);

% plot ground
draw_ground(PINI,ground);

fprintf ("\nPULSA ENTER PARA CONTINUAR\n");
pause

% ok, here we go
step = 1;
observations = get_observations(ground, sensor, step);
draw_observations (observations, ground, step);

GT = zeros(1, observations.m);
H = zeros(1, observations.m);

map = add_features(map, observations);

results.total = [];
results.true.positives = [];
results.true.negatives = [];
results.false.positives = [];
results.false.negatives = [];

results = store_results (results, observations, GT, H);

% plot map
configuration.name = '';
draw_map (map, ground, step);

steps = length(ground.motion);
cont = true;
f3 = figure;

while cont
%for step = 2 : steps,
    
    step = step + 1; 
    
   
    %{
    disp('--------------------------------------------------------------');
    disp(sprintf('Step: %d', step));
    %}
    
    %  EKF prediction step
    motion = ground.motion(step - 1);    
    ground = move_vehicle (ground, motion);    
    odometry = get_odometry (motion);    
    map = EKF_prediction (map, odometry);    
    
    % sense
    observations = get_observations(ground, sensor, step);
    
    % individual compatibility
    prediction = predict_observations (map, ground);
    compatibility = compute_compatibility (prediction, observations);

    %{
    disp(sprintf('Hypothesis: %d', compatibility.HS));
    disp(['IC: ' sprintf('%2d   ', compatibility.AL)]);
    disp(' ');
    %}
    
    % ground truth
    GT = ground_solution(map, observations);
    %{
    disp(['GT: ' sprintf('%2d   ', GT)]);
    disp(' ');
    %}

    % your algorithm here!
    % 1. Try NN
    % 2. Complete SINGLES and try it
    % 4. Try JCBB
   
    H = NN (prediction, observations, compatibility);
%      H = SINGLES (prediction, observations, compatibility);
%    H = JCBB (prediction, observations, compatibility);

%    configuration.step_by_step = not(prod(H == GT)); % discrepance with ground truth

    draw_map (map, ground, step);
    draw_observations (observations, ground, step);
    
    
    draw_compatibility (prediction, observations, compatibility);

    %disp(['H : ' sprintf('%2d   ', H)]);
    %disp(['    ' sprintf('%2d   ', GT == H)]);
    %disp(' ');
    
    draw_hypothesis (prediction, observations, H, 'NN:', 'b-');
    draw_hypothesis (prediction, observations, GT, 'JCBB:', 'b-');
    draw_tables (compatibility, GT, H);
    
    % update EKF step
    map = EKF_update (map, prediction, observations, H);
    

    % only new features with no neighbours
    new = find((H == 0) & (compatibility.AL == 0));
    
    if nnz(new)
       %disp(['NEW: ' sprintf('%2d   ', new)]);
       map = add_features(map, observations, new);
    end

    draw_map (map, ground, step);
    results = store_results(results, observations, GT, H);
    
    if configuration.step_by_step
        wait
    else
        drawnow;
    end
    
    steps = planifica (step-1);
    
    % nos hemos quedado sin puntos para explorar
    % volvemos al origen
    if (step-1) == steps
        routeToEnd(PINI,step,steps);
        break;
    end
    
    % si estamos ejecutando instrucciones programadas saltamos este paso
    % para no interferir en la programación
    if (ground.motion(step-1).planifica)   
        [closed,p,steps,step,pos_actual] = veHaciaLaLuz(step,steps,10);
        if closed
            break;
        end
        % sí hay huecos en el perimetro pero no se puede llegar a ellos
        % desde el recorrido efectuado por el robot
        if (length(p) == 0)
            [perimetro,superficie,puntos_recorrer] = superficieRecorrida;
            if (perimetro >= 0.97) || (superficieRecorrida >= 0.90)
                fprintf("Perímetro recorrido: %.2f%c\n",perimetro*100,'%');
                fprintf("Superficie recorrida: %.2f%c\n",superficie*100,'%');
                break;
            else
                % hay que explorar ese hueco tratando de llegar a la
                % regilla que lo contiene desde un punto recorrido por el
                % robot usando el grafo generado
                continue;
            end
        end
        
    end
    
end

Route(PINI,true);
fprintf("\nGoal position reached!!! \n");
[perimetro,superficie,puntos_recorrer] = superficieRecorrida;
fprintf("Perímetro recorrido: %.2f%c\n",perimetro*100,'%');
fprintf("Superficie recorrida: %.2f%c\n",superficie*100,'%');


fprintf("\n PULSA ENTER PARA VER EL MAPA GENERADO\n");
pause

[z, refMap1 ]= ImprimeMapaObstaculos(map,z,filename);
figure;
show(refMap1);

%show_results(map, ground, results);
