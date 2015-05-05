function [ params ] = initGoalParams( s1, s2, t1, t2, q)
% Initialize Goal Parameters

params(1).x = s1(1);
params(1).y = s1(2);
params(1).xd = t1(1);
params(1).yd = t1(2);
params(1).theta = 0;

params(2).x = s2(1);
params(2).y = s2(2);
params(2).xd = t2(1);
params(2).yd = t2(2);
params(2).theta = 0;

params(1).m = [];
params(2).m = [];
if(abs(params(1).x - params(2).x) <= q && abs(params(1).y - params(2).y) <= q)
    params(1).m = params(2);
    params(2).m = params(1);
else 
    params(1).m = [];
    params(2).m = [];
end

end