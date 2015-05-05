function [ prev ] = calculatePrevious(in)
%this function caculates the previous coordinates based on current
%coordinates and the theta value
prev.x=in.x;
prev.y=in.y;
if (in.theta == 0 || in.theta == 360)
    prev.x=in.x-1;
elseif (in.theta == 90)
    prev.y=in.y-1;
elseif (in.theta == 180)
    prev.x=in.x+1;
else 
    prev.y=in.y+1;
end