function [ DF, FP ] = gauss(xdata, ydata, nof_peaks)
%This function lists the defaults for a Gaussian fit simulation. Defaults
%are used when the user has not specified certain needed parameters.
% Input:
% xdata         [n, 1] The input data x
% ydata         [n, 1] The input data y
% nof_peaks     scalar, the number of peaks to be fitted
% Output:
% IG            Struct, default Initial Guesses
% FP            Struct, default Fit Parameters
%
% Shell written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% We define the Initial Guess (IG) and the Fit Parameters (FP) defaults:
if isempty(xdata)
	xdata = 0;
end
if isempty(ydata)
	ydata = 0;
end
%% Initial Guess:
% for mu:
DF.mu.value     = mean([min(xdata), max(xdata)]) * ones(nof_peaks,1);
DF.mu.isfree    = true(nof_peaks, 1);
DF.mu.min       = min(xdata) * ones(nof_peaks,1);
DF.mu.max       = max(xdata) * ones(nof_peaks,1);
% for sigma:
DF.sigma.value  = mean([min(xdata), max(xdata)])/10 * ones(nof_peaks,1);
DF.sigma.isfree = true(nof_peaks,1);
DF.sigma.min    = zeros(nof_peaks,1);
DF.sigma.max    = max(xdata) * ones(nof_peaks,1);
DF.sigma.mode   = 'one width fits all';
% for sigma:
DF.PH.value     = ones(nof_peaks,1);
DF.PH.isfree    = true(nof_peaks,1);
DF.PH.min       = zeros(nof_peaks,1);
DF.PH.max       = max(ydata) * ones(nof_peaks,1);
% for y_bgr (dy default, only the first value of y_bgr is relevant):
DF.y_bgr.value  = 0;
DF.y_bgr.isfree = true; % only the first one counts.
DF.y_bgr.min    = 0;
DF.y_bgr.max    = max(ydata);

%% Fit Parameters:
FP.names        = {'TolX',    'TolFun',   'MaxFunEvals', 'MaxIter'};
FP.defaults     = [1E-10,     1E-11,      1e5,            1e5];

end