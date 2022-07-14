% ************************************************************************
% fort19Playback Creates movie depicting WSE along boundary nodes over
% specified period of time. Requires fort.19 file
% --------------------------- Created by-----------------------------------
% Sheppard Medlin
% Coastal Ocean Analysis & Simulation Team
% University of Georgia
% Spring 2022
% Last Updated: July 13, 2022
% ************************************************************************
%% Variables
dataDir = "C:/Users/sdm08233/Documents/MATLAB/ADCIRC_Utilities/Data"; %Directory of fort.19 file
filename = "6MeterDur1.5.txt";  %Name of fort.19 file
numNodes = 517;                 %Number of nodes in fort.19
simTime = 240;                  %Simulation time in hours
fstart = 1860;                  %Frame to start the movie
fstop = 2120;                   %Frame to stop the movie
tstep = 300;                    %Length of timestep in seconds
xlims = [1 (numnodes - 1)];     %x limits
ylims = [-1 7];                 %y limits
dispmov = 0;                    %View the movie on screen? 0 - no, 1 - yes    
loops = 2;                      %Number of times to loop on-screen movie
fps = 12;                       %Frames per second for playback (default 12)
savemov = 1;                    %Save the movie? 0 - no, 1 - yes
saveloc = "C:/Users/sdm08233/Documents/MATLAB"; %Save Directory
savename = "myvid";             %Filename for movie
vidformat = "MPEG-4";            %Format to save file. Options: 'Archival', 
                                %'Motion JPEG 2000','Motion JPEG AVI', 
                                %'MPEG-4','Uncompressed AVI', 
                                %'Indexed AVI','Grayscale AVI' 
%% Calculations
%Reading in fort.19 file
[fort19,tsteps] = ReadFort19(dataDir,filename, numNodes,simTime);
fort192 = zeros(simTime*3600/tstep, numNodes); %Preallocating

%Converting fort 19 file from cell array to matrix
for i = 1:numNodes
    for j = 1:(simTime*3600/tstep)
        fort192(j, i) = fort19{i}(j);
    end
end

x = [1:(numNodes-1)];%Creating x values for plot
F(fstop-fstart+1) = struct('cdata',[],'colormap',[]); %Preallocating

%Opens file to save movie
if savemov == 1
    v = VideoWriter(fullfile(saveloc, savename), vidformat);
    open(v)
end

%Plotting WSE at each boundary node. 1 frame == 1 timestep
for i = fstart:fstop
    plot(x, fort192(i,1:(numNodes - 1)))
    ylim(ylims);
    xlim(xlims);
    time = (i*tstep/3600);
    title(num2str(time));
    drawnow
    F(i-fstart+1) = getframe(gcf);
    
    %Saving resulting movie
    if savemov == 1
        writeVideo(fullfile(saveloc, savename), F(i-fstart+1))
    end
end

%Displaying resulting movie
if dispmov == 1
    fig = figure;
    movie(fig, F, loops, fps)
end

