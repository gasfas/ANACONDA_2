function [avg, stddv] = H_2D(Count, y_values)
% This function returns the average value at each y-value of a given
% histogram. 
% Inputs:
%	Count:			[n, m] matrix with the 2D histogram
%	y_values:		[m, 1] column array with the y-value of each histogram column.
% Output: 
%   avg:			[m, 1] The average value at corresponding x_value.
%   stddv:			[m, 1] The standard deviation at corresponding x_value (as defined in MATLAB).
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

	total_nof_hits = (sum(Count,2,'omitnan'));
	if ~isempty(Count)
		% calculate average, ignoring NaN's:
		Count(isnan(Count)) = 0;
		avg = Count*y_values./total_nof_hits;
	else
		avg = NaN*ones(size(y_values));
	end
		
if	nargout > 1% User wants to know standard deviation as well:
	% create a matrix with mean values:
	avg_m	= repmat(avg, 1, size(Count,2));
	diff	= avg_m - repmat(y_values', size(Count,1),1);
	stddv	= sqrt(sum(diff.^2.*Count, 2)./(total_nof_hits));
	
end
end