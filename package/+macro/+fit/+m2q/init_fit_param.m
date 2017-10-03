function [all_q, fit_param] = init_fit_param(fit_md, model_Type)
% This function initializes fit parameters, by filling in 'NaN' values into
% the right size matrices in the struct.
% Input: 
% fit_md	 struct with all necessary metadata info.
% model_Type string, the type of model used. Possible choices:
% 			'nucl' (nucleation), 'bin' (binomial), 'evap', (evaporation), 
%			'nucl_evap' (nucleation and evaporation combined.
% Output:
% all_q		all the q-values considered in this fit.
% fit_param	struct, with empty arrays

all_q = fit_md.q;
switch model_Type
	case 'ind'
		fit_param.q             = NaN*ones(length(all_q),1);
		fit_param.result        = NaN*ones(length(all_q),8+max(all_q));
		fit_param.IG            = NaN*ones(length(all_q),8+max(all_q));
		fit_param.LB            = NaN*ones(length(all_q),8+max(all_q));
		fit_param.UB            = NaN*ones(length(all_q),8+max(all_q));
	case 'bin'
		fit_param.q             = NaN*ones(length(all_q),1);
		fit_param.result        = NaN*ones(length(all_q),8);
		fit_param.IG            = NaN*ones(length(all_q),8);   
		fit_param.LB            = NaN*ones(length(all_q),8);  
		fit_param.UB            = NaN*ones(length(all_q),8); 
	
	case 'evap' 
		all_q = fit_md.q;
		fit_param.q             = NaN*ones(length(all_q),1);
		fit_param.p_evap_q      = NaN*ones(length(all_q),1);
	
	case 'nucl'
		fit_param.q             = NaN*ones(length(all_q),1);
		fit_param.p_m_q         = NaN*ones(length(all_q),1);
		
	case 'nucl_evap'
		fit_param.q				= NaN*ones(length(all_q),1);
        fit_param.p_evap_q      = NaN*ones(length(all_q),1);
end