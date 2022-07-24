clear;clc;close all
%% Rearranging % Reduc values into row vector
%importing existing variables
load('csvars.mat')
%Island Ratio (km/km)
a = xplotr;
%Storm Duration (hr)
b = [8,12,24];
%Dune Height (m)
c = [2.07 3.29 4.51];
%Storm magnitude (m)
d = [1,2,4,6];

count = 1;
count4 = 1;
for i = 1:length(b)
    for j = 1:length(d)
        count2 = 1;
        for k = 1:length(c)
            count3 = 0;
            for l = 1:length(a)
                count3 = count3+1;
                yy(count4) = reducpercent.(strcat('forcing',num2str((j-1)*3 + i),'Dune',num2str(count2)))(count3);
                count4 = count4+1;
            end
            count2 = count2+1;
        end
        count = count +1;
    end
end
%% Assigning variables
%Island Ratio (km/km)
a = xplotr;
%Storm Duration (hr)
b = [8,12,24];
%Dune Height (m)
c = [2.07 3.29 4.51];
%Storm magnitude (m)
d = [1,2,4,6];
%Finds total number of simulations and repeats each vector accordingly
simnums = length(a)*length(b)*length(c)*length(d);
a = repmat(a,1,simnums/length(a)); 
b = repelem(b,1,45);
b = repmat(b,1,4);
c = repelem(c,1,15);
c = repmat(c,1,12);
d = repelem(d,1,simnums/length(d));

%% Setting Options and Starting Optimization Process
%Location of logfile
logfile_loc = 'C:\Users\sdm08233\Documents\MATLAB';

%Guesses for coefficient values
fac0 = [.352 .518 1.280];
% Minimum increment size
TF   = 0.000000001;
options = optimset('TolFun',TF,'MaxIter',400);
method  = 2;

objec= objec_fun(logfile_loc,a,c,d,b,yy,method,fac0);%[facuaout,fval,exitflag] = fminsearch(@(fac)objec_fun(logfile_loc,a1,c1,d1,b1,yy,method,fac),fac0,options);

%% Plotting Final Curve

numer       = (c./d).^facuaout(1);
denom       = a.^facuaout(2).*b.^facuaout(3);
xx          = numer./denom;

figure
hold on
plot(xx,yy,'o')





