function [A] = readFort61(datadir,numrecsta)
% ************************************************************************
% readFort61 - Imports fort.61 data into cell array
% Inputs:
%   datadir - Directory of input data
%   numrecsta - Number of recording stations in the input fort.61 file
% Outputs:
%   A -- Output Station Cell Array
% --------------------------- Created by-----------------------------------
% Sheppard Medlin
% Coastal Ocean Analysis & Simulation Team
% University of Georgia
% Fall 2021
% Last Updated: July 13, 2022
% ************************************************************************
%importing fort.61 file
fid = fopen(fullfile(datadir,'\fort.61'));
linenum = 4;
fort61 = textscan(fid,'%f %f','delimiter',' ', 'MultipleDelimsAsOne',1,'headerlines',linenum-1);

%Preallocating cell array
A = cell(1,numrecsta);

%converts fort.61 into cell array where each cell is a recording station
for i = 1:numrecsta
    index = fort61{1,1}(:) == i;
    A{i} = fort61{1,2}(index);
end
end

