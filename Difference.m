function wsediff = Difference(datadir1, datadir2)
% ************************************************************************
% Difference finds the difference in WSE between two maxele.63.nc files
%
% Inputs:
%   datadir1 - Directory of first maxele file
%   filename - Directory of second maxele file 
%
% Outputs:
%   wsediff -- Matrix of (first maxele) - (2nd maxele)
% --------------------------- Created by-----------------------------------
% Sheppard Medlin
% Coastal Ocean Analysis & Simulation Team
% University of Georgia
% Spring 2022
% Last Updated: July 14, 2022
% ************************************************************************
%Importing first maxele
wsenew = ncread(fullfile(datadir1,"maxele.63.nc"), "zeta_max");
%Importing second maxele
wseold = ncread(fullfile(datadir2,"maxele.63.nc"), "zeta_max");
%Finding the difference
wsediff = wsenew-wseold;
