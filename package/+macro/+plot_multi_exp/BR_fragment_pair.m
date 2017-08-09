function [hLine, BR_Cis_phys_r, BR_Cis_meas, x, C_nrs] = BR_fragment_pair(ax, exps, mds, detname, x_name)
% This macro plots the branching ratio's of different recorded coincidence
% numbers (or multiplicities), for several experiments. If defined, conditions will be applied.
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

C_nrs			= mds.(exps.info.foi{1}).plot.det1.BR_fragment_pair.C_nrs;
BR_Cis_phys		= zeros(length(C_nrs), exps.info.numexps);
BR_Cis_meas		= zeros(length(C_nrs), exps.info.numexps);
x				= zeros(exps.info.numexps, 1);
detnr			= IO.det_nr_from_fieldname([detname '.']);

for i = 1:exps.info.numexps
	% Fetch (meta) data:
    exp_name            = exps.info.foi{i};
    exp                 = exps.(exp_name);
	md					= mds.(exp_name);
    BR_md				= md.plot.det1.BR_fragment_pair;
    QE_i				= BR_md.QE_i;
	QE_e				= BR_md.QE_e;
	min_BR				= BR_md.min_BR;
	
	% fetching the condition event filter, if it exists:
	if isfield(BR_md, 'cond')
		f_e_c = macro.filter.conditions_2_filter(exp, BR_md.cond);
	else % If the condition is not defined, we approve all:
		f_e_c = true(size(exp.e.raw(:,i), 1), 1);
	end
	
	% Calculate the measured branching ratio's:
	label_list = md.conv.det1.m2q_labels;
	[A, BR_m] = hist.BR.fragment_pairs(exp.e.raw(:,detnr), exp.h.det1.m2q_l, label_list,  C_nrs,  [], f_e_c, min_BR);
	
	if length(QE_i) ~= length(label_list)
		QE_i_labels = ones(size(label_list))*QE_i;
	else
		QE_i_labels = general.matrix.array2column(QE_i);
	end
	% Calculate the physical branching ratio:
	BR_p = theory.QE.QE2(A, BR_m, QE_i, QE_e);
	% Count the branching ratio for each C_nr:
	C_nr = sum(A,2);
	C_edges			= (min(C_nrs)-0.5:max(C_nrs)+0.5)';
	[BR_Ci_meas]	= hist.weighted.H_1D( C_nr, BR_m, C_edges);
	[BR_Ci_phys]	= hist.weighted.H_1D(C_nr, BR_p, C_edges);
	% store the Branching ratio's:
	BR_Cis_meas(:,i)	= BR_Ci_meas;
	BR_Cis_phys(:,i)	= BR_Ci_phys ;
	x(i)				= general.struct.getsubfield(md, x_name);
end

% Convert the branching ratio's to percentages:
BR_Cis_phys_r = convert.abs_2_rel(BR_Cis_phys, 1)*100;
BR_md.trend.x_range		= [min(x); max(x)];
hLine = macro.plot.BR_trend(ax, x, C_nrs, BR_Cis_phys_r, BR_md.trend);

end