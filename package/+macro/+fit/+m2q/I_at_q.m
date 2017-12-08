function [fit_results, nof_m] = I_at_q(q, fit_md, fit_param)
% This function writes a 2D map of fitted intensities (fit_results).

switch fit_md.Type
	case 'ind' % independent peak fit:
		% Try to fetch the probe width (distance between Intensity probes):
	try probe_width = fit_md.final_plot.probe_width; catch probe_width = 10; end
	mass_qmax	= (max(q)*fit_md.m.mass):probe_width:(max(q)*fit_md.n.mass);
	nof_m		= (0:probe_width:max(q))';
	fit_results = NaN*ones(length(q), length(mass_qmax));
	for i = 1:length(q)
		q_cur = q(i);
		runner_f = str2func(['macro.fit.m2q.' fit_md.Type '.runner']);
		massdata = ((q_cur*fit_md.m.mass):probe_width:(q_cur*fit_md.n.mass))'+fit_md.H.mass;
		rownr		= fit_param.q(q_cur==fit_param.q);
		fit_results(i,1:length(massdata)) = runner_f(fit_param.result(rownr,1:end-(max(fit_param.q)-q_cur)), massdata);
	end
	otherwise
		error('from other fit types not implemented yet')
end