function [p_peakcenters] = size_to_m2q_corr(fit_md, m2q_data)
% make a general m2q-size index. Sizes go from 1 to the maximum:
	size_range	= [1, max(fit_md.q)];
	m2q_range	= [min(fit_md.m.mass, fit_md.n.mass)-fit_md.range_surplus size_range(2)*max(fit_md.m.mass, fit_md.n.mass)+fit_md.range_surplus] + fit_md.H.mass*fit_md.H.nof;
	[sidecut_y, sidecut_x] = hist.H_1D(m2q_data, hist.bins(m2q_range, fit_md.binsize)); % Make a histogram
	sidecut_y = medfilt1(sidecut_y, fit_md.sidecuts.medfilt_est);
	[xpeaks] = fit.findpeakseries(sidecut_x, sidecut_y, fit_md.sidecuts.MinPeakProminence_est, ...
	fit_md.sidecuts.spacing_min, fit_md.sidecuts.spacing_max, false, false, 'longest');
	peaksizes = (0:length(xpeaks)-1) + round(xpeaks(1)/mean([fit_md.m.mass, fit_md.n.mass]));
	% 		Make a straight line fit (so that it can extrapolate):
	p_peakcenters = polyfit(peaksizes, xpeaks', 1);
% 		figure; plot(peaksizes, xpeaks, 'r'); hold on; plot(peaksizes, polyval(p_peakcentres, peaksizes), 'k')
end