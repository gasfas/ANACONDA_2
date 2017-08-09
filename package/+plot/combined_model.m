function [ output_args ] = combined_model(results, ind_fit_param, fit_md, PD_t, data)
%Visualize the 4th fit model.

parameters  = results(:, 1:3);
PD_old      = results(:, 4:end);

nof_qs      = size(PD_old,1);
max_qpl_1   = size(PD_old, 2);
q_all       = max_qpl_1-nof_qs:max_qpl_1-1;

% loop over all different q's:
for i = 2:nof_qs-1
    q       = q_all(i);
    cur_fit_param = ind_fit_param.all.(['q_' num2str(q)]);

    % The experimental data:
    xdata_exp = data.x.(['q_' num2str(q)]);
    ydata_exp = data.y.(['q_' num2str(q)]);
    % normalizing the data:
    ydata_exp = (ydata_exp - cur_fit_param(end))./cur_fit_param(end - 3);
    
    % The total fits:
    PD_t_i = PD_t(i);
    cur_fit_param(end - 3) = 1;
    
    cur_fit_param(end) = 0;% noise level
    ydata_t_ind = fit.ind_peak_fit(cur_fit_param, xdata_exp);
    % The clusters from mothers:
    mother_fit_param = cur_fit_param;
    mother_fit_param(1:q+1) = results(i, 4:4+q); % the individual peak heights
    mother_fit_param(end-3) = results(i, 3); % The relative peak height of mother
    ydata_m = fit.ind_peak_fit(mother_fit_param, xdata_exp);
    % The clusters from fragments:
    fragment_fit_param = cur_fit_param;
    fragment_fit_param(1:q+1) = cur_fit_param(1:q+1) - mother_fit_param(1:q+1);
    fragment_fit_param(end-3) = 1 - results(i, 3); % The relative peak height of fragment
    ydata_f = fit.ind_peak_fit(fragment_fit_param, xdata_exp);
    % The total cluster signal:
    ydata_t = ydata_m + ydata_f;

    hold on
    subplot(nof_qs-2, 3, 3*i-5), plot(xdata_exp, ydata_exp, 'b.'); hold on
    subplot(nof_qs-2, 3, 3*i-5), plot(xdata_exp, ydata_t, 'k'); hold on
    subplot(nof_qs-2, 3, 3*i-5), plot(xdata_exp, ydata_t_ind, 'r'); hold on
    set(gca, 'XTick', cur_fit_param(end-6):cur_fit_param(end-4):cur_fit_param(end-5)); grid on; xlim([min(xdata_exp) max(xdata_exp)]); xlim([min(xdata_exp) max(xdata_exp)])
    set(gca, 'YTick', []); ylim([min(ydata_t) 1.4*max(ydata_t)])
    subplot(nof_qs-2, 3, 3*i-4), plot(xdata_exp, ydata_m, 'k'); hold on
    set(gca, 'XTick', cur_fit_param(end-6):cur_fit_param(end-4):cur_fit_param(end-5)); grid on; xlim([min(xdata_exp) max(xdata_exp)])
    set(gca, 'YTick', []); ylim([min(ydata_t) 1.4*max(ydata_t)])
    subplot(nof_qs-2, 3, 3*i-3),   plot(xdata_exp, ydata_f, 'k'); hold on
    set(gca, 'XTick', cur_fit_param(end-6):cur_fit_param(end-4):cur_fit_param(end-5)); grid on; xlim([min(xdata_exp) max(xdata_exp)]);
    set(gca, 'YTick', []); ylim([min(ydata_t) 1.4*max(ydata_t)])
    subplot(nof_qs-2, 3, 3*i-5), textul(['$q = ' num2str(q) '$'], 0.5, -0.5, 'k');
    % Now see if we can predict the fragment/mother spectra from the q-1
    % and q+1 spectra:
    
%     For the mother ions:
    if i > 1 
        f_mother = results(i,3);
        p_nucl_m_q = results(i,1);
        rph_prev = results(i-1, 4:4+q-1);
        % The previous group fit is written as the new spectrum by using the probability p_m_q:
        mother_rph_pred = f_mother * [p_nucl_m_q*rph_prev 0] + [0 (1-p_nucl_m_q)*rph_prev];
        mother_fit_param_pred = mother_fit_param;
        mother_fit_param_pred(1:q+1) = mother_rph_pred;
        ydata_f_pred = fit.ind_peak_fit(mother_fit_param_pred, xdata_exp);
        subplot(nof_qs-2, 3, 3*i-4),   plot(xdata_exp, ydata_f_pred, 'r--'); hold on
    end

    % For the fragments:
    if i < nof_qs 
        f_fragment = results(i,3);
        p_evap_m_q = results(i,2);
        rph_q_pl_1 = results(i+1, 4:4+q+1);
        % debug:
%         rph_q_pl_1 = PD_t(i+1,1:q+2) - results(i+1, 4:4+q+1);
        % The previous group fit is written as the new spectrum by using the probability p_m_q:
        fragment_rph_pred = f_fragment * ( p_evap_m_q*rph_q_pl_1(1:end-1) + (1-p_evap_m_q)*rph_q_pl_1(2:end) );
        fragment_fit_param_pred = fragment_fit_param;
        fragment_fit_param_pred(1:q+1) = fragment_rph_pred;
        ydata_f_pred = fit.ind_peak_fit(fragment_fit_param_pred, xdata_exp);
        subplot(nof_qs-2, 3, 3*i-3),   plot(xdata_exp, ydata_f_pred, 'r--'); hold on
    end
end
end

