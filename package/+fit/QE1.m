function [BR_Ci_phys, Fit_info] = QE1(C_nrs, BR_Ci_meas, QE_i, QE_e, IG, fit_param)
% Execute a fit based on the simple QE model.
% Input:
% C_nrs		[n, 1] The coincidence nrs under study
% BR_Ci_meas[n, 1] The corresponding measured branching ratio's
% QE		scalar: Quantum efficiency of the detector. Is in fact not a
% scalar, to be advanced later.
% IG		struct of metadata containing initial guess. The format shoud
%			be as follows:
% 			IG.BR.value should contain the initial guesses of the branching
% 			ratio
%			IG.BR.min	(optional) the minimum values
%			IG.BR.max	(optional) the maximum values
% fit_param struct with fitting parameters
% Output:
% BR_Ci_phys The physical branching ratio at specified C_nrs
% Fit_info	Technical log on the least-square fitting procedure
%
% written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% Define all defaults (DF):
[DF, DF_fit_param] = fit.defaults.QE1(C_nrs, BR_Ci_meas, length(C_nrs));


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

%% Initiating the fitting
% reshape to a suitable parameter format:
IG_M = IG.BR.value;
LB_M = IG.BR.min;
UB_M = IG.BR.max;

% create an anonymous function:
af = @(BR_phys_af, C_nrs_af)fit.runner.QE1(BR_phys_af, QE_i, QE_e, C_nrs_af);

%% Fit!
[BR_Ci_phys, ...
    Fit_info.residual_norm_lsqc, ...
    Fit_info.residuals, ...
    Fit_info.exitflag, ...
    Fit_info.fit_info] = ...
    lsqcurvefit(af , IG_M, C_nrs, BR_Ci_meas, LB_M, UB_M, options);

% give a warning in case the fit did not work properly:
if norm((af(BR_Ci_phys, C_nrs) - BR_Ci_meas)./BR_Ci_meas) > 0.1
	warning('The fit did not converge within 10% of the aimed value')
end

end

