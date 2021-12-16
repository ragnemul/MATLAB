%% load_map(mapfile)
% map2: binary map with 1's in free positions
% R: center and perimeter pixels for each non free position (0's)
function [map2,R_cart] = load_map(mapfile)

mapfile = csvread(mapfile);
[rows, cols] = size(mapfile);

%imshow(map,'InitialMagnification',20000);
%colormap(myColormap);



map2 = imcomplement(mapfile);
imshow(map2,'InitialMagnification',20000);

hold on;

% connected points
% cc.NumObjects
% blob=cc.PixelIdxList(i)
% blob{1} accede a la lista de pixels, desde 1 (1,1) = (col,row)
% avanzando por columnas
cc = bwconncomp(mapfile);

st2=regionprops(cc,'PixelList');
xy=cat(1,st2.PixelList);

% converting xy to cartesian coordenates
%xy_cart = [xy(:,1),rows-xy(:,2)+1];

% central point of each cell
plot(xy(:,1),xy(:,2),'r*')
% limits of each cell
R=blob_rectangles(xy);

% blobs landmarks with cartesian coordenates
R_cart=[R(1,:);rows-R(2,:)+1];

plot(R(1:1,:),R(2:2,:),'r*')

