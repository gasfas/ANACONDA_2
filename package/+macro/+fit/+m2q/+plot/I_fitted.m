function [I, I_comp] = I_fitted(m2q, fit_param, ifnoise)
% This function returns the fitted intensity as a result of the m2q fitting
% procedure. 
% Inputs:
% m2q	array, the mass-to-charge points at which the fit intensity is
%		requested.
% fit_param		struct, The parameters including the fit results and metadata.
% ifnoise		boolean, whether the noise should be included (Optional,
%				default = false).
% Output:
% I				array, the intensity at the m2q values.

% fit intensity calculators, depending on which fitting method is used:
runner_f = str2func(['macro.fit.m2q.' fit_param.md.Type '.runner']);

I = zeros(size(m2q)); I_comp = [];%zeros(length(m2q), sum(fit_param.q)+length(fit_param.q));
for i = 1:length(fit_param.q)
	q_cur = fit_param.q(i);
	switch fit_param.md.Type
		case 'ind'
			fit_param_q = fit_param.result(i,1:q_cur+8);
			if ~ifnoise
				fit_param_q(end) = 0;
			end
		otherwise
			error('TODO: implement other fitting types')
	end
	
	[y_q, y_q_comp]	= runner_f(fit_param_q, m2q);
	I = I + y_q;
	if nargout>1
		I_comp = [I_comp y_q_comp];
	end
end

end
