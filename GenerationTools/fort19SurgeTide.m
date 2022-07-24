function SurgeTide = fort19SurgeTide(dataDir, numTides, simTimeS, numNodes, numNodesOut, timeBefore, timeAfter, amplitude, hurcat, tstep, write,forspeed)
% ************************************************************************
% fort19SurgeTide Creates fort.19 file with Surge and Tidal signal. 
% Requires fort19Surge.m. Tidal amplitude and frequency information is
% gathered from existing fort.51 file.  Surge is generated using
% fort19Surge.m and superimposed onto constructed tidal signal.
%
% Inputs:
%   numNodes        -- Number of boundary nodes in the fort.51 file
%   numNodesOut     -- Number of nodes to be in the fort.19 file
%   dataDir         -- Save location of resulting file
%   numTides        -- Number of tidal constituents in the fort.51 file
%                   -- used to get tidal information (default 23)
%   simTimeS        -- Total length of fort.19 file (s)
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
%   SurgeTide       -- Matrix containing WSEs for the fort.19 file.
% --------------------------- Created by-----------------------------------
% Sheppard Medlin
% Coastal Ocean Analysis & Simulation Team
% University of Georgia
% Fall 2021
% Last Updated: July 14, 2022
% ************************************************************************

%Calling functions to read in fort.51 data and create storm surge data
writeSurge = 1;
[fort51, headerLines] = Func_ReadFort51(dataDir, numTides); % Reading fort.51
%Calling fort19Surge to generate surge signal
[Ht] = fort19Surge(numNodes, dataDir, timeBefore, timeAfter, amplitude,...
    hurcat, tstep, writeSurge,forspeed);

%Opening Storm Surge Data
fid = fopen(fullfile(dataDir,amplitude + "MeterCat" + hurcat + ".txt"));
linenum = 2;
fort19 = textscan(fid,repmat('%f',1,numNodes),'delimiter','\n',...
    'MultipleDelimsAsOne',1,'headerlines',linenum-1);
fort19 = fort19(64:580);

%Finding speed of M2 tides
M2idx = find(strcmp(headerLines{4},'M2'));
omega = headerLines{1}(M2idx); %Speed of wave (rad/s)

time = [0:tstep:simTimeS]; %Creating time array
time = time.';
TideAmp = cell(1,numNodesOut); %Preallocating Cell Array

%Checks to to see if surge length is the same time as simulation length
if length(fort19{1}) < length(time)
    %If surge time < simlength, then beginning of Surge matrix is padded
    %with zeroes to make it the same length as the tidal matrix
    padding = length(time) - length(fort19{1});
    paddingz = zeros(padding, 1);
    for i = 1:numNodesOut
        fort19{i} = [paddingz;fort19{i}];
    end
    %Throws error is surge time > simlength
elseif length(fort19{1}) > length(time)
    error("Error: Surge duration is longer than total simulation duration. Please adjust timeBefore, timeAfter, or simTime.")
end
    
%Creating Forcing at every node
NormAmp = NaN(1,numNodesOut); %Preallocating
for i = 64:numNodesOut+63
    TideAmp{i-63} = fort51{M2idx*2}(i)*sin(omega*time); %Creating the Tidal forcing
    NormAmp = fort51{M2idx*2}(i)/max(fort51{M2idx*2}); %Finding scalar value for surge forcing at each node
    TideAmp{i-63} = TideAmp{i-63}(1:length(fort19{i-63}))*NormAmp + ...
        (fort19{i-63}); %Adding scaled surge value to Tidal Amplitude
end

%Converting Cell Array into matrix and writing to text file
if write == 1
    tideAmp2 = NaN(numNodesOut*(length(time)), 1);
    for i = 1:length(time)
        for j = 1:numNodesOut
            tideAmp2((i-1)*numNodesOut + j) = TideAmp{j}(i);
        end
    end
    %Writing to file
    writematrix(tstep, fullfile(dataDir,amplitude + "MeterDur" + ...
        forspeed + ".txt"))
    writematrix(tideAmp2, fullfile(dataDir,amplitude + "MeterDur" + ...
        forspeed + ".txt"), 'WriteMode', 'Append')
end

