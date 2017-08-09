function  [fit_param] = m2q_1(data_in, metadata_in, det_name, bgr, bgr_md)
% This macro executes m2q fit 1.
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
    
   % The first m2q fitting model
    fit_md = metadata.fit.(detname).m2q;
    % Fitting of a set of binary cluster peaks, optimization procedure
    % preparation:
    all_q = fit_md.q;
    fit_param.q              = NaN*ones(length(all_q),1);
    fit_param.result         = NaN*ones(length(all_q),8);
    fit_param.IG             = NaN*ones(length(all_q),8);   
    fit_param.LB             = NaN*ones(length(all_q),8);  
    fit_param.UB             = NaN*ones(length(all_q),8); 

    for j = 1:length(all_q)

        fit_md.q = all_q(j);
        [xdata, yfitdata, ybgr, IG, LB, UB, options] = macro.fit.m2q.binomial_prep(fit_md, exp.h.(detname).m2q, bgr.h.(detname).m2q);
        close all
        plot(xdata, yfitdata + ybgr, '+'); hold on;
        plot(xdata, yfitdata, '+');
        plot(xdata, macro.fit.m2q.binomial_peaks(IG, xdata));
        legend('Raw data', 'Noise subtracted', 'Initial guess')
        plot.textul(['$q = ' num2str(fit_md.q) '$'], 0.1, 0.08, 'k');
        set (gcf, 'Position', [1094         104         810         802])
        set(gca, 'XTick', IG(1):IG(3):IG(2))

        % Fit!
        [result.param,result.residual_norm_lsqc,result.residuals,result.exitflag,result.fit_info] = lsqcurvefit( ...
                    @macro.fit.m2q.binomial_peaks, IG, xdata, yfitdata, LB, UB, options);

        % Fill in the results into output struct:
        fit_param.q(j)               = fit_md.q;
        fit_param.result(j,:)        = result.param;
        fit_param.IG(j,:)            = IG;
        fit_param.LB(j,:)            = LB;
        fit_param.UB(j,:)            = UB;
        fit_param.p_m_q(j)           = fit_param.result(j,5);

        hold on; grid on
        plot.textul(['$p_m = ' num2str(fit_param.result(j,5),2) '$'], 0.18, 0.05, 'k');
        plot(xdata, macro.fit.m2q.binomial_peaks(fit_param.result(j,:), xdata));
        legend('Raw data', 'Noise subtracted', 'Initial guess', 'Fit'); legend boxoff
        xlabel('q'); ylabel('Intensity [arb. u.]')
    end

end
end
