function [xdata, yfitdata, ybgr, fit_md] = bin_fit_data( fit_md, m2q, m2q_bgr)

%The function that prepares the binning of the data to be fitted.
% fetch centers:
[ fit_md ] = macro.fit.m2q.m2q_fit_calc_centers( fit_md );

% Binning the data:
binsize             = fit_md.binsize;
hist_range          = [min(fit_md.pure_masses) - fit_md.range_surplus, max(fit_md.pure_masses) + fit_md.range_surplus];
bins                = hist_range(1):binsize:hist_range(2);
[m2q_hist, ~, mid]  = hist.histcn(m2q, bins);
xdata               = cell2mat(mid)';
ydata_raw           = m2q_hist;

if fit_md.bgr_subtr.ifdo
    % subtracting the background, by using a background measurement:
    [ybgr_unscaled, ~, mid]= hist.histcn(m2q_bgr, bins);
    x_bgrdata           = cell2mat(mid)';
    sorted_ybgr         = sort(ybgr_unscaled);
    sorted_ydata        = sort(ydata_raw);
    fit_md.noise_level  = mean(sorted_ydata(1:floor(fit_md.rel_noise_hits*length(xdata))));
    bgr_level           = mean(sorted_ybgr(1:floor(fit_md.rel_noise_hits*length(xdata))));
    subtraction_factor  = fit_md.bgr_subtr.factor;
    ybgr                = subtraction_factor*ybgr_unscaled;
    
else
    ybgr                = 0;
end
ydata               = ydata_raw - ybgr;
% plot(xdata, ydata_raw, 'r'); hold on; plot(xdata, ybgr, 'k'); plot(xdata, ydata, 'b')
% picking the noise bins:
sorted_ydata        = sort(ydata);
fit_md.noise_level  = mean(sorted_ydata(1:floor(fit_md.rel_noise_hits*length(xdata))));
% background subtraction
yfitdata        = ydata - fit_md.noise_level;

end

