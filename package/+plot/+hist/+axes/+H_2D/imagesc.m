function [h_GraphObj] = imagesc(h_axes, midpoints, Count, GraphObj_md)
% This function plots a 2-dimensional histogram of given x- and y-data.
% Input:
% h_axes:    The axis handle to plot the figure into
% midpoints		since dim ==2, struct with the field:
%					midpoints.dim1	[m, 1] array with the edges of the bin (x)
%					midpoints.dim2	[l, 1] array with the edges of the bin (y).
% Count			[m,l] array with the 2D histogram.
% Output:
% h_GraphObj	The Graphical Object handle (image)
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% If y-smoothening is requested:
if exist('GraphObj_md', 'var')
	if isfield(GraphObj_md, 'medfilt_Y_radius')
		Count = medfilt2(Count, [1 GraphObj_md.medfilt_Y_radius]);
	end
end

if ~isempty(Count)
	h_GraphObj = imagesc(h_axes, midpoints.dim1([1 end]), midpoints.dim2([1 end]), permute(Count, [2 1]), 'Parent', h_axes);
else
	h_GraphObj = imagesc(h_axes, [0 1], [0 1], [0]);
end
set(h_axes, 'Layer', 'top'); 
end
