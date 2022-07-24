function [fitresult, gof] = Func_createFit(xx, yy,method)

%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( xx, yy );

% Set up fittype and options.

if(method ==1)
    ft = fittype( 'exp2' );
elseif(method==2)
    ft = fittype( 'power2');
elseif(method==3)
    ft = fittype( 'poly3' );
end
% excludedPoints = excludedata( xData, yData, 'Indices', 20 );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
% opts.StartPoint = [-28.4585106360831 -1.14297670970425 63.6992166302832 -1.65820511826779];
% opts.Exclude = excludedPoints;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
save('fitresult3m4m','fitresult')
eq = formula(fitresult); %Formula of fitted equation
        parameters = coeffnames(fitresult); %All the parameter names
        values = coeffvalues(fitresult); %All the parameter values
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

% % Plot fit with data.
 figure;
 h = plot( fitresult, xData, yData, 'predobs' );
 grid on
 legend( h, 'attenuation vs. predictor', '$77.8265*x^{0.59261}-21.4811$', 'Lower bounds (95%)', 'Upper bounds (95%)', 'Location', 'NorthEast', 'Interpreter', 'latex' );
 % Label axes
 xlabel( 'predictor', 'Interpreter', 'none' );
 ylabel( 'attenuation (%)', 'Interpreter', 'none' );
 set(gca,'FontSize', 24)



