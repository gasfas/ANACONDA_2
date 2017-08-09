function [IG, LB, UB, options] = combined_model_prep(fit_md, PD_t)
% Combined model fitting preparation
% This is a convenience function to define the boundary conditions to the
% 'combined model'
% Input:
% fit_md    The fit metadata, struct
% PD_t      The total probability density
% Output:
% IG    Initial Guess parameters
% LB    Lower Boundary parameters
% UB    Upper Boundary parameters

nof_qs      = size(PD_t,1);
max_qpl_1   = size(PD_t, 2);

% Initial guess:
% parameters:
IG_p_nucl   = repmat(fit_md.p_nucl_q_m, nof_qs, 1);
IG_p_evap   = repmat(fit_md.p_evap_q_m, nof_qs, 1);
IG_f_mother = repmat(fit_md.f_mother, nof_qs, 1);
% Debug:
% IG_f_mother = repmat(0, nof_qs, 1);
% The Initial guesses for the PD's:
IG_PD_t   = PD_t;%   total cluster distribution
IG_PD_m   = repmat(IG_f_mother, 1, max_qpl_1).*PD_t;% mother cluster distribution

% pack up in one array:
IG = [IG_p_nucl IG_p_evap IG_f_mother IG_PD_m];

% Lower boundaries:
% parameters:
LB_p_nucl   = zeros(size(IG_p_nucl));
LB_p_evap   = zeros(size(IG_p_evap));
LB_f_mother = zeros(size(IG_f_mother));
% % Debug:
% % LB_f_mother = repmat(0, nof_qs, 1);
% The Lower boundaries for the PD's:
LB_PD_t     = IG_PD_t;
LB_PD_m     = zeros(size(IG_PD_m));

% pack up in one array:
LB = [LB_p_nucl LB_p_evap LB_f_mother LB_PD_m];

% Upper boundaries:
% parameters:
UB_p_nucl   = ones(size(IG_p_nucl));
UB_p_evap   = ones(size(IG_p_evap));
UB_f_mother = ones(size(IG_f_mother));
% % Debug:
% UB_f_mother = repmat(1, nof_qs, 1);
% The Upper boundaries for the PD's:
UB_PD_t = IG_PD_t; % No change allowed.
UB_PD_m = IG_PD_t; % Cannot be higher than the total probability density.

% pack up in one array:
UB = [UB_p_nucl UB_p_evap UB_f_mother UB_PD_m+1e-5];

% Optimization settings
options = optimset();
options = optimset(options, ...
    'TolX',         fit_md.opt_4.TolX, ...
    'TolFun',       fit_md.opt_4.TolFun, ...
    'MaxFunEvals',  fit_md.opt_4.MaxFunEvals, ...
    'MaxIter',      fit_md.opt_4.MaxIter); 
end

