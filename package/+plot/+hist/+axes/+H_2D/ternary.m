function [ h_GraphObj ] = ternary(h_axes, midpoints, Count, GraphObj_md)
% Polar histogram plot, that takes the sin(theta) solid angle into account
% by varying the binsize. The total (C1 + C2 + C3) is normalized to one for every datapoint
% Input:
% axhandle: The handle that the figure will be plotted into
% midpoints	struct, the midpoints in the histogram, stored as
%			midpoints.dim1 and midpoints.dim2 (for x and y, respectively)
% Count		The histogram count matrix
% GraphObj_md	The metadata describing the graphical object.
% Outputs:
% h_GraphObj The handle of the line/scatter Graphical object
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

%% Plot ternary surface
[h_GraphObj] = plot.hist.axes.H_2D.imagesc(h_axes, midpoints, Count, GraphObj_md);
uistack(h_GraphObj, 'bottom')
end