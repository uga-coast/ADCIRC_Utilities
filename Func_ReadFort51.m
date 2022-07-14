function [fort51, headerlines] = Func_ReadFort51(dataDir, numtides)
% ************************************************************************
% Func_ReadFort51 Reads fort.51 file into Matlab matrix
%
% Inputs:
%   datadir - Directory of input data
%   numtides - number of tidal constituents contained in the fort.51 file
%
% Outputs:
%   fort51 -- 1x(2*numtides+1) Cell array containing frequency (rad/s) and 
%             amplitude (m) information for each tidal constituent 
%             recording location
%             Cell 1 -- Frequency (rad/s) of each tidal constituent at node
%                       1
%             Cell 2 -- Amplitude (m) of each tidal constituent at node 1
%             Cell 3 -- Frequency (rad/s) of each tidal constituent at node
%                       2
%             Cell 2 -- Amplitude (m) of each tidal constituent at node 1
%             ...
%             Cell n
%
%   headerlines -- 1x4 cell array.
%                  Cell 1 -- Frequency (rad/s) of each tidal constituent
%                  Cell 2 -- Nodal factor of each tidal constituent
%                  Cell 3 -- Equilibrium argument (degrees) of each tidal
%                            constituent
%                  Cell 4 -- Name of Tidal Constituents
% --------------------------- Created by-----------------------------------
% Sheppard Medlin
% Coastal Ocean Analysis & Simulation Team
% University of Georgia
% Spring 2022
% Last Updated: July 13, 2022
% ************************************************************************

%Opens file - Reads headerlines into one cell array and the rest of the
%data into a seperate cell array
fid = fopen(fullfile(dataDir,'/fort.51'));
headerlines = textscan(fid, '%f %f %f %s', numtides, 'delimiter', ...
    {'\n' ' '}, 'MultipleDelimsAsOne',1,'headerlines', 1);

%Reads each tidal consitituent into its own cell
fort51 = textscan(fid, repmat('%f', 1, numtides*2+1), 'delimiter',...
    {'\n', ' '}, 'MultipleDelimsAsOne', 1, 'headerlines', 1);

fclose(fid);
end

