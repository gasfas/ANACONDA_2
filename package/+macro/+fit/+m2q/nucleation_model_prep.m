function [xdata yfitdata ybgr IG LB UB options] = nucleation_model_prep (fit_md, m2q, m2q_bgr, prev_group_param )
% This function projects a smaller cluster group spectrum onto a cluster
% group one 'q' higher.

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
centers_prev    = repmat(prev_group_param(end-6):prev_group_param(end-4):prev_group_param(end-5), length(xdata), 1);
q_prev          = size(centers_prev,2) - 1; %q is the number of dice throws
noise_level_prev= prev_group_param(end);
rph_prev        = prev_group_param(1:q_prev+1); % The relative peak height.

%% writing the new parameter array:

% Initial guess:
IG_p_m_q        = fit_md.p_nucl_q; %p_m_q initial value comes from input file
IG_rph_prev     = rph_prev; % The relative peak height of each individual peak.
IG_fpc          = min(fit_md.centers); % first peak centre
IG_lpc          = max(fit_md.centers); % last peak centre
IG_ps           = mean(diff(fit_md.centers)); % peak spacing
IG_ph           = max(yfitdata); % peak height
IG_sigma_G      = fit_md.sigma_G; % Gaussian sigma of individual peaks;
IG_sigma_L      = fit_md.sigma_L; % Lorentzian sigma of individual peaks;
IG_noise_level  = noise_level_prev; % noise level
% pack up in one array:
IG = [IG_p_m_q IG_rph_prev IG_fpc IG_lpc IG_ps IG_ph IG_sigma_G IG_sigma_L IG_noise_level];

% Lower boundaries:
LB_p_m_q        = max(0, IG_p_m_q - fit_md.dp_m_q);% The minimum p_m_q
LB_rph_prev     = IG_rph_prev; % no change allowed in this parameter (=constant)
LB_fpc          = max(0, IG_fpc - fit_md.dm2q); % first peak centre
LB_lpc          = max(0, IG_lpc - fit_md.dm2q); % last peak centre
LB_ps           = IG_ps; % peak spacing
LB_ph           = (1-fit_md.dpeak_height)*max(yfitdata); % peak height
LB_sigma_G      = max(0, IG_sigma_G - fit_md.dsigma_G); % For the Gaussian standard deviations (must be positive)
LB_sigma_L      = max(0, IG_sigma_L - fit_md.dsigma_L); % For the Lorentzian standard deviations (must be positive)
LB_noise_level  = IG_noise_level - fit_md.dnoise_level;
% pack up in one array:
LB = [LB_p_m_q LB_rph_prev LB_fpc LB_lpc LB_ps LB_ph LB_sigma_G LB_sigma_L LB_noise_level];

  % Upper boundaries:
UB_p_m_q        = min(1, IG_p_m_q + fit_md.dp_m_q);% The maximum p_m_q
UB_rph_prev     = IG_rph_prev; % no change allowed in this parameter (=constant)
UB_fpc          = max(0, IG_fpc + fit_md.dm2q); % first peak centre
UB_lpc          = max(0, IG_lpc + fit_md.dm2q); % last peak centre
UB_ps           = IG_ps; % peak spacing
UB_ph           = (1+fit_md.dpeak_height)*max(yfitdata); % peak height
UB_sigma_G      = max(0, IG_sigma_G + fit_md.dsigma_G); % For the Gaussian standard deviations (must be positive)
UB_sigma_L      = max(0, IG_sigma_L + fit_md.dsigma_L); % For the Lorentzian standard deviations (must be positive)
UB_noise_level  = IG_noise_level + fit_md.dnoise_level;
% pack up in one array:
UB = [UB_p_m_q UB_rph_prev UB_fpc UB_lpc UB_ps UB_ph UB_sigma_G UB_sigma_L UB_noise_level];        

% Optimization settings
options = optimset();
options = optimset(options, ...
    'TolX',         fit_md.opt_2.TolX, ...
    'TolFun',       fit_md.opt_2.TolFun, ...
    'MaxFunEvals',  fit_md.opt_2.MaxFunEvals, ...
    'MaxIter',      fit_md.opt_2.MaxIter); 

end

