function [h_GraphObj] = Y_mean(h_axes, midpoints, Count, GraphObj_md)
% This function plots an average Y-value of a 2D histogram of given x- and 
% y-data.
% Input:
% h_axes:    The axis handle to plot the figure into
% midpoints		since dim ==2, struct with the field:
%					midpoints.dim1	[m, 1] array with the edges of the bin (x)
%					midpoints.dim2	[l, 1] array with the edges of the bin (y).
% Count			[m,l] array with the 2D histogram.
% Output:
% h_GraphObj	The Graphical Object handle (Patch)
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

[h_GraphObj] = plot.hist.axes.H_2D.Y_line(h_axes, midpoints, Count, GraphObj_md, 'mean');


end