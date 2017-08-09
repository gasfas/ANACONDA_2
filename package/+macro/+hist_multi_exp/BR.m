function [BRs, x] = BR(exps, mds, detname, x_name)
% This macro calculates a branching ratio for several experiments. The branching 
% ratio is defined by a condition. The absolute number of events approved
% by the conditions can be normalized by a number specified by the
% 'normalize' conditions.
% If defined, conditions will be applied.
% Input:
% ax             The axis to plot the histogram into
% exps			Struct with the experimental data, already converted
% mds			The corresponding metadata files
% detname		The name of the detector
% x_name		The name of the variable that needs to be plotted on
%				x-axis.
% Output:
% BRs			the branching ratio's
% x				plotting variable
detnr			= IO.det_nr_from_fieldname([detname '.']);

x				= zeros(exps.info.numexps, 1);
BRs				= zeros(exps.info.numexps,1);

for i = 1:exps.info.numexps
	% Fetch (meta) data:
    exp_name            = exps.info.foi{i};
    exp                 = exps.(exp_name);
	md					= mds.(exp_name);
	
	md_plot				= md.plot.(detname).BR;
	
	% fetching the condition event filter, if it exists:
	if isfield(md_plot, 'cond')
		f_e_c	= macro.filter.conditions_2_filter(exp, md_plot.cond);
	else % If the condition is not defined, we approve all:
		f_e_c = true(size(exp.e.raw(:,i), 1), 1);
	end
	BR_abs	= sum(f_e_c);
	
	% Fetch the normalization condition, if it exists:	
	if isfield(md_plot, 'cond_normalize')
		f_e_c_n	= macro.filter.conditions_2_filter(exp, md_plot.cond_normalize);
		norm_f = sum(f_e_c_n);
	else % If the condition is not defined, we do not normalize:
		norm_f = 1;
	end
	
	BRs(i)	= BR_abs./norm_f;
	x(i)	= general.struct.getsubfield(md, x_name);
end

end