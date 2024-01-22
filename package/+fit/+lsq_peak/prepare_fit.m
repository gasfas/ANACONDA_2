function [xdata, ydata, IG, fit_param, options, IG_M, UB_M, LB_M] = prepare_fit(xdata, ydata, IG, fit_param, fit_type)
% This function prepares the fitting configuration data before a fit using
% the 'gauss' or 'edge' fitting file.
% Inputs:
% IG:               Initial Guess: struct containing the optional fields:
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
% fit_type          type of fit, either 'gauss' or 'edge'
% Outputs:
% IG:               Completed, made ready for optimization
% fit_param         Completed, made ready for optimization

% Make sure xdata and ydata are given in the right form:
if size(xdata,2) > 1
    xdata = transpose(xdata);
end
if size(ydata,2) > 1
    ydata = transpose(ydata);
end
if ~isempty(xdata) && ~isempty(ydata)

	%% Filling missing IG field with defaults

	% The number of peaks to fit is defined by the number of given mu's:
	nof_peaks = length(general.struct.probe_field(IG, 'mu.value','fieldnames'));

	% Define all defaults (DF):
    switch fit_type
        case 'gauss'
            [DF, DF_fit_param] = fit.defaults.gauss(xdata, ydata, nof_peaks);
        case 'edge'
            [DF, DF_fit_param] = fit.defaults.edge(xdata, ydata, nof_peaks);
    end

	% and overwrite it with IG, for the fields given:
	IG = general.struct.modify_struct(DF, IG);

	% We do the same for the fit parameters:
	% Optimization settings
	options = optimset();

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
	% Lower Boundary (LB) and the Upper boundary (UB) 
	
    % Fill in the Initial Guess (IG), Upper Boundary (UB) and Lower
    % Boundary(LB) matrices:
    IG_M = []; UB_M = []; LB_M = [];
	end_idx = 0; i = 1;
    if isfield(IG, 'mu') % If any peaks are requested at all:
        for i = 1:length(subfields)
            strt_idx    = end_idx+1;
            end_idx     = strt_idx + length(IG.(subfields{i}).value)-1;
            IG_M(1, strt_idx:end_idx) = IG.(subfields{i}).value;
            LB_M(1, strt_idx:end_idx) = IG.(subfields{i}).min;
            UB_M(1, strt_idx:end_idx) = IG.(subfields{i}).max;
            i = i + 1;
        end
    end
    % Add the y-background value:
    IG_M(1, end+1)          = IG.y_bgr.value;
    LB_M(1, end+1)          = IG.y_bgr.min;
    UB_M(1, end+1)          = IG.y_bgr.max;    
    
    if isfield(IG, 'edge')
        % Add elements to the matrices for the edge fit:
        % Edge:
        IG_M(1, end+1)          = IG.edge.value;
        LB_M(1, end+1)          = IG.edge.min;
        UB_M(1, end+1)          = IG.edge.max;
        % Edge slope:
        IG_M(1, end+1)          = IG.edge_slope.value;
        LB_M(1, end+1)          = IG.edge_slope.min;
        UB_M(1, end+1)          = IG.edge_slope.max;       
    end
end