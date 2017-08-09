function [Count, x_midpoints, y_midpoints, z_midpoints] = H_3D(x_data, y_data, z_data, x_edges, y_edges, z_edges)
% [Count, x_midpoints, y_midpoints, z_midpoints] = H_3D(x_data, y_data, z_data, x_midpoints, y_midpoints, z_midpoints)
% This function creates a three-dimensional histogram of unstructured data.
%	x_data:		[n, 1] column array with the values of which the 
%				user wants to have the histogram.
%	x_edges		[m+1, 1] array with the edges of the bin (x).
%	y_edges		[l+1, 1] array with the edges of the bin (y).
%	z_edges		[k+1, 1] array with the edges of the bin (z).
% Output: 
%   Count:		[m, 1] column array with the elements giving the number of points from
%				x_data within the specified x_edges.
%	x_midpoints: [m, 1] column array with the centres of the bins (x).
%	y_midpoints: [l, 1] column array with the centres of the bins (y).
%	z_midpoints: [k, 1] column array with the centres of the bins (z).

[Count, ~, mid]= hist.histcn([x_data y_data z_data], x_edges, y_edges, z_edges);

x_midpoints           = cell2mat(mid(1));
y_midpoints           = cell2mat(mid(2));
z_midpoints           = cell2mat(mid(3));

if any(size(Count) ~= [length(x_midpoints), length(y_midpoints), length(z_midpoints)])
	[Count, x_midpoints, y_midpoints, z_midpoints] = hist.H_3D(x_data, y_data, z_data, x_midpoints, y_midpoints, z_midpoints);
end
	
end

