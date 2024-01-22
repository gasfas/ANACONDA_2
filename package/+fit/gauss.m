function [ FP, yfitdata, Fit_info, af, FP_M] = gauss(xdata, ydata, IG, fit_param)
% This function fits a Gaussian peak to a given x,y-data set
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

if ~exist('IG', 'var')
    IG = struct;
end
if ~exist('fit_param', 'var')
    fit_param = struct();
end

% Complete the Initial guess and fit parameters:
[xdata, ydata, IG, fit_param, options, IG_M, UB_M, LB_M] = fit.lsq_peak.prepare_fit(xdata, ydata, IG, fit_param, 'gauss');

%% Define anonymous function:
% There are modes the optimization can work in:
switch IG.sigma.mode
    case 'one width fits all' % We change all sigma values to one: 
        IG.sigma.value = mean(IG.sigma.value);
        IG.sigma.max   = max(IG.sigma.max);
        IG.sigma.min   = min(IG.sigma.min);
        af = @(param, x) fit.runner.gauss_one_width(param, x);
    otherwise % we assume independent widths, and we leave things as they are.
        af = @(param, x)fit.runner.gauss(param, x);
end

if size(IG.mu.value)>0
	%% Fit!
	[FP_M, ...
		Fit_info.residual_norm_lsqc, ...
		Fit_info.residuals, ...
		Fit_info.exitflag, ...
		Fit_info.fit_info] = ...
		lsqcurvefit(af , IG_M, xdata, ydata, LB_M, UB_M, options);

	% Reshape the parameter data to the more intuitive form used as input/output:
	FP = IG;
	end_idx = 0;
    subfields = fieldnames(IG);
	for i = 1:length(subfields)
		strt_idx    = end_idx+1;
		end_idx     = strt_idx + length(IG.(subfields{i}).value)-1;
		FP.(subfields{i}).value = FP_M(1, strt_idx:end_idx);
	end

	if nargout >= 2
		% The user requests yfitdata:
		yfitdata = af(FP_M, xdata); 
	end
else
% 	No data given, so no fit can be made:
	FP = IG;
	yfitdata = [];
	Fit_info =[];
end