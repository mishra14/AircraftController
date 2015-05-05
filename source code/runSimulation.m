function [  ] = runSimulation(s1, t1, s2, t2, timeout)
% Runs the simulation until timeout
% s1: Source location of first aircraft
% t1: Target location of first aircraft
% s2: Source location of second aircraft
% t2: Target location of second aircraft
% timeout: Number of steps the simulation is run. 

% v: Velocity of aircraft
% k: Time after which the direction is updated
% q: Distance at which the messages from other aircraft are available. 
q = 2;  
k = 1;
v = 1;

% Initialize inputs to controller based source and target information
in = initGoalParams(s1, s2, t1, t2, q);

% Compute positions of aircrafts at each time step
pos1 = [];
pos2 = [];
s1 = [];
s2 = [];
for i=1:timeout
    % Compute controller outputs
    [out(1), s1] = controller(in(1), s1);
    [out(2), s2] = controller(in(2), s2);
    % Store controller outputs and aircraft state 
    pos1 = [pos1; in(1).x in(1).y in(1).theta, out(1).val];
    pos2 = [pos2; in(2).x in(2).y in(2).theta, out(2).val];
    % If both aircraft reach destination, stop
    if(in(1).x == in(1).xd && in(1).y == in(1).yd && in(2).x == in(2).xd && in(2).y == in(2).yd)
        break;
    end
    % Simulate the motion of aircraft for next k steps. 
    in = simulateStep(out, in, v, k, q);
        
end

% Plot trajectory of aircraft
for i=1:size(pos1, 1)
    plot(pos1(1:i, 1), pos1(1:i, 2), 'b+-');
    hold on;
    plot(pos2(1:i, 1), pos2(1:i, 2), 'r+-');
    plot(pos1(i, 1), pos1(i, 2), 'ok', 'MarkerSize',5,'MarkerFaceColor','k');
    plot(pos2(i, 1), pos2(i, 2), 'ok', 'MarkerSize',5,'MarkerFaceColor','k');
    plot(in(1).xd, in(1).yd, 'xb', 'MarkerSize',10,'MarkerFaceColor','b');
    plot(in(2).xd, in(2).yd, 'xr', 'MarkerSize',10,'MarkerFaceColor','r');
    hold off;
    
    % axis
    lx = min([min(pos1(:, 1)), min(pos2(:, 1)), in(1).xd, in(2).xd]) - 1;
    rx = max([max(pos1(:, 1)), max(pos2(:, 1)), in(1).xd, in(2).xd]) + 1;
    ly = min([min(pos1(:, 2)), min(pos2(:, 2)), in(1).yd, in(2).yd]) - 1;
    ry = max([max(pos1(:, 2)), max(pos2(:, 2)), in(1).yd, in(2).yd]) + 1;
    axis([lx, rx, ly, ry ])
    
    pause(.5)
end



