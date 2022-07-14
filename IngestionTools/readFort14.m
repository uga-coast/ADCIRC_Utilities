% function to read a fort.14 file a arrange the mesh data into desired
% matrix
% Outputs:
%   meshstr -- mesh structure
%          meshstr.name      -- Grid Name  (singe value)
%          meshstr.size      -- Number of elemenents and nodes in  Grid
%                               (two values)
%          meshstr.xyz       -- xyz coordinates of each node 
%                               (three column matrix)
%          meshstr.cnt       -- Element connectivity table: nodes ID that 
%                               encompass each element(three column matrix)
%          meshstr.nope      -- Number of open ocean boundaries
%          meshstr.neta      -- Number of open boundary nodes
%          meshstr.ob        -- List of open boundary nodes
%          meshstr.nbou      -- Number of land/zero normal flow boundaries
%          meshstr.nvel      -- Number of land zero normal flow boundary
%                               nodes
%          meshstr.cb{num}   -- List of nodes for each mainland boundary
%​
%                      
% --------------------------- Created by-----------------------------------
% Felix Santiago-Collazo, Ph.D., P.E.
% Institute for Resilient Infrastructure Systems
% Coastal Ocean Analysis & Simulation Team
% University of Georgia
% Fall 2021
% --------------------------- Modified by----------------------------------
% Sheppard Medlin
% Coastal Ocean Analysis & Simulation Team
% University of Georgia
% Last Updated: July 13, 2022
% ************************************************************************
 function [meshstr,nnodes,nelements]=readFort14(datadir, filename, landval)
%% read fort.14
% Open the mesh file
fid=fopen(fullfile(datadir,filename),'r');
% alpha-numeric grid name (<=24 characters)
meshstr.name= fgetl(fid);  

% elemenents and nodes in  Grid
dtmp = fgetl(fid);
meshstr.size = sscanf(dtmp,'%g');  
nnodes= meshstr.size(2);
nelements= meshstr.size(1);
ntotal = nnodes + nelements;

%matrix of xyz coordinates for each node 
for i=1:nnodes
   meshstr.xyz (i,1:4) = fscanf(fid,'%g\n',4);
end
meshstr.xyz (:,1)=[]; %remove node id column

%convert land elevation to positive if landval == 1
if landval == 1
    meshstr.xyz (:,3)=meshstr.xyz (:,3)*-1;
end

%element connectivity table 
for i=1:nelements
   meshstr.cnt (i,1:5) = fscanf(fid,'%g\n',5);
end
meshstr.cnt (:,1:2)=[]; %remove node id colum
dtmp = fgetl(fid);

meshstr.nope = sscanf(dtmp, '%g'); %Get number of open boundaries
dtmp = fgetl(fid);
meshstr.neta = sscanf(dtmp, '%g'); %Get number of elevation specified boundary nodes

%Creates list of node numbers along the open boundary
for i = 1:meshstr.nope
    fgetl(fid);
    for j = 1:meshstr.neta
        meshstr.ob(j,1) = fscanf(fid, '%g\n',1);
    end
end
dtmp = fgetl(fid);

meshstr.nbou = sscanf(dtmp, '%g'); %Get number of land boundaries
dtmp = fgetl(fid);
meshstr.nvel = sscanf(dtmp, '%g'); %Get number of land boundary nodes

%Creates list of node numbers along each mainland boundary
count = [];
for k = 1:meshstr.nbou
    dtmp = sscanf(fgetl(fid), '%g');
    count = [count,k];
    meshstr.(strcat('cb',num2str(count(end)))) = dtmp(1);
    for l = 1:meshstr.(strcat('cb',num2str(count(end))))
        meshstr.(strcat('cb',num2str(count(end))))(l,1) = fscanf(fid, '%g\n',1);
    end
end
    

end
