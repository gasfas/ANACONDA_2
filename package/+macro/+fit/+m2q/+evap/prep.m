function [xdata yfitdata ybgr IG LB UB options] = prep (fit_md, m2q, m2q_bgr, prev_group_param )
% This function projects a smaller cluster group spectrum onto a cluster
% group one 'q' lower ('Evaporation' model).
% Inputs:
% fit_md 	struct, the fitting metadata
% m2q 		[n, 1] the mass-to-charge (x) data, without binning
% m2q_bgr 	[m, 1] the mass-to-charge (x) background data
% prev_group_param the (struct) the fitting parameters of the previous group (q' = q+1)
% Outputs:
% xdata 	[k, 1] the mass-to-charge (x) binned data, with background subtraction
% yfitdata 	[k, 1] the intensity of the histogram at xdata
% ybgr 		[k, 1] the calculated background intensity
% IG 		(struct) The Initial guess of the fit.
% LB 		(struct) The lower boundary of the fit.
% UB 		(struct) The upper boundary of the fit.
% options 	(struct) optimization options

% The optimization parameters:
% p_m_q
% peak height
% Gaussian width:
% noise level:

%% Current cluster group

% Binning the data:
[xdata, yfitdata, ybgr, fit_md] = macro.fit.m2q.bin_fit_data( fit_md, m2q, m2q_bgr);

%% Previous cluster group
% We fetch the relative peak heights of the previous cluster group:
%parameters:
centers_prev        = repmat(prev_group_param(end-6):prev_group_param(end-4):prev_group_param(end-5), length(xdata), 1);
q_pl_1              = size(centers_prev,2) - 1; %q is the number of dice throws
noise_q_pl_1        = prev_group_param(end);
rph_q_pl_1          = prev_group_param(1:q_pl_1+1); % The relative peak height.

%% writing the new parameter array:

% Initial guess:
IG_p_evap_q     = fit_md.p_evap_q; %p_m_q initial value of evaporation probability (comes from input file)
IG_rph_q_pl_1   = rph_q_pl_1; % The relative peak height of each individual peak of the q+1 peak
IG_fpc          = min(fit_md.centers); % first peak centre
IG_lpc          = max(fit_md.centers); % last peak centre
IG_ps           = mean(diff(fit_md.centers)); % peak spacing
IG_ph           = max(yfitdata); % peak height
IG_sigma_G      = fit_md.sigma_G; % Gaussian sigma of individual peaks;
IG_sigma_L      = fit_md.sigma_L; % Lorentzian sigma of individual peaks;
IG_noise_level  = noise_q_pl_1; % noise level
% pack up in one array:
IG = [IG_p_evap_q IG_rph_q_pl_1 IG_fpc IG_lpc IG_ps IG_ph IG_sigma_G IG_sigma_L IG_noise_level];

% Lower boundaries:
LB_p_m_q        = max(0, IG_p_evap_q - fit_md.dp_m_q);% The minimum p_m_q
LB_rph_q_pl_1   = IG_rph_q_pl_1; % no change allowed in this parameter (=constant)
LB_fpc          = max(0, IG_fpc - fit_md.dm2q); % first peak centre
LB_lpc          = max(0, IG_lpc - fit_md.dm2q); % last peak centre
LB_ps           = IG_ps; % peak spacing
LB_ph           = (1-fit_md.dpeak_height)*max(yfitdata); % peak height
LB_sigma_G      = max(0, IG_sigma_G - fit_md.dsigma_G); % For the Gaussian standard deviations (must be positive)
LB_sigma_L      = max(0, IG_sigma_L - fit_md.dsigma_L); % For the Lorentzian standard deviations (must be positive)
LB_noise_level  = IG_noise_level - fit_md.dnoise_level;
% pack up in one array:
LB = [LB_p_m_q LB_rph_q_pl_1 LB_fpc LB_lpc LB_ps LB_ph LB_sigma_G LB_sigma_L LB_noise_level];

  % Upper boundaries:
UB_p_m_q        = min(1, IG_p_evap_q + fit_md.dp_m_q);% The maximum p_m_q
UB_rph_q_pl_1	= IG_rph_q_pl_1; % no change allowed in this parameter (=constant)
UB_fpc          = max(0, IG_fpc + fit_md.dm2q); % first peak centre
UB_lpc          = max(0, IG_lpc + fit_md.dm2q); % last peak centre
UB_ps           = IG_ps; % peak spacing
UB_ph           = (1+fit_md.dpeak_height)*max(yfitdata); % peak height
UB_sigma_G      = max(0, IG_sigma_G + fit_md.dsigma_G); % For the Gaussian standard deviations (must be positive)
UB_sigma_L      = max(0, IG_sigma_L + fit_md.dsigma_L); % For the Lorentzian standard deviations (must be positive)
UB_noise_level  = IG_noise_level + fit_md.dnoise_level;
% pack up in one array:
UB = [UB_p_m_q UB_rph_q_pl_1 UB_fpc UB_lpc UB_ps UB_ph UB_sigma_G UB_sigma_L UB_noise_level];        

% Optimization settings
options = optimset();
options = optimset(options, ...
    'TolX',         fit_md.opt_2.TolX, ...
    'TolFun',       fit_md.opt_2.TolFun, ...
    'MaxFunEvals',  fit_md.opt_2.MaxFunEvals, ...
    'MaxIter',      fit_md.opt_2.MaxIter); 

end

