function [ DF, FP ] = QE1(xdata, ydata, nof_BRs)
%This function lists the defaults for a QE model fit simulation. Defaults
%are used when the user has not specified certain needed parameters.
% Input:
% xdata         [n, 1] The input data x
% ydata         [n, 1] The input data y
% nof_peaks     scalar, the number of peaks to be fitted
% Output:
% IG            Struct, default Initial Guesses
% FP            Struct, default Fit Parameters

% We define the Initial Guess (IG) and the Fit Parameters (FP) defaults:

%% Initial Guess:
% for mu:
DF.BR.value     = mean(ydata) * ones(nof_BRs,1);
DF.BR.isfree    = true(nof_BRs, 1);
DF.BR.min       = zeros(nof_BRs,1);
DF.BR.max       = 1e5*max(ydata) * ones(nof_BRs,1);


%% Fit Parameters:

FP.names        = {'TolX',    'TolFun',   'MaxFunEvals', 'MaxIter'};
FP.defaults     = [1E-10,     1E-11,      1e5,            1e5];

end


