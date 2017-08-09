function [avg, stddv] = H_2D(histgr, y_values)
% This function returns the average value at each y-value of a given
% histogram. 
% Inputs:
%	histgr:			[n, m] matrix with the 2D histogram
%	xy_values:		[m, 1] column array with the y-value of each histogram column.
% Output: 
%   avg:			[m, 1] The average value at corresponding x_value.
%   stddv:			[m, 1] The standard deviation at corresponding x_value (as defined in MATLAB).
	total_nof_hits = (sum(histgr,2,'omitnan'));
	if ~isempty(histgr)
		avg = histgr*y_values./total_nof_hits;
	else
		avg = NaN*ones(size(y_values));
	end
		
if	nargout > 1% User wants to know standard deviation as well:
	% create a matrix with mean values:
	avg_m	= repmat(avg, 1, size(histgr,2));
	diff	= avg_m - repmat(y_values', size(histgr,1),1);
	stddv	= sqrt(sum(diff.^2.*histgr, 2)./(total_nof_hits-1));
	
end
end