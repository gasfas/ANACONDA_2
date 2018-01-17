function [centre] = find_sidecut_centre(fit_md, xdata, yfitdata, centre_est)
% This function calculates the centre of a peak, from an initial estimation.
% Applied to mass-to-charge histogram. 
yfitdata = medfilt1(yfitdata, fit_md.sidecuts.medfilt_findpeak);
[a, centres] = findpeaks(yfitdata, xdata, 'MinPeakProminence', fit_md.sidecuts.MinPeakProminence_findpeak);

% Pick the nearest peak:
[val, idx] = min(abs((centres - centre_est)./a));
% If a proper centre is found:
if ~isempty(centres)
	centre = centres(idx);
else % Otherwise, the estimated value is used.
	centre = centre_est;
end

% 
% figure; plot(xdata, yfitdata, 'b'); hold on; 
% plot(centres,a, 'r*'); plot.vline(centre_est, 'r')
% plot.vline(centre, 'k')
end
