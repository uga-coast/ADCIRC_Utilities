% NetCDFtoASCII reads fort.63.nc files and saves them to fort.14 format
%% Variables
out = 1; %Set to 1 to create grid file, 0 for ascii maxele file
datadir = "C:\Users\sdm08233\Documents\Research\Experiments\Experiment1\ExtractTransects\Try2";
datadirmesh = "C:\Users\sdm08233\Documents\SMS\Semicircular Mesh\GAsemicircle\Exp1Flat";
savepath = "C:\Users\sdm08233\Documents\Research\Experiments\Experiment1\ExtractTransects\Try2";
%% Reading Data
count = 1; 
%%
for i = [1,2,4,6]
    for j = [1.5,3,4.5]
        %Simfile = "Sim.8m3segControl";
        path(count) = fullfile(datadir);%, Simfile);%, "Outputs", "maxele");
        Simulation = strcat("0Part", num2str(i), "MeterDur",num2str(j),".63.nc");
        savesim = strcat("0Part",num2str(i),"mDur", num2str(round(j)),".14");
        zetamax{count} = ncread(fullfile(path(count), Simulation), "zeta_max");
        zetamaxt{count} = ncread(fullfile(path(count), Simulation), "time_of_zeta_max");
        x{count} = ncread(fullfile(path(count), Simulation), "x");
        y{count} = ncread(fullfile(path(count), Simulation), "y");
        nbdv{count} = ncread(fullfile(path(count), Simulation), "nbdv");
        nbvv{count} = ncread(fullfile(path(count), Simulation), "nbvv");
        time{count} = ncread(fullfile(path(count), Simulation), "time");
        pathsim(count) = fullfile(savepath, savesim);
        count = count + 1;
    end
end
%%
for i = 1%[300 500 700 900 1900 2900 4900 6900]
    for j = [2,3]%,5]
        for k = [1,2,4,6]
            for l = [1.5,3,4.5]
                %Simfile = strcat("Part", num2str(i), "Dune", num2str(j));
                Simulation = strcat("Part", num2str(i), "Dune", num2str(j),num2str(k), "MeterDur", num2str(l),".63.nc");
                savesim = strcat("Part", num2str(i), "Dune", num2str(j), num2str(k),"mDur", num2str(round(l)),".14");
                path(count) = fullfile(datadir);%, Simfile);%, "Outputs", "maxele");
                zetamax{count} = ncread(fullfile(path(count), Simulation), "zeta_max");
                zetamaxt{count} = ncread(fullfile(path(count), Simulation), "time_of_zeta_max");
                x{count} = ncread(fullfile(path(count), Simulation), "x");
                y{count} = ncread(fullfile(path(count), Simulation), "y");
                nbdv{count} = ncread(fullfile(path(count), Simulation), "nbdv");
                nbvv{count} = ncread(fullfile(path(count), Simulation), "nbvv");
                time{count} = ncread(fullfile(path(count), Simulation), "time");
                pathsim(count) = fullfile(savepath, savesim);
                count = count + 1;
            end
        end
    end
end
if out == 1
    [meshstr,nnodes,nelements] = ReadFort14(datadirmesh, "8m3segControl.grd");
    countxyz = [1:length(meshstr.xyz)];
    countcnt = [1:length(meshstr.cnt)];
    topline = "semicirclepaved";
    secline = strcat(num2str(nelements),"  ", num2str(nnodes));
end
%%
if out == 0
    count = [1:length(x{1})];
    count = count.';
    topline = " 53K! 32 CHARACTER ALPHANUMERIC    ADCIRC! 24 CHARACTER AL  Experiment1";
    secline = "          2     196968  0.1000000E+001        1     1 FileFmtVersion:    1050624";
    thirdline = "     8.6400000000E+005         864000";
    
    for i = 1:length(zetamax)
        pathsim{i} = pathsim{i}(1:end-3);
        outmatrix1 = [count, zetamax{i}];
        outmatrix2 = [count, zetamaxt{i}];
        writematrix(topline,pathsim{i},'Delimiter','tab', 'FileType', 'text')
        writematrix(secline,pathsim{i},'Delimiter','tab', 'WriteMode', 'append', 'FileType', 'text')
        writematrix(thirdline,pathsim{i},'Delimiter','tab', 'WriteMode', 'append', 'FileType', 'text')
        writematrix(outmatrix1,pathsim{i},'Delimiter','tab', 'WriteMode', 'append', 'FileType', 'text')
        writematrix(outmatrix2,pathsim{i},'Delimiter','tab', 'WriteMode', 'append', 'FileType', 'text')
    end
elseif out == 1
    for i = 1:length(zetamax)
        pathsim{i} = pathsim{i}(1:end-3);
        xyz = [countxyz.', meshstr.xyz(:,1:2),zetamax{i}];
        connect = [countcnt.',repelem(3,length(countcnt)).',meshstr.cnt];
        writematrix(topline,pathsim{i},'Delimiter','tab', 'FileType', 'text')
        writematrix(secline,pathsim{i},'Delimiter','tab', 'WriteMode', 'append', 'FileType', 'text')
        writematrix(xyz,pathsim{i},'Delimiter','tab', 'WriteMode', 'append', 'FileType', 'text')
        writematrix(connect,pathsim{i},'Delimiter','tab', 'WriteMode', 'append', 'FileType', 'text')
        writematrix(meshstr.nope,pathsim{i},'Delimiter','tab', 'WriteMode', 'append', 'FileType', 'text')
        writematrix(meshstr.neta,pathsim{i},'Delimiter','tab', 'WriteMode', 'append', 'FileType', 'text')
        writematrix(meshstr.neta,pathsim{i},'Delimiter','tab', 'WriteMode', 'append', 'FileType', 'text')
        writematrix(meshstr.ob,pathsim{i},'Delimiter','tab', 'WriteMode', 'append', 'FileType', 'text')
        writematrix(meshstr.nbou,pathsim{i},'Delimiter','tab', 'WriteMode', 'append', 'FileType', 'text')
        writematrix(meshstr.nvel,pathsim{i},'Delimiter','tab', 'WriteMode', 'append', 'FileType', 'text')
        writematrix(length(meshstr.closedbou1),pathsim{i},'Delimiter','tab', 'WriteMode', 'append', 'FileType', 'text')
        writematrix(meshstr.closedbou1,pathsim{i},'Delimiter','tab', 'WriteMode', 'append', 'FileType', 'text')
        writematrix(length(meshstr.closedbou2),pathsim{i},'Delimiter','tab', 'WriteMode', 'append', 'FileType', 'text')
        writematrix(meshstr.closedbou2,pathsim{i},'Delimiter','tab', 'WriteMode', 'append', 'FileType', 'text')
        writematrix(length(meshstr.closedbou3),pathsim{i},'Delimiter','tab', 'WriteMode', 'append', 'FileType', 'text')
        writematrix(meshstr.closedbou3,pathsim{i},'Delimiter','tab', 'WriteMode', 'append', 'FileType', 'text')
    end
else
    error("Please set out equal to 0 or 1")
end