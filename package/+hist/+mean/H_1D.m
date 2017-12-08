function [avg, stddv] = H_1D(Count, x_values)
% This function returns the average value of a one-dimensional histogram.
% Inputs:
%	Count:			[m, 1] matrix with the 2D histogram
%	x_values:		[m, 1] column array with the x-value of each histogram bin.
% Output: 
%   avg:			float, The average value at corresponding x_value.
%   stddv:			float, The standard deviation around the mean (as defined in MATLAB).

	total_nof_hits = (sum(Count,1,'omitnan'));
	if ~isempty(Count)
		% calculate average, ignoring NaN's:
		Count(isnan(Count)) = 0;
		avg = (Count')*(x_values)./total_nof_hits;
	else
		avg = NaN;
	end
		
if	nargout > 1% User wants to know standard deviation as well:
	% create a matrix with mean values:
	error('TODO')
% 	avg_m	= repmat(avg, 1, size(Count,1));
% 	diff	= avg_m - repmat(x_values', size(Count,1),1);
% 	stddv	= sqrt(sum(diff.^2.*Count, 2)./(total_nof_hits));
	
end
end