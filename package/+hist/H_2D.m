function [Count, x_midpoints, y_midpoints] = H_2D(x_data, y_data, x_edges, y_edges)
% [Count, x_midpoints, y_midpoints] = H_2D(x_data, y_data, x_midpoints, y_midpoints)
% This function creates a two-dimensional histogram of unstructured data.
%  Inputs:
%	x_data:		[n, 1] column array with the values of which the 
%				user wants to have the histogram.
%	x_edges		[m+1, 1] array with the edges of the bin (x).
%	y_edges		[l+1, 1] array with the edges of the bin (y).
% Output: 
%   Count:		[m, 1] column array with the elements giving the number of points from
%				x_data within the specified x_edges.
%	x_midpoints: [m, 1] column array with the centres of the bins (x).
%	y_midpoints: [m, 1] column array with the centres of the bins (y).
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if isempty(x_data)
	Count = zeros(length(x_edges)-1, length(y_edges)-1);
	x_midpoints = x_edges(1:end-1)+diff(x_edges)/2;
	y_midpoints = y_edges(1:end-1)+diff(y_edges)/2;
else
	[Count, ~, mid]= hist.histcn([x_data y_data], x_edges, y_edges);
    

	x_midpoints           = cell2mat(mid(1));
	y_midpoints           = cell2mat(mid(2));

    save('histout.mat','Count','x_midpoints','y_midpoints')
	if any(size(Count) ~= [length(x_midpoints), length(y_midpoints)])
		warning ('hist.histnc failed')
		Count		= Count(1:length(x_midpoints), 1:length(y_midpoints));
	end

end

