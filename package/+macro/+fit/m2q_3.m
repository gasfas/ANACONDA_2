function  [fit_param] = m2q_3(data_in, metadata_in, det_name, bgr, bgr_md)
% This macro executes m2q fit 3.
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

        % The third m2q fitting model (evaporation model)
    fit_md = metadata_in.macro.fit.m2q.(detname).m2q;

    % Fitting of a set of binary cluster peaks, optimization procedure.
    % preparation:
    all_q = fit_md.q;
    fit_param.q              = NaN*ones(length(all_q),1);
    fit_param.p_evap_q          = NaN*ones(length(all_q),1);
%         
    for j = 1:length(all_q)
        % Step 1: Fetch the (q+1) cluster group info.
        fit_md.q = all_q(j)+1;

        if ~isfield(fit_param, ['q_' num2str(fit_md.q)])
            % If the q+1 (one unit bigger) cluster group has not yet been fitted:
            if isfield(fit_md.opt_3, 'p_evap_q_next')
                % An initial condition is given by user:
                [ fit_md ] = macro.fit.m2q.m2q_fit_calc_centers( fit_md );
                centers_pl_1        = fit_md.centers;
                param_big_q       = [fit_md.opt_3.p_evap_q_next centers_pl_1(1) centers_pl_1(2) mean(diff(centers_pl_1)) 1 1 1 0];
            else %No initial condition is given, so we fit:
                [xdata, yfitdata, ybgr, IG, LB, UB, options] = macro.fit.m2q.ind_peak_fit_prep(fit_md, data_in.h.(detname).m2q, bgr.h.(detname).m2q);

                plot(xdata, yfitdata + ybgr, '+'); hold on;
                plot(xdata, yfitdata, '+');
                plot(xdata, macro.fit.m2q.ind_peak_fit(IG, xdata));
                legend('Raw data', 'Noise subtracted', 'Initial guess')
                plot.textul(['$q = ' num2str(fit_md.q) '$'], 0.1, 0.08, 'k');
                set (gcf, 'Position', [1094         104         810         802])
                set(gca, 'XTick', IG(end-6):IG(end-4):IG(end-5))
                set (gcf, 'Position', [320    64   810   802])
                grid on

                % Fit!
                [param_big_q,result.residual_norm_lsqc,result.residuals,result.exitflag,result.fit_info] = lsqcurvefit( ...
                            @macro.fit.m2q.ind_peak_fit, IG, xdata, yfitdata, LB, UB, options);

                hold on; grid on
                plot(xdata, macro.fit.m2q.ind_peak_fit(param_big_q, xdata));
                legend('Raw data', 'Noise subtracted', 'Initial guess', 'Fit'); legend boxoff
                xlabel('q'); ylabel('Intensity [arb. u.]')
            end
        else
            % If the bigger cluster group has already been fit, we
            % use the data from that instead:
            param_big_q = fit_param.(['q_' num2str(fit_md.q)]);
        end

        % Step 2: project the (larger) q-group fit onto the
        % present spectrum of interest. Go back to current q:
        fit_md.q = all_q(j);
        % set the initial Gaussian and Lorentz broadening as the one
        % from the bigger group fit:
        fit_md.sigma_L = param_big_q(end-1);
        fit_md.sigma_G = param_big_q(end-2);
        % fetch the optimization parameters:
        [xdata, yfitdata, ybgr, IG, LB, UB, options] = macro.fit.m2q.evaporation_model_prep (fit_md, data_in.h.(detname).m2q, bgr.h.(detname).m2q, param_big_q);
        figure;
        plot(xdata, yfitdata + ybgr, '+');hold on;
        plot(xdata, yfitdata, 'r+'); 
        plot(xdata, macro.fit.m2q.evaporation_model ( IG, xdata ));
        legend('Raw data', 'Noise subtracted', 'Initial guess')
        plot.textul(['$q = ' num2str(fit_md.q) '$'], 0.1, 0.08, 'k');
        set (gcf, 'Position', [1094         104         810         802])
        set(gca, 'XTick', IG(end-6):IG(end-4):IG(end-5))
        grid on

        % Fit:
        [result.param,result.residual_norm_lsqc,result.residuals,result.exitflag,result.fit_info] = lsqcurvefit( ...
                    @macro.fit.m2q.evaporation_model, IG, xdata, yfitdata, LB, UB, options);

        % The final peak heights:
        p_evap_q            = result.param(1);
        rph_q_pl_1          = result.param(2:fit_md.q+3); % The relative peak height of the bigger (q+1) cluster group
        rph                 = p_evap_q*rph_q_pl_1(1:end-1) + (1-p_evap_q)*rph_q_pl_1(2:end);                    

        % Fill in the results into output struct:
        fit_param.q(j)               = fit_md.q;
        fit_param.p_evap_q(j,:)         = p_evap_q;
        fit_param.(['rph_q_' num2str(fit_md.q)]) = rph;
        fit_param.(['q_' num2str(fit_md.q,2)]) = [rph result.param(end-6:end)];

        close all;        
        plot(xdata, yfitdata, '*'); hold on
        plot(xdata, fit.evaporation_model(result.param, xdata));
        legend('Data', 'Fit'); legend boxoff
        set (gcf, 'Position', [695 591 833 309])
        set(gca, 'XTick', IG(end-6):IG(end-4):IG(end-5)); grid on
        plot.textul(['$q = ' num2str(fit_md.q) '$'], 0.2, 0.1, 'k');
        plot.textul(['$p_{m, evap}(q) = ' num2str(result.param(1),2) '$'], 0.1, 0.1);
        xlabel('q'); ylabel('Intensity [arb. u.]')
    end

end
end
