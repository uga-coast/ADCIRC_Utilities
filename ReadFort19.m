function [fort19,tsteps] = ReadFort19(datadir, filename, numnodes, simtimeS)
% ************************************************************************
% ReadFort19 Reads fort.19 file into Matlab matrix
%
% Inputs:
%   datadir - Directory of input data
%   filename - name of file to be read
%   numnodes - Number of elevation specified boundary nodes
%   simtimeS - Total simulation time in seconds
%
% Outputs:
%   fort19 -- Cell array, where each cell is a timeseries of water levels
%             at a specific boundary node. Boundary nodes are read in order
%             from the fort.19 file
%   tsteps -- number of timesteps in fort.19
% --------------------------- Created by-----------------------------------
% Sheppard Medlin
% Coastal Ocean Analysis & Simulation Team
% University of Georgia
% Fall 2021
% Last Updated: July 13, 2022
% ************************************************************************
%importing fort.61 file
%   Detailed explanation goes here

fid = fopen(fullfile(datadir, filename)); %File path and name
linenum = 1; %Number of header lines to remove

%Imports the dt between forcing times
tstep = cell2mat(textscan(fid, '%f', 1, 'delimiter', '\n', 'MultipleDelimsAsOne',1));
%Imports all elevation data contained in fort.19 file
fort19 = textscan(fid,repmat('%f', 1, numnodes), 'delimiter', '\n', 'MultipleDelimsAsOne', 1, 'headerlines', linenum); 

%Finds number of timesteps
tsteps = simtimeS/tstep;

fclose(fid);
end

