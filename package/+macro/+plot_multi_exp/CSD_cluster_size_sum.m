function [hLine, hlgd] = CSD_cluster_size_sum(ax, exps, mds, detname, x_name, plotstyle)
% This macro plots the charge separation distance for several experiments. The branching 
% ratio is defined by a condition. The absolute number of events approved
% by the conditions can be normalized by a number specified by the
% 'normalize' conditions.
% If defined, conditions will be applied.
% Input:
% ax             The axis to plot the histogram into
% exps			Struct with the experimental data, already converted
% mds			The corresponding metadata files
% detname		The name of the detector
% Output:
% hLine         The line handle of the plotted histogram line.
% BR_Cis_phys_r Reconstructed branching ratio's
% BR_Cis_meas	Measured branching ratio
% x				plotting variable
% C_nrs			Coincidence numbers studied
detnr			= IO.det_nr_from_fieldname([detname '.']);

x				= zeros(exps.info.numexps, 1);
% CSD_hist		= zeros(length(C_nrs), exps.info.numexps);
% BR_Cis_meas		= zeros(length(C_nrs), exps.info.numexps);

for i = 1:exps.info.numexps
	% Fetch (meta) data:
    exp_name            = exps.info.foi{i};
    exp                 = exps.(exp_name);
	md					= mds.(exp_name);
	
	md_plot				= md.plot.(detname).CSD_mean_cluster_size_sum;
	
	% fetching the condition event filter, if it exists:
	if isfield(md_plot, 'cond')
		f_e_c = macro.filter.conditions_2_filter(exp, md_plot.cond);
	else % If the condition is not defined, we approve all:
		f_e_c = true(size(exp.e.raw(:,i), 1), 1);
	end
% 	Plot the histogram in the given axis:
	hold on
	hLine.(exp_name)	= macro.plot.CSD_cluster_size_sum(ax, exp, md, detname, 'mean');
	x(i)				= general.struct.getsubfield(md, x_name);
end
hlgd = legend(num2str(x), 'Location', 'Best'); legend boxoff;

end