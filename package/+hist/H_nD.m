function [Count, midpoints] = H_nD(data, edges, weight)
% This general histogram function creates n-dimensional histogram,
% depending what the dimension of the input data is.
% Inputs:
% data	[n, dim] column array with the values of which the 
%				user wants to have the histogram.
% edges			if dim  == 1; array with the edges of the bin.
% 				if dim > 1; struct with the field:
%					edges.dim1	[m+1, 1] array with the edges of the bin (x)
%					edges.dim2	[l+1, 1] array with the edges of the bin (y)
%					etc. etc...
% weight		[n, 1] (optional) the weight of each datapoint, so a
%				weighted histogram will be returned.
% Output: 
%   Count:		[m, 1] column array with the elements giving the number of points from
%				x_data within the specified x_edges.
%	midpoints:	Column array with the centres of the bins. Same structure as
%				edges
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% Does the user want to calculate a weighted histogram:
if exist('weight', 'var')
	weighted_hist = true;
else
	weighted_hist = false;
end
% what is the dimension of the histogram:
dim = size(data, 2);

% Select the correct histogram:
switch dim
	case 0 % No data given:
		Count		= [];
		midpoints	= [];
	case 1
		if weighted_hist
			[Count, midpoints] = hist.weighted.H_1D(data, weight, edges);
		else
			[Count, midpoints] = hist.H_1D(data, edges);
		end
	case 2
		if weighted_hist
			[Count, midpoints.dim1, midpoints.dim2] = hist.weighted.H_2D(data(:,1), data(:,2), weight, edges.dim1, edges.dim2);
		else
			[Count, midpoints.dim1, midpoints.dim2] = hist.H_2D(data(:,1), data(:,2), edges.dim1, edges.dim2);
		end
	case 3
		if weighted_hist
			[Count, midpoints.dim1, midpoints.dim2, midpoints.dim3] = hist.weighted.H_3D(data(:,1), data(:,2), data(:,3), weight, edges.dim1, edges.dim2, edges.dim3);
		else
			[Count, midpoints.dim1, midpoints.dim2, midpoints.dim3] = hist.H_3D(data(:,1), data(:,2), data(:,3), edges.dim1, edges.dim2, edges.dim3);
		end
end
	
end

