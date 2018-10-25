function [Count] = H_1D_row(x_data, patterns)
% [Count, x_midpoints] = H_1D(x_data, x_edges)
% This function creates a one-dimensional histogram of unstructured data.
% Instead of histogramming a value, it histograms an array of values in one
% row. 
% Inputs:
% x_data	column array with the values at which the 
%			user wants to see the counts.
% Count		2D-array with the elements giving the number of points from
%			x_data and y_data, nearest to a certain point specified in x_range and
%			y_range.
%	
%	make sure the x_ and y_range are in at least part of the range of the data.
%   z_data could be used as an weigh factor matrix: if not, just use a number as
%   input (one).
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% recognize which patterns can be detected where:
[~, locb] = ismember(x_data, patterns, 'rows');
% Count how often a pattern is seen:
edges = 0.5:size(patterns, 1)+0.5;
Count = hist.H_1D(locb, edges);
end
