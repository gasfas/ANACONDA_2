function [FP, theta_containers, theta_hist_norm, theta_fit, f_e] = gauss1(data_in, angle_p_corr_md, fit_metadata, C_nr)
% This macro plots the angle histogram of the angle between single-event momenta.
% Input:
% data_in       The experimental data, already converted
% angle_p_corr_md Metadata struct containing binning information
% fit_metadata  Metadata struct containing fitting information
% C_nr          Integer coincidence number to be studied (can be 2, 3, ...)
% Output:
% FP            The resulting fit parameters
% theta_containers The x-values at which the bins are defined
% theta_fit     The y-values from the fit.

if ~exist('C_nr', 'var')
    % If the coincidence number is not defined, we assume double coincidence:
    C_nr = 2;
end

data_out = data_in;

%% Fetching
% define the name of the field:
angle_p_fieldname = ['angle_p_corr_C' num2str(C_nr, 1)];

% Fetch the Ci events and their mutual angles (conversion should 
% already have been done in the convert macro):
theta_Ci = data_out.e.det1.(angle_p_fieldname);
if general.struct.issubfield(angle_p_corr_md, 'cond')
	f_e = macro.filter.conditions_2_filter(data_out, angle_p_corr_md.cond);
	theta = theta_Ci(f_e, :);
else
	theta = theta_Ci;
end

%% Plotting

[theta_hist_norm, theta_containers] = hist.H_solid_angle_polar(theta, angle_p_corr_md.binsize, angle_p_corr_md.x_range);

% Now we try out the fitting:
% If requested, the range of theta is decreased:
if general.struct.issubfield(fit_metadata, 'theta.value')
	f = theta_containers > fit_metadata.theta.value(1) & theta_containers < fit_metadata.theta.value(2);
	fit_theta_hist_norm		= theta_hist_norm(f);
	fit_theta_containers	= theta_containers(f);
else
	fit_theta_hist_norm		= theta_hist_norm;
	fit_theta_containers	= theta_containers;
end
fit_param = fit_metadata.fit_param;
FP = fit.gauss(fit_theta_containers, fit_theta_hist_norm, fit_metadata, fit_param);


theta_fit = theory.function.gauss_PDF(theta_containers, FP.mu.value, FP.sigma.value, FP.PH.value) + FP.y_bgr.value;

end
