function [ flag ] = testSimulation(s1, t1, s2, t2, timeout)
% Tests the simulation until timeout
% s1: Source location of first aircraft
% t1: Target location of first aircraft
% s2: Source location of second aircraft
% t2: Target location of second aircraft
% timeout: Number of steps the simulation is run. 

% flag : true if the simulation was successful (i.e. both aircraft reach
% destination and safety is not voilated); false otherwise. 


% v: Velocity of aircraft
% k: Time after which the direction is updated
% q: Distance at which the messages from other aircraft are available. 
q = 2;  
k = 1;
v = 1;

% Initialize inputs to controller based source and target information
in = initGoalParams(s1, s2, t1, t2, q);

% Compute positions of aircrafts at each time step

s1 = [];
s2 = [];
flag = false;

for i=1:timeout
    % Check aircraft collision avoidance
    if( safetyMonitor( in(1), in(2) ) && (in(1).x ~= in(1).xd || in(1).y ~= in(1).yd) && (in(2).x ~= in(2).xd || in(2).y ~= in(2).yd))
        safety=safetyMonitor( in(1), in(2) )
        in1=in(1)
        in2=in(2)
        disp( sprintf( 'hi 2'))
        return;
    end

    % Compute controller outputs
    [out(1), s1] = controller(in(1), s1);
    [out(2), s2] = controller(in(2), s2);
    
    % If both aircraft reach destination, stop
    if(in(1).x == in(1).xd && in(1).y == in(1).yd && in(2).x == in(2).xd && in(2).y == in(2).yd)
        flag = true;
        return;
    end
    % Simulate the motion of aircraft for next k steps. 
    in = simulateStep(out, in, v, k, q);
end
disp( sprintf( 'hi 3'))
        in1=in(1)
        in2=in(2)