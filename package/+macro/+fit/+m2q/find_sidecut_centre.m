function [yfitdata, m2q_cut_centre, p_peakcenters, peak_m2q, peak_q] = find_sidecut_centre(fit_md, xdata, yfitdata, p_peakcenters, peak_m2q, peak_q)
% This function calculates the centre of a peak, from an initial estimation.
% Applied to mass-to-charge histogram. 
yfitdata = medfilt1(yfitdata, fit_md.sidecuts.medfilt_findpeak);

% We calculate the estimate:
centre_est = polyval(p_peakcenters, fit_md.q);
% and find the nearest peak to that:
[a, centres] = findpeaks(yfitdata, xdata, 'MinPeakProminence', fit_md.sidecuts.MinPeakProminence_findpeak);

% Pick the nearest peak:
[val, idx] = min(abs((centres - centre_est)./a));

if ~isempty(centres) % If a proper centre is found:
	m2q_cut_centre = centres(idx);
	% Add this value to the found peaks, for a better linear fit estimation next time:
	if any(peak_q == fit_md.q)
		peak_m2q(peak_q == fit_md.q)	= m2q_cut_centre;
	else 
		peak_m2q	= [peak_m2q; m2q_cut_centre];
		peak_q		= [peak_q fit_md.q];
	end
	p_peakcenters = polyfit(peak_q, peak_m2q', 1);

else % Otherwise, the estimated value is used.
	m2q_cut_centre = centre_est;
end

yfitdata(xdata < (m2q_cut_centre - fit_md.sidecuts.m2q_width)) = 0;
yfitdata(xdata > (m2q_cut_centre + fit_md.sidecuts.m2q_width)) = 0;

% 
% figure; plot(xdata, yfitdata, 'b'); hold on; 
% plot(centres,a, 'r*'); plot.vline(centre_est, 'r')
% plot.vline(centre, 'k')
end
