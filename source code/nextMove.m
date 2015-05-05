function [ outFinal, nearDestFlag ] = nextMove( xcurr,ycurr,xdst,ydst,theta )
%   Detailed explanation goes here
    mode=0;
    % Chooses the best possible order for preferences of turning left, right and forward
    if(xdst>xcurr && ydst > ycurr)
        if (theta==0)
            mode = 0;         %LFR
        else
            mode =1;
        end
    elseif(xdst<xcurr && ydst > ycurr)
        if (theta==90)
            mode =0;
        else
            mode =1;
        end
    elseif(xdst<xcurr && ydst < ycurr)
        if (theta==180)
            mode =0;
        else
            mode =1;
        end
    elseif(xdst>xcurr && ydst < ycurr)
        if (theta==270)
            mode =0;
        else
            mode =1;
        end
    end
    nearDestFlag=0; %Flag to give preference to the aircraft that is 1 unit away from the destination
    distancePoints = [xdst,ydst;xcurr,ycurr];
    currentDistance = pdist(distancePoints,'euclidean');
    out = zeros(4,1);
    points = zeros(4,2);
    % Calculates the next coordinates based on the theta and current coordinates
    if( ~(currentDistance == 0))
        if( theta == 0 || theta == 360)
            xf = 1;
            yf = 0;
            xr = 0;
            yr = -1;
            xl = 0;
            yl = 1;
            xb = -1;
            yb = 0;
        elseif(theta == 90)
            xf = 0;
            yf = 1;
            xr = 1;
            yr = 0;
            xl = -1;
            yl = 0;
            xb = 0;
            yb = -1;
        elseif(theta == 180)
            xf = -1;
            yf = 0;
            xr = 0;
            yr = 1;
            xl = 0;
            yl = -1;
            xb = +1;
            yb = 0;
        elseif(theta == 270)
            xf = 0;
            yf = -1;
            xr = -1;
            yr = 0;
            xl = 1;
            yl = 0;
            xb = 0;
            yb = +1;
        end
        %Calculating step distance from current position to the destination
        currentDistanceF = abs(xdst-(xcurr+xf))+abs(ydst-(ycurr+yf));
        currentDistanceL = abs(xdst-(xcurr+xl))+abs(ydst-(ycurr+yl));
        currentDistanceR = abs(xdst-(xcurr+xr))+abs(ydst-(ycurr+yr));
        currentDistanceB = abs(xdst-(xcurr+xb))+abs(ydst-(ycurr+yb));
        %Calculating euclidean distance from current position to the destination
        eDistanceF = pdist([xdst,ydst;(xcurr+xf),(ycurr+yf)],'euclidean');
        eDistanceL = pdist([xdst,ydst;(xcurr+xl),(ycurr+yl)],'euclidean');
        eDistanceR = pdist([xdst,ydst;(xcurr+xr),(ycurr+yr)],'euclidean');
        eDistanceB = pdist([xdst,ydst;(xcurr+xb),(ycurr+yb)],'euclidean');
        
        if(mode==0)
            A = [currentDistanceL,currentDistanceF,currentDistanceR, currentDistanceB;eDistanceL,eDistanceF,eDistanceR, eDistanceB; 1,0,-1,3];
        else
            A = [currentDistanceR,currentDistanceF,currentDistanceL,currentDistanceB ;eDistanceR,eDistanceF,eDistanceL,eDistanceB; -1,0,1,3];
        end
        ASorted = A;
        %Sorting the distances to find the minimum possible distance and if step distances are equal then we check for euclidean distances
        for i=1:3
            for j=(i+1):4
                if ( ASorted(1,i) > ASorted(1,j)||( ASorted(1,i) == ASorted(1,j) && ASorted(2,i) > ASorted(2,j)))
                    temp=ASorted(1,j);
                    ASorted(1,j)=ASorted(1,i);
                    ASorted(1,i) = temp;
                    temp=ASorted(2,j);
                    ASorted(2,j)=ASorted(2,i);
                    ASorted(2,i) = temp;
                    temp=ASorted(3,j);
                    ASorted(3,j)=ASorted(3,i);
                    ASorted(3,i) = temp;
                end
            end
        end
        if((abs(xdst-xcurr)+abs(ydst-ycurr))==1)
            nearDestFlag=1;
        end
        %Assigning coordinates based on the preferences and also Assigning out value
        for i=1:4
            if ( ASorted(3,i) == -1)
                out(i) = -1;
                points(i,1) = xcurr+xr;
                points(i,2) = ycurr+yr;
            elseif ( ASorted(3,i) == 1)
                out(i) = +1;
                points(i,1) = xcurr+xl;
                points(i,2) = ycurr+yl;
            elseif ( ASorted(3,i) == 0)
                out(i) = 0;
                points(i,1) = xcurr+xf;
                points(i,2) = ycurr+yf;
            elseif ( ASorted(3,i) == 3)
                out(i) = 3;
                points(i,1) = xcurr+xb;
                points(i,2) = ycurr+yb;
            end
        end
        outFinal = horzcat(out,points);
        for i=1:4
            if (out(i,1)==3)
                %check left and right; take the one that is free
                %find i such that selfout(i,1) == 1 or -1; then check vicinity or collision
                leftIndex=find(outFinal(:,1)==1);
                rightIndex=find(outFinal(:,1)==-1);
                if(leftIndex(1)<rightIndex(1))
                    outFinal(i,2)=+1;
                    outFinal(i,3)=-1;
                else
                    outFinal(i,2)=-1;
                    outFinal(i,3)=+1;
                end
            end
        end
        
    else
        out = [2;2;2;2];
        points = [xdst,ydst;xdst,ydst;xdst,ydst;xdst,ydst];
        outFinal = horzcat(out,points);
    end
    
end

