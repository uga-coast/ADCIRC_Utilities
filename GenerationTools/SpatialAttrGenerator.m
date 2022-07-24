%% Generates fort.13 files
Agrid = 'fort.13File'; %Top line of file, just a name
fid = fopen('C:\Users\sdm08233\Documents\Research\ADCIRC\Experiment1\Partition1\7Day\fort.14'); %Name of fort.14 file for simulation
AttrVal = 200;

%Extracting the number of Nodes in the file
linenum = 2;
C = textscan(fid,'%f',2,'delimiter',' ', 'MultipleDelimsAsOne',1,'headerlines',linenum-1);
D = textscan(fid,'%f %f %f %f','delimiter',' ', 'MultipleDelimsAsOne',1,'headerlines',1);

numNodes = C{1,1}(2);
index = find(D{1,3}(1:numNodes) <= 5000);
lines = NaN(length(index),2);
lines(:,1) = index;
lines(:,2) = AttrVal;

fclose(fid);

Nattr = 2; %Number of attributes to specify in fort.13 file
AttrName = 'primitive_weighting_in_continuity_equation'; %Name of attribute to be specified
Units = 'n'; %Units of the attribute
ValsPerNode = 1;
DefaultAttrVal = .03;

%Saving to file
writematrix(Agrid, "fort.txt")
writematrix(numNodes, "fort.txt", 'WriteMode', 'append')
writematrix(Nattr, "fort.txt", 'WriteMode', 'append')
writematrix(AttrName, "fort.txt", 'WriteMode', 'append')
writematrix(Units, "fort.txt", 'WriteMode', 'append')
writematrix(ValsPerNode, "fort.txt", 'WriteMode', 'append')
writematrix(DefaultAttrVal, "fort.txt", 'WriteMode', 'append')
writematrix(AttrName, "fort.txt", 'WriteMode', 'append')
writematrix(length(index), "fort.txt", 'WriteMode', 'append')
writematrix(lines, "fort.txt", 'WriteMode', 'append', 'Delimiter', ' ')



