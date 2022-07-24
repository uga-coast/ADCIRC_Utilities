function [Ht] = fort19Tide(numNodes, amplitude, simTime, tstep, angularSpeed, write)
% ************************************************************************
% fort19Tide Creates fort.19 file with only Tides
%
% Inputs:
%   numNodes        -- Number of boundary nodes to include in fort.19 file
%   amplitude       -- Peak surge amplitude (m)
%   simTime         -- Total Simulation Time (hr) 
%   tstep           -- length of timestep for the fort.19 (s)
%   angularSpeed    -- angular speed of tides (deg/hr)
%   write           -- Write output to file? 0 == no, 1 == yes
%
% Outputs:
%   Ht              -- Matrix containing WSEs for the fort.19 file.
% ************************************************************************

angularSpeed = angularSpeed*pi/180; %Rad/hr
angularSpeed = angularSpeed/3600; %Rad/sec

timeS = simTime/tstep; %Total # of timesteps for whole simulation
t = [0:tstep:(timeS*tstep)]; %Vector of input times
Ht = NaN((timeS+1)*numNodes, 1); %Creates empty matrix for forcing to be placed.

j = 1;
%Creating the sinusoidal forcing for n nodes
for i = 1:(timeS+1)
    H = amplitude*cos(angularSpeed*t(i)-pi/2);
    Ht(j:numNodes*i+1) = H;
    j = numNodes*i+2;
end

%Writing to Output File
if write == 1
    writematrix(tstep, amplitude + "MeterTide.txt")
    writematrix(Ht, amplitude + "MeterTide.txt", 'WriteMode','append')
end
end

