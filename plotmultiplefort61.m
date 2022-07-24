clf
%% Variables
dataDir = 'C:\Users\sdm08233\Documents\Research\ADCIRC\Experiment1\Partition1\';
Dir61 = 'C:\Users\sdm08233\Documents\Research\Experiments\Experiment1';
Matrix61 = {'0Partition', '1Partition', '2Partition', '3Partition', '4Partition', '5Partition', '7Partition'};
tstep = 300;
filename = 'fort.19';
numNodes = 643;
simTime = 240;
simTimeS = 240*3600;
%% Plotting Water levels over time for different sims
%Reading fort.19
[fort19,tsteps] = ReadFort19(dataDir,filename,numNodes,simTime);
hold on
%Creating timeseries for different sims. To be used as x values in plots.
tseries = [0:tstep/3600:simTimeS/3600];
tseries2 = [900/3600:900/3600:simTimeS/3600];
tseries3 = [900/3600:900/3600:461700/3600];
tseries4 = [900/3600:900/3600:459900/3600];
tseries5 = [900/3600:900/3600:458100/3600];
tseries = tseries.' + 300/3600;
%plot(tseries, fort19{300})
% Reading in the fort.61 files
for i = 1:7
    Dir = fullfile(Dir61, Matrix61{i});
    A{i} = readFort61(Dir);
    
    %elevations = TideAmp(idx);
    %if i == 2 || i == 3
     %   plot(tseries3, A{i}{25})
    %elseif i == 4
     %   plot(tseries4, A{i}{25})
    %elseif i == 5 || i ==6 || i == 7
     %   plot(tseries5, A{i}{25})
    %else
end
%Plotting WSE vs. Time for the different simulations
plot(tseries2, A{1}{21},"LineWidth",1)
plot(tseries2, A{2}{21}, "LineWidth",1)
plot(tseries2, A{3}{21}, "LineWidth",.5)
plot(tseries2, A{4}{21}, "LineWidth",.5)
plot(tseries2, A{5}{21}, "LineWidth",.5)
plot(tseries2, A{6}{21}, "LineWidth",.5)
plot(tseries2, A{7}{21}, "LineWidth",.5)
    %end

    %set(gcf, "Color", "None")
    %ff1 = ('1mSurgeTide');
    %fname=fullfile(dataDir, ff1);
    %print('-dpng','-r300', fname);
%end

xlabel("Time (hrs)")
ylabel("Amplitude (m)")
legend("Null Scenario", "No Inlets", "1 Inlet", "2 Inlets", "3 Inlets", "4 Inlets", "6 Inlets")
title("Response Over Time")
xlim([125,145])
ylim([0,1.5])
yticks([0:.1:1.5])
hold off