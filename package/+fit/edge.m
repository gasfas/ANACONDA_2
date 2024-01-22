function [FP, yfit_FP, Fit_info, af, FP_M] = edge(xdata, ydata, IG, fit_param)
% This function fits an edge trace for Gaussian peaks and an edge to a given x,y-data set
% Optionally, an initial guess can be given. 
% Inputs: 
% xdata:            [n, 1], the x data to fit
% ydata:            [n, 1], the corresponding PD data to fit
% IG:               (optional) Initial Guess: struct containing the optional fields:
%                   IG.mu.value     [nof_peaks, 1] The centres of the
%                                   peaks. If this field is not given, one
%                                   peak will be fitted in the data.
%                                   Default: in the middle of the x range
%                   IG.mu.isfree    [nof_peaks, 1] logical of either
%                                   'true' (fixed) or 'false' (free). 'fixed' means that
%                                   that mu-value is a fixed value, not
%                                   considered a degree of freedom in the
%                                   simulation.
%                                   Default: free
%                   IG.mu.min       Minimum value of the average of the PDF
%                   IG.mu.max       Maximum value of the average of the PDF
%                   IG.edge         The 'ionization edge' fitted with a
%                   broadened heaviside function
%                   IG.edge.function The type of function used to model the
%                                   step. 'linear' assumes a linear increase 
%                                   from the ionization energy. Default: 'linear'
%                   The same optional fields for:
%                   IG.sigma        The standard deviation.
%                   IG.PH           The relative peak height.
%                   IG.y_bgr        The y-value of a background in the data.
% fit_param         optimization fit parameters
% Outputs:
% FP                Fit parameters, struct with the fields:
%                   FP.mu.value     [nof_peaks, 1], The centres of the peaks. 
%                   FP.sigma.value  [nof_peaks, 1], The centres of the peaks. 
%                   FP.y_bgr.value  scalar, The centres of the peaks. 
%
% written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

%Check the Initial Guess parameters. If they are not defined, we create defaults:
if ~exist('IG', 'var')
    IG = struct;
end
if ~exist('fit_param', 'var')
    fit_param = struct();
end
% Complete the Initial guess and fit parameters:
[xdata, ydata, IG, fit_param, options, IG_M, UB_M, LB_M] = fit.lsq_peak.prepare_fit(xdata, ydata, IG, fit_param, 'edge');

%% Define anonymous function:
af = @(param, x)fit.runner.edge(param, xdata);

%% Fit
% First plot the initial guess:
% Hack: only edge is fitted for now.
%% Fit!
[FP_M, Fit_info.residual_norm_lsqc, Fit_info.residuals, Fit_info.exitflag, ...
Fit_info.fit_info] = lsqcurvefit(af, IG_M, xdata, ydata, LB_M, UB_M, options);

yfit_IG = af(IG_M, xdata);
yfit_FP = af(FP_M, xdata);

% visualize(for debugging):
% plot(xdata, yfit_IG, 'r'); hold on
% plot(xdata, yfit_FP, 'k'); hold on
% plot(xdata, ydata, 'g')
% legend('IG', 'fit', 'data')
% % Then continue with the peaks on top of the edge with Gaussian peak shapes:

% Extract it into a more readable format:
FP.y_bgr        = FP_M(end-2);
FP.edge         = FP_M(end-1);
FP.edge_slope   = FP_M(end);
end   