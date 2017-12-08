function [xdata, yfitdata, ybgr, IG, LB, UB, options] = prep(fit_md, m2q, m2q_bgr, fit_param)
% This function prepares the fitting parameters and data for the individual fit model (Gaussian peaks, no relation between the peak intensities assumed).
% Inputs:
% fit_md 	struct, the fitting metadata
% m2q 		[n, 1] the mass-to-charge (x) data, without binning
% m2q_bgr 	[m, 1] the mass-to-charge (x) background data
% prev_group_param the (struct) the fitting parameters of the previous group (q' = q-1)
% Outputs:
% xdata 	[k, 1] the mass-to-charge (x) binned data, with background subtraction
% yfitdata 	[k, 1] the intensity of the histogram at xdata
% ybgr 		[k, 1] the calculated background intensity
% IG 		(struct) The Initial guess of the fit.
% LB 		(struct) The lower boundary of the fit.
% UB 		(struct) The upper boundary of the fit.
% options 	(struct) optimization options
% Binning the data:
[xdata, yfitdata, ybgr, fit_md] = macro.fit.m2q.bin_fit_data( fit_md, m2q, m2q_bgr);

% Initial guess:
IG_rph          = max(0, interp1(xdata',yfitdata, fit_md.centers')); % The relative peak height of each individual peak.
IG_rph          = IG_rph./max(IG_rph); % normalizing
IG_fpc          = min(fit_md.centers); % first peak centre
IG_lpc          = max(fit_md.centers); % last peak centre
IG_ps           = mean(diff(fit_md.centers)); % peak spacing
IG_ph           = max(interp1(xdata', yfitdata, fit_md.centers')); % peak height
IG_sigma_G      = fit_md.sigma_G; % Gaussian sigma of individual peaks;
IG_sigma_L      = fit_md.sigma_L; % Lorentzian sigma of individual peaks;
IG_noise_level  = fit_md.noise_level; % noise level
% pack up in one array:
IG = [IG_rph IG_fpc IG_lpc IG_ps IG_ph IG_sigma_G IG_sigma_L IG_noise_level];

% Lower boundaries:
LB_rph          = zeros(size(IG_rph)); % zero peak height is the lower boundary
LB_fpc          = max(0, IG_fpc - fit_md.dm2q); % first peak centre
LB_lpc          = max(0, IG_lpc - fit_md.dm2q); % last peak centre
LB_ps           = IG_ps; % peak spacing
LB_ph           = max(0, (1-fit_md.dpeak_height)*max(yfitdata)); % peak height
LB_sigma_G      = max(0, IG_sigma_G - fit_md.dsigma_G); % For the Gaussian standard deviations (must be positive)
LB_sigma_L      = max(0, IG_sigma_L - fit_md.dsigma_L); % For the Lorentzian standard deviations (must be positive)
LB_noise_level  = max(0, IG_noise_level - fit_md.dnoise_level);
% pack up in one array:
LB = [LB_rph LB_fpc LB_lpc LB_ps LB_ph LB_sigma_G LB_sigma_L LB_noise_level];

  % Upper boundaries:
UB_rph          = ones(size(IG_rph)); % max (normalized) peak height of one is the upper boundary
UB_fpc          = max(0, IG_fpc + fit_md.dm2q); % first peak centre
UB_lpc          = max(0, IG_lpc + fit_md.dm2q); % last peak centre
UB_ps           = IG_ps; % peak spacing
UB_ph           = (1+fit_md.dpeak_height)*max(yfitdata); % peak height
UB_sigma_G      = max(0, IG_sigma_G + fit_md.dsigma_G); % For the Gaussian standard deviations (must be positive)
UB_sigma_L      = max(0, IG_sigma_L + fit_md.dsigma_L); % For the Lorentzian standard deviations (must be positive)
UB_noise_level  = max(100, IG_noise_level + fit_md.dnoise_level);
% pack up in one array:
UB = [UB_rph UB_fpc UB_lpc UB_ps UB_ph UB_sigma_G UB_sigma_L UB_noise_level];        

% Optimization settings
options = optimset();
options = optimset(options, ...
    'TolX',         fit_md.opt.TolX, ...
    'TolFun',       fit_md.opt.TolFun, ...
    'MaxFunEvals',  fit_md.opt.MaxFunEvals, ...
    'MaxIter',      fit_md.opt.MaxIter); 

end

