function  [fit_param] = m2q_4(data_in, metadata_in, det_name, bgr, bgr_md)
% This macro executes m2q fit 4.
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

for i = 1:length(detnames);
    detname = detnames{i};  

    fit_md = metadata_in.fit.(detname).m2q;
        
        % Fitting of a set of binary cluster peaks, optimization procedure.
        % preparation:
        all_q = fit_md.q;
        fit_param.q             = NaN*ones(length(all_q),1);
        fit_param.p_evap_q      = NaN*ones(length(all_q),1);
        
        PD_t                = zeros(length(all_q), max(all_q)+1);
%         
        for j = 1:length(all_q)
            
            fit_md.q = all_q(j);

            [xdata, yfitdata, ybgr, IG, LB, UB, options] = fit.ind_peak_fit_prep(fit_md, data_in.h.(detname).m2q, bgr.h.(detname).m2q);

            plot(xdata, yfitdata + ybgr, '+'); hold on;
            plot(xdata, yfitdata, '+');
            plot(xdata, fit.ind_peak_fit(IG, xdata));
            legend('Raw data', 'Noise subtracted', 'Initial guess')
            plot.textul(['$q = ' num2str(fit_md.q) '$'], 0.1, 0.08, 'k');
            set (gcf, 'Position', [1094         104         810         802])
            set(gca, 'XTick', IG(end-6):IG(end-4):IG(end-5))
            set (gcf, 'Position', [320    64   810   802])
            grid on

            % Fit!
            [param_q,result.residual_norm_lsqc,result.residuals,result.exitflag,result.fit_info] = lsqcurvefit( ...
                        @fit.ind_peak_fit, IG, xdata, yfitdata, LB, UB, options);

            hold on; grid on
            plot(xdata, fit.ind_peak_fit(param_q, xdata));
            legend('Raw data', 'Noise subtracted', 'Initial guess', 'Fit'); legend boxoff
            xlabel('q'); ylabel('Intensity [arb. u.]')
            
            % Fill in the results into output struct:
            fit_param.all.(['q_' num2str(fit_md.q)]) = param_q;
            fit_param.q(j)                  = fit_md.q;
            fit_param.(['rph_q_' num2str(fit_md.q)]) = param_q(1:fit_md.q+1)./sum(param_q(1:fit_md.q+1));
            fit_param.(['noise_level_q_' num2str(fit_md.q)]) = param_q(end);
            data.x.(['q_' num2str(fit_md.q)]) = xdata;
            data.y.(['q_' num2str(fit_md.q)]) = yfitdata;
            
            PD_t(j,1:fit_md.q+1) = param_q(1:fit_md.q+1)./sum(param_q(1:fit_md.q+1));
            
        end
            
        % Preparation of the needed boundary matrices:
        
        [IG, LB, UB, options] = fit.combined_model_prep(fit_md, PD_t);
        
        opt_function = @(parameters) fit.combined_model(parameters, PD_t);
        
        % Fit!
        [solution,result.residual_norm_lsqc,result.residuals,result.exitflag,result.fit_info] = ...
            lsqnonlin(opt_function , IG, LB, UB, options);
        
	plot.combined_model(solution, fit_param, fit_md, PD_t, data)
    
    fit_param.export.IG         = IG;
    fit_param.export.LB         = LB;
    fit_param.export.UB         = UB;
    fit_param.export.PD_t       = PD_t;
    fit_param.export.fit_md     = fit_md;
    fit_param.data              = data;

end
end
