clear
clc
close all
%% What to Generate?
%The following are Booleans. 0 to skip, 1 to generate.
Tides = 0; %fort.19 file with sinusoidal tides ONLY
Surge = 0; %fort.19 file with hurricane storm surge ONLY
SurgeTide = 1; %fort.19 file with tides and storm surge 
write = 1; %Write Output to File
plotout = 1; %Generate plots of outputs
%% Variables
dataDir  = 'C:\Users\sdm08233\Documents\MATLAB\ADCIRC_Utilities\Data'; %Directory of fort.19 file
numNodes = 643; %Number of input nodes
numNodesOut = 517; %Number of Nodes in fort.19
simTime = 240; %Simulation Time in hours

simTimeS = simTime*3600;

%[fort19, tsteps] = ReadFort19(dataDir, numNodes, simTimeS);
%[fort51, headerLines] = Func_ReadFort51(dataDir, numTides);

%% Tides
amplitude = 1; %Tidal amplitude in meters
angularSpeed = 28.9841; %Deg/hr
tstep = 300; %Timestep in seconds

if Tides == 1
    [Ht] = fort19Tide(numNodes, amplitude, simTimeS, tstep, angularSpeed, write);
end
%% Surge
timeBefore = 72; %Forcing duration before landfall (hours)
timeAfter = 72; %Forcing duration after landfall (hours)
amplitude = 1; %Surge amplitude (meters)
hurcat = 3; %Hurricane category (must be cat 3 or 4)
tstep = 300; %Timestep (seconds)

if Surge == 1
    [Ht] = fort19Surge(numNodes, timeBefore, timeAfter, amplitude, hurcat, tstep, write);
end
%% Tides + Surge
timeBefore = 164+(2/3); %Storm Forcing duration before landfall (hours)
timeAfter = 75+(1/3); %Storm Forcing duration after landfall (hours)
amplitude = [1,2,4,6]; %Surge amplitude (meters)
forspeed = [1.5,3,4.5];
hurcat = 4; %Hurricane category (must be cat 3 or 4)
tstep = 300; %Timestep (seconds)
numTides = 23; %Number of Tidal Constituents
count = 1;
if SurgeTide == 1
    for i = 1:length(forspeed)
        for j = 1:length(amplitude)
            [TideAmp{count}, NormAmp{count}] = fort19SurgeTide(dataDir, numTides, simTimeS, numNodes, numNodesOut, timeBefore, timeAfter, amplitude(j), hurcat, tstep, write, forspeed(i));
            count = count+1;
        end
    end
end
%% Plotting
if plotout == 1
    ff1 = ('1mSurgeTide');
    plottime = [1641:2311];
    idx = [259:numNodesOut:(simTimeS/tstep)*numNodesOut + (numNodesOut)];
    tseries = [0:tstep/3600:simTimeS/3600];
    tseries = tseries.' + 300/3600;
    
    tiledlayout(1,4,"Padding", "none", "TileSpacing", "compact")
    nexttile([1,1])
    hold on
    ax = gca;
    ax.FontSize = 24;
    ax.DataAspectRatio = [6 1 1];
    xlim('tight')
    xlabel("Time (hrs)")
    ylabel("Amplitude (m)")
    title("8 Hour")
    set(gcf, "Color", "None")
    elevations = TideAmp{1}(idx);
    elevations2 = TideAmp{2}(idx);
    elevations3 = TideAmp{3}(idx);
    elevations4 = TideAmp{4}(idx);
    plot(tseries(plottime), elevations(plottime), "LineWidth",1.5)
    plot(tseries(plottime), elevations2(plottime), "LineWidth",1.5)
    plot(tseries(plottime), elevations3(plottime), "LineWidth",1.5)
    plot(tseries(plottime), elevations4(plottime), "LineWidth",1.5)

    nexttile([1,1])
    hold on
    elevations5 = TideAmp{5}(idx);
    elevations6 = TideAmp{6}(idx);
    elevations7 = TideAmp{7}(idx);
    elevations8 = TideAmp{8}(idx);
    plot(tseries(plottime), elevations5(plottime), "LineWidth",1.5)
    plot(tseries(plottime), elevations6(plottime), "LineWidth",1.5)
    plot(tseries(plottime), elevations7(plottime), "LineWidth",1.5)
    plot(tseries(plottime), elevations8(plottime), "LineWidth",1.5)
    ax = gca;
    ax.FontSize = 24;
    ax.DataAspectRatio = [6 1 1];
    xlim('tight')
    xlabel("Time (hrs)")
    ylabel("Amplitude (m)")
    title("12 Hour")
    
    nexttile([1,1])
    hold on
    elevations9 = TideAmp{9}(idx);
    elevations10 = TideAmp{10}(idx);
    elevations11 = TideAmp{11}(idx);
    elevations12 = TideAmp{12}(idx);
    plot(tseries(plottime), elevations9(plottime), "LineWidth",1.5)
    plot(tseries(plottime), elevations10(plottime), "LineWidth",1.5)
    plot(tseries(plottime), elevations11(plottime), "LineWidth",1.5)
    plot(tseries(plottime), elevations12(plottime), "LineWidth",1.5)
    ax = gca;
    ax.FontSize = 24;
    ax.DataAspectRatio = [6 1 1];
    xlim('tight')
    xlabel("Time (hrs)")
    ylabel("Amplitude (m)")
    title("24 Hour")
    lgd = legend("1m Magnitude", "2m Magnitude", "4m Magnitude", "6m Magnitude", "Location", "west","FontSize",24);
    lgd.Layout.Tile = 4;
    
    set(gcf, "Color", "None")
    ff1 = ('JournalForcing');
    fname=fullfile(dataDir, ff1);
    print('-dpng','-r600', fname);
end