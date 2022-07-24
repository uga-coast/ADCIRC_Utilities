function [Ht] = fort19Surge(numNodes, dataDir, timeBefore, timeAfter, amplitude, hurcat, tstep, write, forspeed)
% ************************************************************************
% fort19Surge Creates fort.19 file with surge signal only. Filename
% generated automatically from amplitude and hurcat.
%
% Inputs:
%   numNodes        -- Number of boundary nodes to include in fort.19 file
%   dataDir         -- Save location of resulting file
%   timeBefore      -- Amount of time before peak surge to include in
%                      fort.19 file (hr)
%   timeAfter       -- Amount of time after peak surge to include in
%                      fort.19 file (hr)
%   amplitude       -- Peak surge amplitude (m)
%   hurcat          -- Category of hurricane.  Determines which constants
%                      are used in the Xu et al. (2014) equation. 
%   tstep           -- length of timestep for the fort.19 (s)
%   write           -- Write output to file? 0 == no, 1 == yes
%   forspeed        -- radius to maximum winds/hurricane forward speed (hr)
%
% Outputs:
%   Ht              -- Matrix containing WSEs for the fort.19 file.
% --------------------------- Created by-----------------------------------
% Sheppard Medlin
% Coastal Ocean Analysis & Simulation Team
% University of Georgia
% Fall 2021
% Last Updated: July 14, 2022
% ************************************************************************

sec = 3600; %Seconds in an hour
tTime = timeBefore+timeAfter; %Total Time of Simulation (in hours)
Ht = NaN((tTime*3600/tstep+1)*numNodes, 1); %Creates an empty matrix for the surge forcing to be placed
amplitude2 = amplitude;

%Checks Hurricane category, then applies proper equations for the rising
%and falling limbs of the surge forcing
j=1;
if hurcat == 3
    for i = 0:tstep:timeBefore*(sec)
        Ht(j:(j+numNodes-1),1) = amplitude*(1-exp(-abs(3/(i/sec-timeBefore))));
        j=j+numNodes;
    end
    for i = i+tstep:tstep:(tTime*sec)
        Ht(j:(j+numNodes-1),1) = amplitude*(1-.9*exp(-abs(4/(i/sec-timeBefore))));
        j=j+numNodes;
    end
elseif hurcat == 4
    for i = 0:tstep:timeBefore*(sec)
        height = amplitude*(1-1.2*exp(-abs(forspeed/(i/sec-timeBefore))));
        if height < 0 
            Ht(j:(j+numNodes-1),1) = 0;
            j=j+numNodes;
        else
            Ht(j:(j+numNodes-1),1) = height;
            j=j+numNodes;
        end
    end
    for i = i+tstep:tstep:(tTime*sec)
        height = amplitude*(1-1.2*exp(-abs(forspeed/(i/sec-timeBefore))));
        if height < 0
            Ht(j:(j+numNodes-1),1) = 0;
            j=j+numNodes;
        else
            Ht(j:(j+numNodes-1),1) = height;
            j=j+numNodes;
        end
    end
else
    error("hurricane category must be 3 or 4") 
end

if write == 1
    %Writing to output file
    writematrix(tstep, dataDir + "\" + amplitude2 + "MeterCat" + hurcat + ".txt")
    %writematrix(Ht, amplitude + "MeterCat" + hurcat + ".txt", "WriteMode","append")
    writematrix(Ht, dataDir + "\" + amplitude2 + "MeterCat" + hurcat + ".txt", "WriteMode","append")
end
end

