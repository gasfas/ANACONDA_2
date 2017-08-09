function [hLine] = BR(ax, exps, mds, detname, x_name)
% This macro plots a branching ratio for several experiments. The branching 
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

[BRs, x] = macro.hist_multi_exp.BR(exps, mds, detname, x_name);

md_plot			= mds.(exps.info.foi{1}).plot.(detname).BR;
hLine			= plot(ax, x, BRs);
md_plot.x_label = x_name;
plot.makeup(ax, md_plot)

end