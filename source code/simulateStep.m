function [ res ] = simulateStep(out, in, v, k, q )
% Sends updated inputs to controller every k seconds

% in, res: Data Structure that stores input information for the aircraft
% controller. 
%       (x, y): Current Location of the aircraft
%       (xd, yd): Destination of aircraft
%       theta: Current direction of motion
%       m: Message from neighbouring aircraft

% out : Data Structure that stores the output information from the aircraft
%       val: +1, 0, -1
% 
% v: Velocity of aircraft
% k: Time after which the direction is updated
% q: Distance at which the messages from other aircraft are available. 


res = in;
for i=1:length(in)
    
    theta = wrapTo360(out(i).val*90 + in(i).theta);
    
    if(in(i).x == in(i).xd && in(i).y == in(i).yd)
        res(i).x = in(i).x;
        res(i).y = in(i).y;
    elseif(theta == 0 || theta == 360)
        res(i).x = in(i).x + k*v;
    elseif(theta == 90)
        res(i).y = in(i).y + k*v;
    elseif(theta == 180)
        res(i).x = in(i).x - k*v;
    elseif(theta == 270)
        res(i).y = in(i).y - k*v;
    end
    res(i).theta = theta;
end

% if aircrafts are close to each other then m is non-empty
res(1).m = [];
res(2).m = [];
if(abs(res(1).x - res(2).x) <= q && abs(res(1).y - res(2).y) <= q)
    res(1).m = res(2);
    res(2).m = res(1);
else 
    res(1).m = [];
    res(2).m = [];
end

