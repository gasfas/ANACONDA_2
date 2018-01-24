function  [fit_param] = m2q(data_in, metadata_in, det_name)
% This macro executes m2q fits.
% Input:
% data_in        The experimental data, already converted
% metadata_in    The corresponding metadata
% det_name      (optional) The name of the detector
% Output:
% data_out      The output data with converted data.
% metadata_out  The corresponding metadata
data_out = data_in;

if exist(det_name, 'var')
    detnames = det_name;
else % No detector name is given, so we fetch all detector names:
    detnames = fieldnames(metadata_in.det);
end

for i = 1:length(detnames)
    detname = detnames{i};
	
    fit_md = metadata_in.fit.(detname).m2q;

	% Load background data:
	[bgr_m2q, bgr_data] = macro.fit.m2q.bgr.load(fit_md, detname);		
	
	if general.struct.issubfield(fit_md, 'cond') % condition applied:
		e_f = macro.filter.conditions_2_filter(data_in, fit_md.cond);
		h_f_s = filter.events_2_hits_det(e_f, data_in.e.raw, size(data_in.h.(detname).m2q,1));
		m2q_data = data_in.h.(detname).m2q(h_f_s);
		
		% Do the same for the background data:
		e_f_bgr = macro.filter.conditions_2_filter(bgr_data, fit_md.cond);
		h_f_bgr = filter.events_2_hits_det(e_f_bgr, bgr_data.e.raw, size(bgr_data.h.(detname).m2q,1));
		bgr_m2q = bgr_m2q(h_f_bgr);
	else % just raw m2q data:
		m2q_data = data_in.h.(detname).m2q;
	end

    % Fit parameters preparation (different for different types of fitting):
    [all_q, fit_param] = macro.fit.m2q.init_fit_param(fit_md, fit_md.Type);

	if general.struct.probe_field(fit_md.ifdo, 'plots')
		h = figure; 
		h.Name = fit_md.Type; 
		ax = gca; 
	end
	
	if general.struct.probe_field(fit_md, 'ifdo.sidecuts') % Does the user want to cut off sides of the fit window
		% We give a rough estimate of the peak centres:
		[p_peakcenters, peak_m2q, peak_q] = macro.fit.m2q.size_to_m2q_corr (fit_md, m2q_data);
	end
	
	for j = 1:length(all_q)
		
		% In case of evaporation/nucleation, the previous/next q needs to
		% be selected:
		% select previous/next q:
		switch fit_md.Type
			case 'evap' % Fetch the (q+1) cluster group info.
				[fit_param_prev, fit_md_prev] = fit_q_plus_1(fit_md, data_in, fit_param, all_q(j), j); %TODO
			case 'nucl'
				[fit_param_prev, fit_md_prev] = fit_q_min_1(fit_md, data_in, fit_param, all_q(j), j); %TODO
		end

		% select the current q:
        fit_md.q = all_q(j);
		% Fit (local function):
		fit_param = fit_m2q(fit_md, data_in, fit_param, j);
	end
end

if general.struct.probe_field(fit_md.ifdo, 'final_plot')% If the user wants to see a 'final' oversight plot of the fits:
	fin_plot_f = str2func(['macro.fit.m2q.' fit_md.Type '.plot_all']);
	fin_plot_f(fit_md, fit_param);
end

% add the metadata to the fit parameters:
fit_param.md = fit_md;

%% Local subfunctions % Local subfunctions % Local subfunctions % Local subfunctions:
function fit_param = fit_m2q(fit_md, data_in, fit_param, j)

		% Prepare functions depending on which fitting method is used:
		prep_f = str2func(['macro.fit.m2q.' fit_md.Type '.prep']);

		% fit runners, depending on which fitting method is used:
		runner_f = str2func(['macro.fit.m2q.' fit_md.Type '.runner']);
		% fetch the fit parameters (different for different types of fitting):
        [xdata, yfitdata, ybgr, IG, LB, UB, options] = prep_f(fit_md, m2q_data, bgr_m2q, fit_param);
        
		if general.struct.probe_field(fit_md, 'ifdo.sidecuts') && fit_md.q > general.struct.probe_field(fit_md, 'sidecuts.q_min') % Does the user want to cut off sides of the fit window
			% Apply the sidecuts to the data:
			[yfitdata, m2q_cut_centre, p_peakcenters, peak_m2q, peak_q] = macro.fit.m2q.find_sidecut_centre(fit_md, xdata, yfitdata, p_peakcenters, peak_m2q, peak_q);
			% Apply the sidecuts to the fitting BC:
			switch fit_md.Type
				case 'ind'
					[IG, LB, UB] = macro.fit.m2q.ind.sidecuts(fit_md, IG, LB, UB, m2q_cut_centre);
			end
		end
		
		if general.struct.probe_field(fit_md.ifdo, 'plots') % Does the user want to see the plots?
			macro.fit.m2q.plot.before(ax, xdata, yfitdata, ybgr, runner_f(IG, xdata));
		end
		
        % Fit!
        [result.param,result.residual_norm_lsqc,result.residuals,result.exitflag,result.fit_info] = lsqcurvefit( ...
                    runner_f, IG, xdata, yfitdata, LB, UB, options);
		
		% Calculate the goodness of the fit:
		yfit = runner_f(result.param, xdata);
		result.goodness = goodnessOfFit(yfit, yfitdata, fit_md.goodness.Cost_func);
		
        % Fill in the results of this simulation into output struct:
        [fit_param] = macro.fit.m2q.exit_fit_param(fit_param, fit_md, result, j, IG, LB, UB, fit_md.Type);

		if general.struct.probe_field(fit_md.ifdo, 'plots') % Does the user want to see the plots?
			xshowdata			= linspace(xdata(1),xdata(end), numel(xdata)*5)';
			[y_sum, y_comp]		= runner_f(result.param, xshowdata);
			macro.fit.m2q.plot.after(ax, xshowdata, y_sum, y_comp);
		end
end

function [fit_param, fit_md] =	fit_q_plus_1(fit_md, data_in, fit_param, q_cur, j)
				fit_md_q_plus_1			= fit_md;
				fit_md_q_plus_1.q		= q_cur+1;
				if ~isfield(fit_param, ['q_' num2str(fit_md_q_plus_1.q)])
					% If the q+1 (one unit bigger) cluster group has not
					% yet been fitted, we determine it through an independent fit:
					fit_md_q_plus_1.Type	= 'ind';
					% fetch the inidivual fit preparation:
					fit_param = fit_m2q(fit_md_q_plus_1, data_in, fit_param, j);
					
				else
					fit_param = fit_param.(['q_' num2str(fit_md_q_plus_1.q)]);
				end
				% set the initial Gaussian and Lorentz broadening as the one
        % from the bigger group fit:
        fit_md.sigma_L = param_big_q(end-1);
        fit_md.sigma_G = param_big_q(end-2);
end
end