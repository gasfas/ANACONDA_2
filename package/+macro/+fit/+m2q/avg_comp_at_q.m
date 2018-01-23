function [avg_m] = avg_comp_at_q(q, fit_md, fit_param)
% This function calculates the average number of m-component units in a
% cluster, as extracted from the given fit results.

% First calculate the Intensities at the requested q:
fit_param.md.final_plot.probe_width = 1;
fit_md.final_plot.hist.pointer{2} = 'm';
[I, ~, m] =macro.fit.m2q.I_at_q(q, fit_md, fit_param);

switch fit_md.Type
	case 'ind' % independent peak fit:
		% Calculate the mean:
		avg_m = I*m./sum(I);
	otherwise
		error('from other fit types not implemented yet')
end