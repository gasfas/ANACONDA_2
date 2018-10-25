function [I_hits, I_angles] = p1_2_p2_all (exps, mds, C_nrs)
% this function fits mutual angle histograms for multiple experiments.
% This macro produces a bunch of plots, based on the corrected and converted signals.
% Input:
% exps          Struct containing experimental datasets, already converted
% mds			Struct containing the corresponding metadata 
% C_nr			(optional) The coincidence number for each experiment
% Output:
% I_hits		Matrix containing the number of hits inside the shown fit
% I_angles		The corresponding angles.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

detname = 'det1';
legendtext = {};
figure; 
runningh = polaraxes;
numexps = exps.info.numexps;

for i = 1:numexps    
    
	try		C_nr = C_nrs(i);
	catch	C_nr = 2; end
	
    exp_name            = exps.info.foi{i};
    exp                 = exps.(exp_name);
    md                  = mds.(exp_name);
    p1_2_p2_md          = md.plot.(detname).(['angle_p_corr_C' num2str(C_nr)]);
	fit_metadata        = md.fit.(detname).(['angle_p_corr_C' num2str(C_nr)]).gauss;
	
    % We change color for different species:
	if general.struct.issubfield(md, 'sample.constituent.masses')
    p1_2_p2_md.color    = species_dependent_color(md.sample);
	end
    % And we change the linestyle:
    p1_2_p2_md.LineStyle    = plot.linestylemkr(i);
     
	%% Fitting the curves with gaussian peaks:
	[FP, theta_containers, theta_hist_norm, theta_fit] = macro.fit.angle_p_corr.gauss1(exp, p1_2_p2_md, fit_metadata, C_nr);

	macro.plot.p1_2_p2_data_and_fit(runningh, theta_containers, theta_hist_norm, theta_fit, p1_2_p2_md);
	hold on

	%% calculate the relative intensities in hits:
	% calculate the total:
	[~, I_hits_total]= macro.fit.angle_p_corr.I_solid_angle_2_cart(theta_containers, theta_hist_norm);
	
	for p_nr = 1:length(FP.PH.value)
		pdf				= theory.function.gauss_PDF(theta_containers, FP.mu.value(p_nr), FP.sigma.value(p_nr), FP.PH.value(p_nr), true);
		[~, I_full]= macro.fit.angle_p_corr.I_solid_angle_2_cart(theta_containers, pdf);
		I_hits_p(p_nr)	= I_full;
	end

	% Store the Fit results, to show later:
	I_angles(i,:)			= FP.mu.value;	
	I_hits(i,:)				= I_hits_p./I_hits_total;
	
    legendtext = {legendtext{:} [num2str(I_hits(i), 2)] };
end
hld = legend(legendtext, 'Interpreter', 'Latex', 'Location', 'NorthEast');
plot.legendtitle(hld, 'I(120$^o$)/I(180$^o$) (polar, \# hits)');
end