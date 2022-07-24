% video_writer_code.m Reads fort.63 files and uses it to create a movie 
% file (.mp4, .mov, etc.)
%% Variables
framerate = 10; %framerate of movie
quality = 100; %compression level of movie from 1-100.  100 is no compression.
datadir = fullfile("C:\Users\sdm08233\Documents\Research\Experiments\Experiment1\", strcat("Sim.8m3SegControl")); %Location of fort.14 and fort.63
filename14 = "fort.14"; %Name of fort.14 file
filename63 = "fort.63.nc"; %Name of fort.63 file
simlength = 240; %Length of simulation (hr)
outputtimestep = 900; %Interval at which water levels were recorded to fort.63 (s)
%% Calculations
%Looping over different simulations.  Can remove loops to create video for
%1 simulation
for i = 1
    for j = 3
        for k =  2
            %% Read in NetCDF and Fort.14
            wse = ncread(fullfile(datadir,filename63), "zeta");
            x = ncread(fullfile(datadir,filename63), "x");
            y = ncread(fullfile(datadir,filename63), "y");

            [meshstr,nnodes,nelements]= ReadFort14(datadir, filename14);
            %% Reading in the Transect
            Transect = readmatrix(strcat(datadir, "\Transect1.txt"), 'NumHeaderLines', 2);
            Transecth = repelem(3,length(Transect)).';
            Transect = [Transect,Transecth];
            %% Calculations
            frames = simlength*3600/outputtimestep;
            t = [outputtimestep/3600:outputtimestep/3600:simlength];
            cb1h = repelem(3,length(meshstr.closedbou1));
            cb2h = repelem(3,length(meshstr.closedbou2));
            cb3h = repelem(3,length(meshstr.closedbou3));
            obh = repelem(3,length(meshstr.ob));
            %% plot WSE animation
            close all;
            clearvars F
            fk=1;
            for m=600:749
                figure(fk)
                hold on;

                %Plotting
                %trimesh( meshstr.cnt,meshstr.xyz(:,1),meshstr.xyz(:,2),[],'FaceColor',[ 1 1 1],'EdgeColor',[0 0 0])
                trisurf( meshstr.cnt,meshstr.xyz(:,1),meshstr.xyz(:,2),wse(:,m),'EdgeColor','None','FaceColor','interp')
                plot3(meshstr.xyz(meshstr.closedbou1,1),meshstr.xyz(meshstr.closedbou1,2),cb1h,'k', 'LineWidth', 1.5)
                plot3(meshstr.xyz(meshstr.closedbou2,1),meshstr.xyz(meshstr.closedbou2,2),cb2h,'k', 'LineWidth', 1.5)
                plot3(meshstr.xyz(meshstr.closedbou3,1),meshstr.xyz(meshstr.closedbou3,2),cb3h,'k', 'LineWidth', 1.5)
                plot3(meshstr.xyz(meshstr.ob,1),meshstr.xyz(meshstr.ob,2),obh,'k', 'LineWidth', 1.5)
                plot3(Transect(:,1), Transect(:,2), Transect(:,3), 'k', 'LineWidth', 1.5)
                
                view(0,90)

                %labels
                tname=sprintf('%.2f', t(m));
                tname2=[tname,'-hr'];
                title(tname2)
                xlabel('Longitude')
                ylabel('Latitude')
                set(gca,'fontsize',12);

                %axes and ticks
                axis equal
                ylim([30.6,32.1])
                xlim([-81.5,-80.25])
                xticks([-81.5,-81.25,-81,-80.75,-80.5,-80.25])
                yticks([30.75,31,31.25,31.5,31.75,32])

                %colormap
                colormap(jet)
                caxis([-1,3])
                c = colorbar('Ticks', [-1,-0.5,0,.5,1,1.5,2,2.5,3]);
                c.Label.String = 'Water Surface Elevation (m)';

                %Sizing
                set(gcf,'Units','inches','Position',[4.5 .25 9 9] ,'PaperUnits','Normalized','PaperPosition', [0 0 1 1],'color', 'white'); %[0 50 1000 800]

                hold off;

                %Saving Frame
                F(fk) = getframe(gcf) ;

                %Closing old frames to save RAM
                if rem(fk,50) == 0
                    close all
                end
                fk=fk+1;
            end
            close all;
            %% create the video writer
              writerObj = VideoWriter(strcat('Control',num2str(k),'mdur',num2str(j),'.avi'),'Motion JPEG AVI');
              writerObj.FrameRate = framerate;   % set the seconds per image
              writerObj.Quality = quality;   %quality of the animation
            % open the video writer
            open(writerObj);
            % write the frames to the video
            for m=1:length(F)
                % convert the image to a frame
                frame = F(m) ;    
                writeVideo(writerObj, frame);
            end
            % close the writer object
            close(writerObj);
        end
    end
end