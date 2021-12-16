function result = getObstacles
global map;

    items = map.n*2+3;
    result = [map.x(4:2:items),map.x(5:2:items)];
end