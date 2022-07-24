%% Deprecated Section
%clc
%clear
%data = readcell("C:\Users\sdm08233\Documents\ArcGIS\16CNT04_morphology.csv");
%dataedit = cell2mat(data(2:end, 1:11));
%index = find(dataedit(:,4) == 999);
%data(index+1, :) = []; 
%data(:,13:14) = [];
%cHeader = {'state' 'segment' 'profile' 'lon' 'lat' 'x' 'z' 'x_err' 'z_err' 'beach_width' 'slope' 'feature_type'};
%writecell(data, "C:\Users\sdm08233\Documents\ArcGIS\EC.csv")
%%
clear
clc

%Loading in Julia Mulhern data and assigning USGS data for reading
stats = cell(5,2);
load('CoastMorph_Dbase_v37.mat')
myfilename = {'Total'}; % 'MiAl', 'Fl2015', 'GA', 'NC', 'GC', 'EastCoast', 'Blackbeard',...
    %'Cape_Lookout', 'Cat_Island', 'Cumberland','Dauphin_Island',...
    %'East_Ship_Island', 'Fl2015_Dog', 'Fl2015_LilStGeorge','Fl2015_Perdido',...
    %'Fl2015_SantaRosa', 'Fl2015_StGeorge', 'Fl2015_StVincent',...
    %'Horn_Island', 'LilStSimons', 'Ossabaw', 'Petit_Bois_Island', 'Portsmouth',...
    %'Sapelo', 'Shackleford_Banks', 'StCatherines', 'Wassaw', 'West_Ship_Island'};

for i = 1
    %% Parsing Dune Crest Data
    clf
    
    %Creating the filename
    filename = fullfile('C:\', 'Users', 'sdm08233', 'Documents', 'ArcGIS',...
        myfilename{i});
    
    %pulling the file and creating a matrix where all 999 values become NaN
    dauphin = readcell(filename);
    dauphinmat = cell2mat(dauphin(2:end, 1:12));
    dauphinmat(dauphinmat == 999) = NaN;

    %Indexing all the lines for Dune Crest measurements
    DCindex = find(strcmp(dauphin(:,end), "DC"));
    DCindex = DCindex - 1;
    %Pulling transect, segment, and state values along with Dune crest
    %height, location and x,y error
    DC = dauphinmat(DCindex, [2:4,7:10]);
    %Creating a new column that has state, segment, and transect combined
    %into one easily comparable number
    newDCcol = [DC(:,1)*10000000+DC(:,2)*10000+DC(:,3)];
    DC = [DC, newDCcol];
    DC(isnan(DC(:,5)), :) = [];
    %Creating Distribution and checking fit
    pddc = fitdist(DC(:,5), 'Kernel');
    hdc = chi2gof(DC(:,5), 'CDF', pddc);
    %Creating Dune Crest statistics
    DCavg = nanmean(DC(:,5));
    DCquantile = quantile(DC(:,5),[.25, .5, .75]);
    DCmin = min(DC(:,5));
    DCmax = max(DC(:,5));
    DCxerr = nanmean(DC(:,6));
    DCyerr = nanmean(DC(:,7));
    DCstd = std(DC(:,5));
%% Plotting Dune Crest Data
    %Getting equation info to plot in legend
    eq = formula(fitresult{(i-1)*3+j}); %Formula of fitted equation
    parameters = coeffnames(fitresult{(i-1)*3+j}); %All the parameter names
    values = coeffvalues(fitresult{(i-1)*3+j}); %All the parameter values
    for idx = 1:numel(parameters)
        param = parameters{idx};
        l = length(param);
        loc = regexp(eq, param); %Location of the parameter within the string
        while ~isempty(loc)     
            %Substitute parameter value
            eq = [eq(1:loc-1) num2str(values(idx)) eq(loc+l:end)];
            loc = regexp(eq, param);
        end
    end

    %plotting
    figure(1)
    tiledlayout(2,2, "TileSpacing", "compact", "Padding", "tight");
    set(gcf, 'Units', 'inches', 'Position', [0.25 0.25 16 9], 'color', 'w');
    nexttile
    hold on
    ax = gca;
    ax.FontSize = 18;
    title("a)")
    histogram(DC(:,5), 'Normalization', 'pdf', 'BinWidth', .2);
    plot([0:.1:10], pdf(pddc,[0:.1:10]), 'LineWidth',2)
    %xline(2, 'LineWidth', 2)
    xlabel("Dune Crest Height (m)")
    ylabel("Probability Density")
    ylim([0, .5])
    %legend('Data', 'Estimated Distribution')
    %saveas(gcf, append(cell2mat(myfilename(i)), 'DC.png')); 
    hold off
    %clf
%% Parsing Dune Toe Data
    %Indexing all the lines for Dune Toe measurements    
    DTindex = find(strcmp(dauphin(:,end), "DT"));
    DTindex = DTindex -1;
    %Pulling Dune toe height and y error
    DT = dauphinmat(DTindex, [2:4, 8,10]);
    newDTcol = [DT(:,1)*10000000+DT(:,2)*10000+DT(:,3)];
    DT = [DT, newDTcol];
    DT(isnan(DT(:,4)), :) = [];
    %Creating Distribution
    pddt = fitdist(DT(:,4), 'Kernel');
    hdt = chi2gof(DT(:,4), 'CDF', pddt);
    %Creating Dune Crest statistics
    DTavg = nanmean(DT(:,4));
    DTquantile = quantile(DT(:,4),[.25, .5, .75]);
    DTmin = min(DT(:,4));
    DTmax = max(DT(:,4));
    DTyerr = nanmean(DT(:,5));
    DTstd = std(DT(:,4));
%% Plotting Dune Toe Data
    %plotting
    %figure(2)
    nexttile;
    hold on
    ax = gca;
    ax.FontSize = 18;
    histogram(DT(:,4), 'Normalization', 'pdf', 'BinWidth', .2);
    plot([0:.01:10], pdf(pddt,[0:.01:10]), 'LineWidth',2)
    title("b)")
    xlabel("Dune Toe Height (m)")
    ylabel("Probability Density")
    ylim([0, 1])
    legend('Data', 'Estimated Distribution')
    %saveas(gcf, append(cell2mat(myfilename(i)), 'DT.png'));
    hold off
    %clf
%% Parsing Beach Width Data
    %Indexing all the lines for Beach Width measurements 
    BWindex = find(strcmp(dauphin(:,end), "SL"));
    BWindex = BWindex - 1;
    %Pulling Beach Width, x, and y error of shoreline
    BW = dauphinmat(BWindex, [2:4, 9:11]);
    newBWcol = [BW(:,1)*10000000+BW(:,2)*10000+BW(:,3)];
    BW = [BW, newBWcol];
    BW(isnan(BW(:,6)), :) = [];
    %Creating Distribution
    pdbw = fitdist(BW(:,6), 'Kernel');
    hbw = chi2gof(BW(:,6), 'CDF', pdbw);
    %Creating Beach Width statistics
    BWavg = nanmean(BW(:,6));
    BWquantile = quantile(BW(:,6),[.25, .5, .75]);
    BWmin = min(BW(:,6));
    BWmax = max(BW(:,6));
    BWstd = std(BW(:, 6));
%% Plotting Beach Width Data
    %plotting
    %figure(3)
    nexttile;
    hold on
    ax = gca;
    ax.FontSize = 18;
    histogram(BW(:,6), 'Normalization', 'pdf', 'BinWidth', 5);
    plot([0:1:500], pdf(pdbw,[0:1:500]), 'LineWidth',2)
    title("c)")
    xlabel("Beach width (m)")
    ylabel("Probability Density")
    xlim([0, 500])
    %legend('Data', 'Estimated Distribution')
    %saveas(gcf, append(cell2mat(myfilename(i)), 'BW.png'));
    hold off
    %clf
%% Parsing Shoreline Data
    %Pulling Shoreline location, x error, y error, and
    %state/segment/transect
    SL = dauphinmat(BWindex, [2:4, 7:9, 11]);
    SLindex = find(SL(:,7) == 0);
    SL(SLindex, :) = [];
    SL(isnan(SL(:,3)), :) = [];
    %Creating a new column that has state, segment, and transect combined
    %into one easily comparable number
    newSLcol = [SL(:,1)*10000000+SL(:,2)*10000+SL(:,3)];
    SL = [SL, newSLcol];
    %computing average x error for shoreline location
    SLxerravg = nanmean(SL(:,6));
%% Parsing Slope Data
    %pulling slope data
    slope = dauphinmat(BWindex, [2:4, 7:9, 12]);
    slopeindex = find(slope(:,7) == 0);
    slope(slopeindex, :) = [];
    slope(isnan(slope(:,7)), :) = [];
    %Creating a new column that has state, segment, and transect combined
    %into one easily comparable number
    newslopecol = [slope(:,1)*10000000+slope(:,2)*10000+slope(:,3)];
    slope = [slope, newslopecol];
    %creating distribution and checking fit
    pdsl = fitdist(slope(:,7), 'Kernel');
    hsl = chi2gof(slope(:,7), 'CDF', pdsl);
    %Slope statistics
    slopeavg = nanmean(slope(:,7));
    slopequantile = quantile(slope(:,7),[.25, .5, .75]);
    slopemin = min(slope(:,7));
    slopemax = max(slope(:,7));
    slopestd = std(slope(:,7));
    
    %computing Beach width error
    [C1, ia1, ib1] = intersect(BW(:,7), slope(:,8), 'stable');
    BWxerr = slope(ib1,5);
    BW = [BW, NaN(length(BW), 1)];
    BW(ia1,8) = BWxerr; 
    BWxerravg = nanmean(BWxerr);
    
    %Computing slope vertical error
    [C2, ia2, ib2] = intersect(DT(:,6), slope(:,8), 'stable');
    slopeyerr = DT(ia2,5);
    slope = [slope, NaN(length(slope), 3)];
    slope(ib2, 10) = slopeyerr;
    slope(ib2, 9) = DT(ia2, 4) - slope(ib2, 5);
    
    %Computing slope total error
    [C3, ia3, ib3] = intersect(slope(ib2,8), BW(ia1, 7), 'stable');
    slopetotalerr = sqrt((slope(ia3, 10).^2)./(slope(ia3, 9).^2) + (BW(ib3, 8).^2)./(BW(ib3, 6).^2));
    slope(ia3, 11) = slopetotalerr;
    slopeavgerr = nanmean(slope(ia3, 11));
%% Plotting Slope
    %Plotting
    %figure(4)
    nexttile;
    hold on
    ax = gca;
    ax.FontSize = 18;
    histogram(slope(:,7), 'Normalization', 'pdf', 'BinWidth', .005);
    plot([0:.001:.2], pdf(pdsl,[0:.001:.2]), 'LineWidth',2)
    title("d)")
    xlabel("Slope (m/m)")
    ylabel("Probability Density")
    xlim([0, .25])
    %legend('Data', 'Estimated Distribution')
    saveas(gcf, append(cell2mat(myfilename(i)), 'USGSDataDist.png'));
    hold off
    %clf
%% Calculating Distance to Vegetation
    %Finding indices of common shorline and Dune crest transects
    [C4, ia4, ib4] = intersect(DC(:,8), SL(:,8), 'stable');
    %Calculatiing distance from shoreline to vegetation on a transect by
    %transect basis
    Lveg = DC(ia4, 4) - SL(ib4, 4);
    Lveg = abs(Lveg);
    Lveg = [Lveg, DC(ia4, 8)];
    %Calculating Lveg error
    Lvegxerr = SL(ib4,6);
    %Lveg statistics
    LVavg = nanmean(Lveg(:,1));
    LVquantile = quantile(Lveg(:,1),[.25, .5, .75]);
    LVmin = min(Lveg(:,1));
    LVmax = max(Lveg(:,1));
    LVxerr = nanmean(Lvegxerr);
    LVstd = std(Lveg(:,1));
%% Plotting Beach Width vs. Slope
    figure
    hold on
    fit = polyfit(slope(ia1, 6), BW(ia1, 6), 1);
    yfit = polyval(fit, slope(ia1, 6));
    scatter(slope(ia1, 6), BW(ia1, 6), 1, 'k', 'filled')
    plot(slope(ia1, 6), yfit, 'r-')
    title("Beach Width vs Beach Slope")
    xlabel("Beach Width (m)")
    ylabel("Beach Slope (m)")
    xlim([0, 480])
    ylim([0, .25])
    legend('Data', 'Linear Fit')
    saveas(gcf, append(cell2mat(myfilename(i)), 'BWvsSlope.png'));
    hold off
    %clf
%% Plotting Distance to Vegetation Vs. Dune Crest
    figure
    hold on
    [fit, S] = polyfit(Lveg(:,1), DC(ia4, 5), 1);
    [yfit, delta] = polyval(fit, Lveg(:,1), S);
    scatter(Lveg(:,1), DC(ia4, 5), 1, 'k', 'filled')
    %plot(Lveg(:,1), yfit, 'r-')
    plot(Lveg(:,1), yfit+2*delta, 'c-', Lveg(:,1), yfit-2*delta, 'c-')
    title("Dune Crest Height vs Distance to Vegetation")
    xlabel("Distance to Vegetation (m)")
    ylabel("Dune Crest Height (m)")
    xlim([0, 480])
    ylim([0, 14])
    legend('Data', 'Linear Fit', '95% Prediction Interval')
    saveas(gcf, append(cell2mat(myfilename(i)), 'DCLveg.png'));
    hold off
    %clf
%% Further organizing parsed data
    DCwrite = {'DC', [DCmin, DCquantile, DCmax, DCavg, DCstd, DCyerr]};
    DTwrite = {'DT', [DTmin, DTquantile, DTmax, DTavg, DTstd, DTyerr]};
    BWwrite = {'BW', [BWmin, BWquantile, BWmax, BWavg, BWstd, BWxerravg]};
    slopewrite = {'Slope', [slopemin, slopequantile, slopemax, slopeavg, slopestd, slopeavgerr]};
    Lvegwrite = {'Lveg', [LVmin, LVquantile, LVmax, LVavg, LVstd, LVxerr]};
    stats(i*6-5:i*6,:) = [[myfilename(i),cell(1,1)]; DCwrite; DTwrite; BWwrite; slopewrite; Lvegwrite];
end
% writing output
%writecell(stats, 'totalstatistics.csv')
%% Parsing data by Island for excel spreadsheet
% This section was used to create NeticaProfile.xlsx
for i = 1:length(M)
    closure = (M(i).mean_wave_height + 5.6*M(i).std_wave_height)*1.57;
    M(i).depth_of_closure = closure;
end

ID = [dauphinmat(:,2)*10000000+dauphinmat(:,3)*10000+dauphinmat(:,4)];
ID = unique(ID);
bay = NaN(length(ID),12);
bay(:,1) = ID;
[C15, ia5, ib5] = intersect(bay(:,1), DC(:,8), 'stable');
bay(ia5,2) = DC(ib5, 5);
[C15, ia5, ib5] = intersect(bay(:,1), DT(:,6), 'stable');
bay(ia5,3) = DT(ib5, 4);
[C15, ia5, ib5] = intersect(bay(:,1), BW(:,7), 'stable');
bay(ia5,4) = BW(ib5, 6);
[C15, ia5, ib5] = intersect(bay(:,1), slope(:,8), 'stable');
bay(ia5,5) = slope(ib5, 7);
[C15, ia5, ib5] = intersect(bay(:,1), Lveg(:,2), 'stable');
bay(ia5,6) = Lveg(ib5,1);

%Cat Island
bay(bay(:,1) < 40040129,7) = M(998).perimeter;
bay(bay(:,1) < 40040129,8) = M(998).interp_length;
bay(bay(:,1) < 40040129,9) = mean(M(998).interp_width);
bay(bay(:,1) < 40040129,10) = M(998).area;
bay(bay(:,1) < 40040129,11) = M(998).wshelf;
bay(bay(:,1) < 40040129,12) = M(998).depth_of_closure;
%Ship Island
bay(bay(:,1) > 40040129 & bay(:,1) < 40120424,7) = M(1001).perimeter;
bay(bay(:,1) > 40040129 & bay(:,1) < 40120424,8) = M(1001).interp_length;
bay(bay(:,1) > 40040129 & bay(:,1) < 40120424,9) = mean(M(1001).interp_width);
bay(bay(:,1) > 40040129 & bay(:,1) < 40120424,10) = M(1001).area;
bay(bay(:,1) > 40040129 & bay(:,1) < 40120424,11) = M(1001).wshelf;
bay(bay(:,1) > 40040129 & bay(:,1) < 40120424,12) = M(1001).depth_of_closure;
%Horn Island
bay(bay(:,1) > 40120424 & bay(:,1) < 40200127,7) = M(993).perimeter;
bay(bay(:,1) > 40120424 & bay(:,1) < 40200127,8) = M(993).interp_length;
bay(bay(:,1) > 40120424 & bay(:,1) < 40200127,9) = mean(M(993).interp_width);
bay(bay(:,1) > 40120424 & bay(:,1) < 40200127,10) = M(993).area;
bay(bay(:,1) > 40120424 & bay(:,1) < 40200127,11) = M(993).wshelf;
bay(bay(:,1) > 40120424 & bay(:,1) < 40200127,12) = M(993).depth_of_closure;
%Petit Bois Island
bay(bay(:,1) > 40220131 & bay(:,1) < 40270220,7) = M(994).perimeter;
bay(bay(:,1) > 40220131 & bay(:,1) < 40270220,8) = M(994).interp_length;
bay(bay(:,1) > 40220131 & bay(:,1) < 40270220,9) = mean(M(994).interp_width);
bay(bay(:,1) > 40220131 & bay(:,1) < 40270220,10) = M(994).area;
bay(bay(:,1) > 40220131 & bay(:,1) < 40270220,11) = M(994).wshelf;
bay(bay(:,1) > 40220131 & bay(:,1) < 40270220,12) = M(994).depth_of_closure;
%Dauphin Island
bay(bay(:,1) > 50010158 & bay(:,1) < 50160287,7) = M(968).perimeter;
bay(bay(:,1) > 50010158 & bay(:,1) < 50160287,8) = M(968).interp_length;
bay(bay(:,1) > 50010158 & bay(:,1) < 50160287,9) = mean(M(968).interp_width);
bay(bay(:,1) > 50010158 & bay(:,1) < 50160287,10) = M(968).area;
bay(bay(:,1) > 50010158 & bay(:,1) < 50160287,11) = M(968).wshelf;
bay(bay(:,1) > 50010158 & bay(:,1) < 50160287,12) = M(968).depth_of_closure;
%Santa Rosa
bay(bay(:,1) > 60030035 & bay(:,1) < 60081096,7) = M(966).perimeter;
bay(bay(:,1) > 60030035 & bay(:,1) < 60081096,8) = M(966).interp_length;
bay(bay(:,1) > 60030035 & bay(:,1) < 60081096,9) = mean(M(966).interp_width);
bay(bay(:,1) > 60030035 & bay(:,1) < 60081096,10) = M(966).area;
bay(bay(:,1) > 60030035 & bay(:,1) < 60081096,11) = M(966).wshelf;
bay(bay(:,1) > 60030035 & bay(:,1) < 60081096,12) = M(966).depth_of_closure;
%Perdido Key
bay(bay(:,1) > 60010939 & bay(:,1) < 60020944,7) = M(963).perimeter;
bay(bay(:,1) > 60010939 & bay(:,1) < 60020944,8) = M(963).interp_length;
bay(bay(:,1) > 60010939 & bay(:,1) < 60020944,9) = mean(M(963).interp_width);
bay(bay(:,1) > 60010939 & bay(:,1) < 60020944,10) = M(963).area;
bay(bay(:,1) > 60010939 & bay(:,1) < 60020944,11) = M(963).wshelf;
bay(bay(:,1) > 60010939 & bay(:,1) < 60020944,12) = M(963).depth_of_closure;
%St Vincent
bay(bay(:,1) > 60450015 & bay(:,1) < 60480359,7) = M(987).perimeter;
bay(bay(:,1) > 60450015 & bay(:,1) < 60480359,8) = M(987).interp_length;
bay(bay(:,1) > 60450015 & bay(:,1) < 60480359,9) = mean(M(987).interp_width);
bay(bay(:,1) > 60450015 & bay(:,1) < 60480359,10) = M(987).area;
bay(bay(:,1) > 60450015 & bay(:,1) < 60480359,11) = M(987).wshelf;
bay(bay(:,1) > 60450015 & bay(:,1) < 60480359,12) = M(987).depth_of_closure;
%St George & lil st george
bay(bay(:,1) > 60490037 & bay(:,1) < 60581058,7) = M(986).perimeter;
bay(bay(:,1) > 60490037 & bay(:,1) < 60581058,8) = M(986).interp_length;
bay(bay(:,1) > 60490037 & bay(:,1) < 60581058,9) = mean(M(986).interp_width);
bay(bay(:,1) > 60490037 & bay(:,1) < 60581058,10) = M(986).area;
bay(bay(:,1) > 60490037 & bay(:,1) < 60581058,11) = M(986).wshelf;
bay(bay(:,1) > 60490037 & bay(:,1) < 60581058,12) = M(986).depth_of_closure;
%Dog Island
bay(bay(:,1) > 60600057 & bay(:,1) < 60620241,7) = M(1004).perimeter;
bay(bay(:,1) > 60600057 & bay(:,1) < 60620241,8) = M(1004).interp_length;
bay(bay(:,1) > 60600057 & bay(:,1) < 60620241,9) = mean(M(1004).interp_width);
bay(bay(:,1) > 60600057 & bay(:,1) < 60620241,10) = M(1004).area;
bay(bay(:,1) > 60600057 & bay(:,1) < 60620241,11) = M(1004).wshelf;
bay(bay(:,1) > 60600057 & bay(:,1) < 60620241,12) = M(1004).depth_of_closure;
%Cumberland Island
bay(bay(:,1) > 90010042 & bay(:,1) < 90100215,7) = M(777).perimeter;
bay(bay(:,1) > 90010042 & bay(:,1) < 90100215,8) = M(777).interp_length;
bay(bay(:,1) > 90010042 & bay(:,1) < 90100215,9) = mean(M(777).interp_width);
bay(bay(:,1) > 90010042 & bay(:,1) < 90100215,10) = M(777).area;
bay(bay(:,1) > 90010042 & bay(:,1) < 90100215,11) = M(777).wshelf;
bay(bay(:,1) > 90010042 & bay(:,1) < 90100215,12) = M(777).depth_of_closure;
%Lil St Simons - No Data
%Sapelo Island - No Data
% St Catherines Island
bay(bay(:,1) > 90610124 & bay(:,1) < 90690165,7) = M(842).perimeter;
bay(bay(:,1) > 90610124 & bay(:,1) < 90690165,8) = M(842).interp_length;
bay(bay(:,1) > 90610124 & bay(:,1) < 90690165,9) = mean(M(842).interp_width);
bay(bay(:,1) > 90610124 & bay(:,1) < 90690165,10) = M(842).area;
bay(bay(:,1) > 90610124 & bay(:,1) < 90690165,11) = M(842).wshelf;
bay(bay(:,1) > 90610124 & bay(:,1) < 90690165,12) = M(842).depth_of_closure;
%Ossabaw
bay(bay(:,1) > 90710121 & bay(:,1) < 90750162,7) = M(844).perimeter;
bay(bay(:,1) > 90710121 & bay(:,1) < 90750162,8) = M(844).interp_length;
bay(bay(:,1) > 90710121 & bay(:,1) < 90750162,9) = mean(M(844).interp_width);
bay(bay(:,1) > 90710121 & bay(:,1) < 90750162,10) = M(844).area;
bay(bay(:,1) > 90710121 & bay(:,1) < 90750162,11) = M(844).wshelf;
bay(bay(:,1) > 90710121 & bay(:,1) < 90750162,12) = M(844).depth_of_closure;
%Wassaw
bay(bay(:,1) > 90770165 & bay(:,1) < 90780085,7) = M(840).perimeter;
bay(bay(:,1) > 90770165 & bay(:,1) < 90780085,8) = M(840).interp_length;
bay(bay(:,1) > 90770165 & bay(:,1) < 90780085,9) = mean(M(840).interp_width);
bay(bay(:,1) > 90770165 & bay(:,1) < 90780085,10) = M(840).area;
bay(bay(:,1) > 90770165 & bay(:,1) < 90780085,11) = M(840).wshelf;
bay(bay(:,1) > 90770165 & bay(:,1) < 90780085,12) = M(840).depth_of_closure;
%Shackleford Banks
bay(bay(:,1) > 110100140 & bay(:,1) < 110101264,7) = M(650).perimeter;
bay(bay(:,1) > 110100140 & bay(:,1) < 110101264,8) = M(650).interp_length;
bay(bay(:,1) > 110100140 & bay(:,1) < 110101264,9) = mean(M(650).interp_width);
bay(bay(:,1) > 110100140 & bay(:,1) < 110101264,10) = M(650).area;
bay(bay(:,1) > 110100140 & bay(:,1) < 110101264,11) = M(650).wshelf;
bay(bay(:,1) > 110100140 & bay(:,1) < 110101264,12) = M(650).depth_of_closure;
%Cape Lookout
bay(bay(:,1) > 110101263 & bay(:,1) < 110143318,7) = M(648).perimeter;
bay(bay(:,1) > 110101263 & bay(:,1) < 110143318,8) = M(648).interp_length;
bay(bay(:,1) > 110101263 & bay(:,1) < 110143318,9) = mean(M(648).interp_width);
bay(bay(:,1) > 110101263 & bay(:,1) < 110143318,10) = M(648).area;
bay(bay(:,1) > 110101263 & bay(:,1) < 110143318,11) = M(648).wshelf;
bay(bay(:,1) > 110101263 & bay(:,1) < 110143318,12) = M(648).depth_of_closure;
%Portsmouth Island
bay(bay(:,1) > 110143410 & bay(:,1) < 110153406,7) = M(637).perimeter;
bay(bay(:,1) > 110143410 & bay(:,1) < 110153406,8) = M(637).interp_length;
bay(bay(:,1) > 110143410 & bay(:,1) < 110153406,9) = mean(M(637).interp_width);
bay(bay(:,1) > 110143410 & bay(:,1) < 110153406,10) = M(637).area;
bay(bay(:,1) > 110143410 & bay(:,1) < 110153406,11) = M(637).wshelf;
bay(bay(:,1) > 110143410 & bay(:,1) < 110153406,12) = M(637).depth_of_closure;
writematrix(bay, 'NeticaProfile.xlsx')

%% Saving data to NeticaProfile1.xlsx
NeticaProfile = readcell('NeticaProfile1.xlsx');
NeticaMat = cell2mat(NeticaProfile(2:end, 1:end));
scatter(NeticaMat(:,12), NeticaMat(:,14))
meanwidth = mean([mean(M(637).interp_width), mean(M(648).interp_width), ...
    mean(M(650).interp_width), mean(M(840).interp_width), ...
    mean(M(844).interp_width), mean(M(842).interp_width), mean(M(777).interp_width), ...
    mean(M(1004).interp_width), mean(M(986).interp_width), mean(M(987).interp_width), ...
    mean(M(963).interp_width), mean(M(966).interp_width), mean(M(968).interp_width), ...
    mean(M(1001).interp_width), mean(M(994).interp_width), mean(M(993).interp_width)]);