function [fit_results, X, Y] = I_at_q(q, fit_md, fit_param)
% This function writes a 2D map of fitted intensities (fit_results).

switch fit_md.Type
	case 'ind' % independent peak fit:
		% Try to fetch the probe width (m2q distance between Intensity probes):
	try probe_width = fit_md.final_plot.probe_width; catch probe_width = 10; end
	mass_qmax	= (max(q)*fit_md.m.mass):probe_width:(max(q)*fit_md.n.mass);
	switch fit_md.final_plot.hist.pointer{2}
		case 'n-fraction'
			X		= q;
			Y		= (0:probe_width:100)';
		otherwise
			X		= q;
			Y		= (0:probe_width:max(q))';
	end
	fit_results = NaN*ones(length(X), length(Y));
	for i = 1:length(q)
		q_cur = q(i);
		runner_f = str2func(['macro.fit.m2q.' fit_md.Type '.runner']);
		rownr		= find(q_cur==fit_param.q);
		switch fit_md.final_plot.hist.pointer{2}
			case 'n-fraction'
				massdata = linspace((q_cur*fit_md.m.mass), (q_cur*fit_md.n.mass), length(Y))'+fit_md.H.mass;
				fit_results(i,:) = runner_f(fit_param.result(rownr,1:end-(max(fit_param.q)-q_cur)), massdata);
			otherwise
				massdata = ((q_cur*fit_md.m.mass):probe_width:(q_cur*fit_md.n.mass))'+fit_md.H.mass;
				fit_results(i,1:length(massdata)) = runner_f(fit_param.result(rownr,1:end-(max(fit_param.q)-q_cur)), massdata);
		end
	end
	otherwise
		error('from other fit types not implemented yet')
end
