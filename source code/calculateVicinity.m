function [ vicinity ] = calculateVicinity( center )
%   This method was designed to return the 9 point vicinity of any point;
%   Now it only returns the point itself
    vicinity = zeros(1,2);
    vicinity(1,:) = [center(1,1),center(1,2)];
end

