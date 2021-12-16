%POL2CART_OFF Transform polar to Cartesian coordinates.
%   [X,Y] = POL2CART(TH,R,P) transforms corresponding elements of data
%   stored in polar coordinates (angle TH, radius R) to Cartesian
%   coordinates X,Y and applies P offset. The arrays TH and R must the same size (or
%   either can be scalar).  TH must be in radians.
%
%   Class support for inputs TH,R,Z:
%      float: double, single

function [x,y] = pol2cart_off(th,r,p)
x = r.*cos(th) + p(1);
y = r.*sin(th) + p(2);