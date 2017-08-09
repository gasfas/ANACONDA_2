function [ FP, yfitdata, Fit_info] = gauss(xdata, ydata, IG, fit_param)
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
% opt_param         optimization parameters
% Outputs:
% FP                Fit parameters, struct with the fields:
%                   FP.mu.value     [nof_peaks, 1], The centres of the peaks. 
%                   FP.sigma.value  [nof_peaks, 1], The centres of the peaks. 
%                   FP.y_bgr.value  scalar, The centres of the peaks. 

% Make sure xdata and ydata are given in the right form:
if size(xdata,2) > 1
    xdata = transpose(xdata);
end
if size(ydata,2) > 1
    ydata = transpose(ydata);
end
if ~isempty(xdata) && ~isempty(ydata)

	%% Filling missing IG field with defaults
	%Check the Initial Guess parameters. If they are not defined, we create defaults:
	if ~exist('IG', 'var')
		IG = struct;
	end

	% The number of peaks to fit is defined by the number of given mu's:
	nof_peaks = length(general.struct.probe_field(IG, 'mu.value'));

	% Define all defaults (DF):
	[DF, DF_fit_param] = fit.defaults.gauss(xdata, ydata, nof_peaks);

	% and overwrite it with IG, for the fields given:
	IG = general.struct.modify_struct(DF, IG);

	% We do the same for the fit parameters:
	% Optimization settings
	options = optimset();
	if ~exist('fit_param', 'var')
		fit_param = struct();
	end

	% The Fit parameter defaults:
	for i =1:length(DF_fit_param.names)
		fit_param_name      = DF_fit_param.names{i};
		fit_param_default   = DF_fit_param.defaults(i);
		if isfield(fit_param, fit_param_name)
		   options = optimset(options, fit_param_name,         fit_param.(fit_param_name));
		else
		   options = optimset(options, fit_param_name,         fit_param_default);
		end
	end

	%% Fixating the non-free parameters
	% if the parameter is fixed, the min and max are set equal to the initial guess.
	% For the subfields:
	subfields = {'mu', 'sigma', 'PH', 'y_bgr'};
	for i = 1:length(subfields)
		% Fetch the fixed/free logical:
		isfree_cur = general.struct.getsubfield(IG, [subfields{i} '.isfree']);
		% set the min and max equal to the set value, for those that are not free:
		IG.(subfields{i}).min(~isfree_cur) = IG.(subfields{i}).value(~isfree_cur);
		IG.(subfields{i}).max(~isfree_cur) = IG.(subfields{i}).value(~isfree_cur);
	end

	%% Reforming the parameter storage form
	% so that the optimization function can work with it:
	% We have to reform the struct to a matrix for the Initial guess(IG), the 
	% Lower Boundary (UB) and the Upper boundary (UB) 

	% There are several modes the optimization can work in:
	switch IG.sigma.mode
		case 'one width fits all' % We change all sigma values to one: 
			IG.sigma.value = mean(IG.sigma.value);
			IG.sigma.max   = max(IG.sigma.max);
			IG.sigma.min   = min(IG.sigma.min);
			af = @(param, x) fit.runner.gauss_one_width(param, x);
		otherwise % we assume independent widths, and we leave things as they are.
			af = @(param, x)fit.runner.gauss(param, x);
	end

	IG_M = []; UB_M = []; LB_M = [];
	end_idx = 0;
	for i = 1:length(subfields)
		strt_idx    = end_idx+1;
		end_idx     = strt_idx + length(IG.(subfields{i}).value)-1;
		IG_M(1, strt_idx:end_idx) = IG.(subfields{i}).value;
		LB_M(1, strt_idx:end_idx) = IG.(subfields{i}).min;
		UB_M(1, strt_idx:end_idx) = IG.(subfields{i}).max;
	end

	%% Initiating the fitting

	% plot(xdata, ydata, 'b')
	% IG_fit = af(IG_M, xdata); plot(xdata, IG_fit, 'k-')
	% LB_fit = af(LB_M, xdata); plot(xdata, LB_fit, 'k--') 
	% UB_fit = af(UB_M, xdata); plot(xdata, UB_fit, 'k-.')

	% Fit!
	[FP_M, ...
		Fit_info.residual_norm_lsqc, ...
		Fit_info.residuals, ...
		Fit_info.exitflag, ...
		Fit_info.fit_info] = ...
		lsqcurvefit(af , IG_M, xdata, ydata, LB_M, UB_M, options);

	% Reshape the parameter data to the more intuitive form used as input/output:
	FP = IG;
	end_idx = 0;
	for i = 1:length(subfields)
		strt_idx    = end_idx+1;
		end_idx     = strt_idx + length(IG.(subfields{i}).value)-1;
		FP.(subfields{i}).value = FP_M(1, strt_idx:end_idx);
	end

	if nargout >= 2
		% The user requests yfitdata:
		yfitdata = af(FP.value, xdata); % plot(xdata, yfitdata, 'r')
	end
else
% 	No data given, so no fit can be made:
	FP = IG;
	yfitdata = [];
	Fit_info =[];
end