function [ numPassed, numFailed, failureLog ] = testbench( n, timeout )
% Tests the controller for  different source and destination combinations 
% on a grid of size 2*n x 2*n where, each test is run upto timeout

% n: Grid size
% timeout: Number of steps for which each simulation is run.

% numPassed: number of testcases that successfully completed 
% numFailed: number of testcases that failed 
% failureLog : the set of points where the algorithm failed. Each row
% consists of the source destination pairs (s1, t1, s2, t2)


numPassed = 0;
numFailed = 0;
failureLog = [];
q = 2; 

s1 = [0, 0];
for i=0:n
    for j=0:n
        if (i == 0 && j == 0)
            continue;
        end
            
        s2 = [i, j];
        
        for k = -n:n
            for l = -n:n
                if (k == 0 && l == 0)
                    continue;
                end        
                
                t1 = [k, l];
                
                for p = -n:n
                    for r = -n:n
                        if (p == i && r == j || (abs(p - k) <= q && abs(r - l) <= q))
                            continue;
                        end
                        t2 = [p, r];
                        
                        % run the test for points where source points are
                        % distinct and destination points are outside each
                        % others communication zone and 
                        if(testSimulation(s1, t1, s2, t2, timeout))
                            numPassed = numPassed + 1;
                        else
                            disp( sprintf( 'hi'))
                            numFailed = numFailed + 1;
                            failureLog = [failureLog; s1, t1, s2, t2];
                        end
                    end
                end
            end
        end
                
    end
end
        
        
        


end

