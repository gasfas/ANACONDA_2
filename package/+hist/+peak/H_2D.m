function [y_peak, FWHM] = H_2D(histgr, y_values)
% This function returns the value of highest intensity at each y-value of a given
% histogram. 
% Inputs:
%	histgr:			[n, m] matrix with the 2D histogram
%	xy_values:		[m, 1] column array with the y-value of each histogram column.
% Output: 
%   y_peak:			[m, 1] The peak value at corresponding x_value.
%   FWHM:			[m, 1] The Full Width Half Maximum at corresponding x_value.
	total_nof_hits = (sum(histgr,2,'omitnan'));
	if ~isempty(histgr)
		[I_peak, loc] = max(histgr,[], 2,'omitnan');
		y_peak = y_values(loc);
		y_peak(total_nof_hits == 0) = NaN;
	else
		y_peak = NaN*ones(size(y_values));
	end
	
if	nargout > 1% User wants to know standard deviation as well:
	% create a matrix with mean values:
	[FWHM.below, FWHM.above] = general.matrix.FWHM_Y_peak(histgr, y_values, loc, I_peak);
	
end
end