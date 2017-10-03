function [fit_param] = exit_fit_param(fit_param, fit_md, result, simnr, IG, LB, UB, model_Type)
% This function exports the fit parameters (array) and initial guesses 
% into a more readable (struct) format.
% Input: 
% fit_param		struct, with the new simulation results to be filled in.
% fit_md		the needed fit metadata.q-number of this simulation
% result		output struct from lsqcurvefit, with the result parameters.
% simnr			current simulation number.
% IG			(struct) The Initial guess of the fit.
% LB			(struct) The lower boundary of the fit.
% UB			(struct) The upper boundary of the fit.
% model_Type	string, the type of model used. Possible choices:
%				'nucl' (nucleation), 'bin' (binomial), 'evap', (evaporation), 
%				'nucl_evap' (nucleation and evaporation combined.
% Output:
% fit_param		struct, with the results filled in.


% Fill in the results into output struct:
switch model_Type
	case 'ind'
	        fit_param.q(simnr)					= fit_md.q;
			fit_param.result(simnr,1:8+fit_md.q)= result.param;
			fit_param.IG(simnr,1:8+fit_md.q)	= IG;
			fit_param.LB(simnr,1:8+fit_md.q)	= LB;
			fit_param.UB(simnr,1:8+fit_md.q)	= UB;
			fit_param.p_m_q(simnr)				= fit_param.result(simnr,5);
	case 'bin'
	        fit_param.q(simnr)					= fit_md.q;
			fit_param.result(simnr,:)			= result.param;
			fit_param.IG(simnr,:)				= IG;
			fit_param.LB(simnr,:)				= LB;
			fit_param.UB(simnr,:)				= UB;
			fit_param.p_m_q(simnr)				= fit_param.result(simnr,5);
	case 'evap' 
			fit_param.q(simnr)					= fit_md.q;
			fit_param.p_evap_q(simnr,:)         = p_evap_q;
			fit_param.(['rph_q_' num2str(fit_md.q)]) = rph;
			fit_param.(['q_' num2str(fit_md.q,2)]) = [rph result.param(end-6:end)];
	case 'nucl'
			fit_param.q(simnr)					= fit_md.q;
			fit_param.p_evap_q(simnr,:)			= p_evap_q;
			fit_param.(['rph_q_' num2str(fit_md.q)]) = rph;
			fit_param.(['q_' num2str(fit_md.q,2)]) = [rph result.param(end-6:end)];
	case 'nucl_evap'
			fit_param.all.(['q_' num2str(fit_md.q)]) = param_q;
            fit_param.q(simnr)                  = fit_md.q;
            fit_param.(['rph_q_' num2str(fit_md.q)]) = param_q(1:fit_md.q+1)./sum(param_q(1:fit_md.q+1));
            fit_param.(['noise_level_q_' num2str(fit_md.q)]) = param_q(end);
end