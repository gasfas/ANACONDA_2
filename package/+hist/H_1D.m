function [Count, x_midpoints] = H_1D(x_data, x_edges)
% [Count, x_midpoints] = H_1D(x_data, x_edges)
% This function creates a one-dimensional histogram of unstructured data.
% Inputs:
%	x_data:		[n, 1] column array with the values of which the 
%				user wants to have the histogram.
%	x_edges		[m+1, 1] array with the edges of the bin.
% Output: 
%   Count:		[m, 1] column array with the elements giving the number of points from
%				x_data within the specified x_edges.
%	x_midpoints: [m, 1] column array with the centres of the bins.
% TODO: Implement MEX ndhist (faster):
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

[Count, ~, mid]= hist.histcn(double(x_data), x_edges);
x_midpoints           = cell2mat(mid);
if length(Count) ~= length(x_midpoints)
	% We use the slow version:
	[Count, edges] = histcounts(x_data, x_edges);
	x_midpoints = hist.edges_2_mids(edges);
end
% For some strange reason, the histogram function transposes when x_data is
% empty:
if isempty(x_data)
	Count = transpose(Count);
end
