function [hLine] = CSD(ax, exps, mds, detname, x_name)
% This macro plots the Charge Separation Distance (CSD) for several experiments. 
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
	md_plot				= md.plot.(detname).CSD;
	
	% fetching the condition event filter, if it exists:
	if isfield(md_plot, 'cond')
		f_e_c = macro.filter.conditions_2_filter(exp, md_plot.cond);
	else % If the condition is not defined, we approve all:
		f_e_c = true(size(exp.e.raw(:,i), 1), 1);
	end
% 	Plot the histogram in the given axis:
	hold on
	md.plot.(detname).CSD.color = plot.colormkr(i);
	hLine.(exp_name)	= macro.plot.CSD(ax, exp, md, detname);
	x(i)				= general.struct.getsubfield(md, x_name);
end
legend(num2str(x)); 

end