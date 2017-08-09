function  [fit_param] = m2q_2(data_in, metadata_in, det_name, bgr, bgr_md)
% This macro executes m2q fit 2.
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

     fit_md = metadata_in.macro.fit.m2q.(detname).m2q;

    % Fitting of a set of binary cluster peaks, optimization procedure.
    % preparation:
    all_q = fit_md.q;
    fit_param.q              = NaN*ones(length(all_q),1);
    fit_param.p_m_q          = NaN*ones(length(all_q),1);
%         
    for j = 1:length(all_q)
        % Step 1: Fetch the q minus one cluster group info.
        fit_md.q = all_q(j)-1;

        if ~isfield(fit_param, ['q_' num2str(fit_md.q)])
            % If the previous (one unit smaller) cluster group has not
            % been fitted:

            if isfield(fit_md.opt_2, 'p_m_q_prev')
                % An initial condition is given by user:
                [ fit_md ] = macro.fit.m2q.m2q_fit_calc_centers( fit_md );
                centers_prev        = fit_md.centers;
                param_small_q       = [fit_md.opt_2.p_m_q_prev centers_prev(1) centers_prev(2) mean(diff(centers_prev)) 1 1 1 0];
            else %No initial condition is given, so we fit:
                [xdata, yfitdata, ybgr, IG, LB, UB, options] = macro.fit.m2q.ind_peak_fit_prep(fit_md, data_in.h.(detname).m2q, bgr.h.(detname).m2q);

%                     plot(xdata, yfitdata + ybgr, '+'); hold on;
%                     plot(xdata, yfitdata, '+'); hold on
%                     plot(xdata, macro.fit.m2q.ind_peak_fit(IG, xdata));
%                     legend('Raw data', 'Noise subtracted', 'Initial guess')
%                     plot.textul(['$q = ' num2str(fit_md.q) '$'], 0.1, 0.08, 'k');
%                     set (gcf, 'Position', [1094         104         810         802])
%                     set(gca, 'XTick', IG(end-6):IG(end-4):IG(end-5))
%                     set (gcf, 'Position', [320    64   810   802])
%                     grid on
%                     legend('Data'); legend boxoff
%                     xlabel('m/q'); ylabel('Intensity [arb. u.]')
                % Fit!
                [param_small_q,result.residual_norm_lsqc,result.residuals,result.exitflag,result.fit_info] = lsqcurvefit( ...
                            @macro.fit.m2q.ind_peak_fit, IG, xdata, yfitdata, LB, UB, options);
% 
%                     hold on; grid on
%                     plot(xdata, macro.fit.m2q.ind_peak_fit(param_small_q, xdata));
%                     plot.ind_peaks(param_small_q, xdata)
%                     legend('Raw data', 'Noise subtracted', 'Initial guess', 'Fit'); legend boxoff
%                     legend('Data', 'Fit'); legend boxoff
%                     xlabel('m/q'); ylabel('Intensity [arb. u.]')
            end
        else
            % If the previous cluster group has already been fit, we
            % use the data from that instead:
            param_small_q = fit_param.(['q_' num2str(fit_md.q)]);
        end

        % Step 2: project the previous (smaller) q-group fit onto the
        % present spectrum of interest:
        fit_md.q = all_q(j);
        % set the initial Gaussian and Lorentz broadening as the one
        % from the previous fit:
        fit_md.sigma_L = param_small_q(end-1);
        fit_md.sigma_G = param_small_q(end-2);
        % fetch the optimization parameters:
        [xdata, yfitdata, ybgr, IG, LB, UB, options] = macro.fit.m2q.nucleation_model_prep (fit_md, data_in.h.(detname).m2q, bgr.h.(detname).m2q, param_small_q);

        figure;
        plot(xdata, yfitdata + ybgr, '+');hold on;
        plot(xdata, yfitdata, 'r+'); 
        plot(xdata, macro.fit.m2q.nucleation_model ( IG, xdata ));
        legend('Raw data', 'Noise subtracted', 'Initial guess')
        plot.textul(['$q = ' num2str(fit_md.q) '$'], 0.1, 0.08, 'k');
        set (gcf, 'Position', [1094         104         810         802])
        set(gca, 'XTick', IG(end-6):IG(end-4):IG(end-5))
        grid on

        % Fit:
        [result.param,result.residual_norm_lsqc,result.residuals,result.exitflag,result.fit_info] = lsqcurvefit( ...
                    @macro.fit.m2q.nucleation_model, IG, xdata, yfitdata, LB, UB, options);

        % The final peak heights:
        p_m_q           = result.param(1);
        rph_prev        = result.param(2:fit_md.q+1); % The relative peak height of the previous cluster group
        rph             = [p_m_q*rph_prev 0] + [0 (1-p_m_q)*rph_prev];                    

        % Fill in the results into output struct:
        fit_param.q(j)               = fit_md.q;
        fit_param.p_m_q(j,:)         = p_m_q;
        fit_param.(['rph_q_' num2str(fit_md.q)]) = rph;
        fit_param.(['q_' num2str(fit_md.q,2)]) = [rph result.param(end-6:end)];
% 
        close all;        
        plot(xdata, yfitdata, '*'); hold on
        plot(xdata, macro.fit.m2q.nucleation_model(result.param, xdata));
        legend('Data', 'Fit'); legend boxoff
        set (gcf, 'Position', [695 591 833 309])
        set(gca, 'XTick', IG(end-6):IG(end-4):IG(end-5)); grid on
        plot.textul(['$q = ' num2str(fit_md.q) '$'], 0.4, 0.7, 'k');
        plot.textul(['$p_m(q) = ' num2str(result.param(1),2) '$'], 0.5, 0.7);
        xlabel('q'); ylabel('Intensity [arb. u.]')
%             sf = 0.7;
% %             previous, ammonia nucleation:
%             NH3_nucl = fit_param.q_5;
%             NH3_nucl(7:8) = NH3_nucl(7:8)+ fit_md.m.mass;
%             NH3_nucl(end-3:end) = result.param(end-3:end);
%             plot(xdata, sf*p_m_q*macro.fit.m2q.nucleation_model(NH3_nucl, xdata), 'b');
% %             previous, water nucleation:
%             H2O_nucl = fit_param.q_5
%             H2O_nucl(7:8) = H2O_nucl(7:8) + fit_md.n.mass;
%             NH3_nucl(end-3:end) = result.param(end-3:end);
%             plot(xdata, sf*(1-p_m_q)*macro.fit.m2q.nucleation_model(H2O_nucl, xdata), 'r');

    end

end
end
