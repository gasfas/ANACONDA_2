function  [fit_param, hFig, hAx, hLine] = angle_p_corr(data_in, metadata_in, C_nr, det_name)
% This macro executes momentum angle fits.
% Input:
% data_in        The experimental data, already converted
% metadata_in    The corresponding metadata
% C_nr			The coincidence number
% det_name      (optional) The name of the detector
% Output:
% data_out      The output data with converted data.
% metadata_out  The corresponding metadata
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

data_out = data_in;

if exist(det_name, 'var')
    detnames = det_name;
else % No detector name is given, so we fetch all detector names:
    detnames = fieldnames(metadata_in.det);
end

for i = 1:length(detnames)
    detname = detnames{i};
	
	fit_md = metadata_in.fit.(detname).(['angle_p_corr_C' num2str(C_nr)]);
	
	%% Fitting the curves with gaussian peaks:
	[fit_param, theta_containers, theta_hist_norm, theta_fit] = macro.fit.angle_p_corr.gauss1(data_in, fit_md.plot, fit_md.gauss, C_nr);
    hFig = figure; hAx = polaraxes;
    hLine = p1_2_p2_data_and_fit(hAx, theta_containers, theta_hist_norm, fit_param, fit_md.plot);
% 	%% calculate the relative intensities in hits:
% 	% calculate the total:
% 	[~, I_hits_total]= macro.fit.angle_p_corr.I_solid_angle_2_cart(theta_containers, theta_hist_norm);
% 	
% 	for p_nr = 1:length(fit_param.PH.value)
% 		pdf				= theory.function.gauss_PDF(theta_containers, fit_param.mu.value(p_nr), fit_param.sigma.value(p_nr), fit_param.PH.value(p_nr), true);
% 		[~, I_full]= macro.fit.angle_p_corr.I_solid_angle_2_cart(theta_containers, pdf);
% 		I_hits_p(p_nr)	= I_full;
% 	end
	
end
end
%% Local subfunction:
function [ hLine ] = p1_2_p2_data_and_fit(ax, theta_containers, theta_data, fit_param, plot_md)
%This convenience function shows the measured and fitted mutual angle histogram, in a polar plot.

% The data curve:
hist.Count		= theta_data;
hist.midpoints	= theta_containers;
hLine			= macro.hist.create.GraphObj(ax, hist, plot_md.GraphObj);
% fix the axes to preferred style:
ax				= general.handle.fill_struct(ax, plot_md.axes);

hold on
% The fitted curve(s):
y = theory.function.gauss_PDF(theta_containers, fit_param.mu.value, fit_param.sigma.value, fit_param.PH.value, true);
if size(y, 2) > 1 % more than one curve fitted, so we give a total as well:
	y(:, end+1) = sum(y, 2);
end
polarplot(ax, theta_containers, y, 'LineStyle', '-', 'LineWidth',2)

end
