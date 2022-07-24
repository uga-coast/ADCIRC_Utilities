function objec = objec_fun(logfile_loc,island_ratio,h_dune,a_sur,T_sur,atten,method,fac)

expon1 = fac(1); 
expon2 = fac(2);
expon3 = fac(3);
%expon4 = fac(4);
%expon5 = fac(5);
save('expons', 'expon1', 'expon2', 'expon3')
%(DuneHeight/SurgeAmplitude)^exponent1
numer       = (h_dune./a_sur).^expon1;
%(IslandRatio^(exponent2)/SurgePeriod^(exponent3))
denom       = island_ratio.^expon2.*T_sur.^expon3;

xx          = numer./denom;

[~, gof1] = Func_createFit(xx,atten,method);

rsq1   = gof1.rsquare;

objec = (1.0 - rsq1).^2;

logf = strcat('log_file_',num2str(method),'.txt');
logfname = fullfile(logfile_loc,logf);
f_log = fopen(logfname,'a+');
fprintf(f_log,'%2.10f \t %2.10f \t %2.10f \t %2.10f \n',fac,rsq1);
fclose(f_log);

end