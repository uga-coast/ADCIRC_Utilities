% gridGenerator creates a simple sloping beach profile to interpolate to
% fort.14 file.  It can accept up to 2 different slopes for depths < and > 
%the depth of closure.
%% Variables
width = 160000; %long-shore domain length
length = 80000; %cross-shore domain length
dx = 100; %long-shore cell length
dy = 100; % cross-shore cell length
DOC = 1; %Depth of Closure
DOCSlope = .0001; %Slope from land to Depth of Closure
OSSlope  = .0001; %Slope from DOC offshore

%negative values are land.  Positive are underwater.  StartDepth is land
%boundary, endDepth is ocean boundary
startDepth = 0;
endDepth = 8;

%% Calculations
% Calculating total elevation change
depthDifference = abs(startDepth - endDepth)/(length/dy);

%Preallocating
x = linspace(0,width,round(width/dx)+1);
y = linspace(0,length,round(length/dy)+1);
z = zeros(round(length/dy)+1, round(width/dx)+1);

zi = 0;
%Assigning elevations to each x,y,z point
for i = y./dy+1
    if zi <= DOC
        for j = x./dx+1
            z(i,j) = startDepth + (i-1)*DOCSlope*dy;
            zi = z(i,1);
        end
    else
        for j = x./dx+1
            z(i,j) = DOC + (i-1)*OSSlope*dy;
            zi = z(i,1);
        end
    end
end
   
z = flipud(z);

[xx,yy] = meshgrid(x,y);
X = xx(:);
Y = yy(:);
Z = z(:);
P = [X, Y, Z];

contour(z)
%% Saving
fid = fopen('PlaneSlopeSS.xyz', 'wt');
fprintf(fid, [repmat('%.f\t', 1, size(P,2)-1) '%f\n'], P.');
fclose(fid);