%% Reading in Data from Database
opts = spreadsheetImportOptions('NumVariables', 5,'VariableNames', {'Width', 'Area', 'Perimeter', 'Wshelf', 'DOC'},...
    'Sheet', 'Sheet2', 'DataRange', 'A2:E18');
opts2 = spreadsheetImportOptions('NumVariables', 3,'VariableNames', {'InletWidth', 'InletDMax', 'InletDMax'},...
    'Sheet', 'Sheet2', 'DataRange', 'F2:H15');
opts3 = spreadsheetImportOptions('NumVariables', 2,'VariableNames', {'OffshoreMin', 'OffshoreMax'},...
    'Sheet', 'Sheet2', 'DataRange', 'I2:J19');
Mdata = readmatrix('NeticaProfile1.xlsx', opts);
Mdata2 = readmatrix('NeticaProfile1.xlsx', opts2);
Mdata3 = readmatrix('NeticaProfile1.xlsx', opts3);

for i = 1:size(Mdata)
    for j = 1:5
        Mdata{i,j} = str2double(Mdata{i,j});
    end
end
for i = 1:size(Mdata2)
    for j = 1:3
        Mdata2{i,j} = str2double(Mdata2{i,j});
    end
end
for i = 1:size(Mdata3)
    for j = 1:2
        Mdata3{i,j} = str2double(Mdata3{i,j});
    end
end

Mdata = cell2mat(Mdata);
Mdata2 = cell2mat(Mdata2);
Mdata3 = cell2mat(Mdata3);
Mdata(:,1) = Mdata(:,1)./1000;
Mdata(:,2) = Mdata(:,2)./1000000;
Mdata(:,3) = Mdata(:,3)./1000;
Mdata(:,4) = Mdata(:,4)./1000;
Mdata2(:,1) = Mdata2(:,1)./1000;
Mdata3(:,1) = Mdata3(:,1)./1000;
Mdata3(:,2) = Mdata3(:,2)./1000;

%% Plotting Histograms of Database Data
figure
tiledlayout(2,2, "TileSpacing", "compact", "Padding", "tight")
set(gcf, 'Units', 'inches', 'Position', [0.25 0.25 9 9], 'color', 'w')
nexttile
set(gca, 'FontSize', 24)
histogram(Mdata(:,1),'BinWidth', 1)
xlabel('Island Width (km)')
ylabel('Count')
title('a)')
nexttile
set(gca, 'FontSize', 24)
histogram(Mdata(:, 2),'BinWidth', 20)
xlabel(['Island Area (km^{2})'])
ylabel('Count')
title('b)')
nexttile
set(gca, 'FontSize', 24)
histogram(Mdata(:, 3),'BinWidth', 20)
xlabel('Island Perimeter (km)')
ylabel('Count')
title('c)')
nexttile
set(gca, 'FontSize', 24)
histogram(Mdata(:, 4),'BinWidth', 50)
xlabel('Width of Continental Shelf (km)')
ylabel('Count')
title('d)')
saveas(gcf,'OverallBIParameters.png')

figure
tiledlayout(2,2, "TileSpacing", "compact", "Padding", "tight")
set(gcf, 'Units', 'inches', 'Position', [0.25 0.25 9 9], 'color', 'w')
nexttile
set(gca, 'FontSize', 24)
histogram(Mdata(:, 5),'BinWidth', 0.5)
xlabel('Depth of Closure (m)')
ylabel('Count')
title('a)')
nexttile
set(gca, 'FontSize', 24)
histogram(Mdata2(:, 1),'BinWidth', 1)
xlabel('Inlet Width (km)')
ylabel('Count')
yticks([0:5])
title('b)')
nexttile
set(gca, 'FontSize', 24)
histogram(Mdata2(:, 2),'BinWidth', 2)
xlabel('Max Inlet Depth (m)')
ylabel('Count')
yticks([0:3])
title('c)')
nexttile
set(gca, 'FontSize', 24)
histogram(Mdata2(:, 3),'BinWidth', 2)
xlabel('Mean Inlet Depth (m)')
ylabel('Count')
yticks([0:5])
title('d)')
saveas(gcf,'OverallBIParameters2.png')

figure
tiledlayout(1,2, "TileSpacing", "compact", "Padding", "tight")
set(gcf, 'Units', 'inches', 'Position', [0.25 0.25 9 4.5], 'color', 'w')
nexttile
set(gca, 'FontSize', 24)
histogram(Mdata3(:,1),'BinWidth', 2)
xlabel('Min Offshore Distance (km)')
ylabel('Count')
title('a)')
nexttile
set(gca, 'FontSize', 24)
histogram(Mdata3(:, 2),'BinWidth', 3)
xlabel(['Max Offshore Distance (km)'])
ylabel('Count')
yticks([0:6])
title('b)')
saveas(gcf,'OverallBIParameters3.png')