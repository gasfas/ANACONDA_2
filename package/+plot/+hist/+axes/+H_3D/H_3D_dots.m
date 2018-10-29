function [ hLine ] = H_3D_dots(h_axes, hist, x, y, z, color, dotsize, markertype)
% This function enables the user to plot round circles, where the circle's
% color scales up with the a certain value, z.
% h_axes	the axes handle of the plot
% hist		The histogram matrix
% x			The x midpoints
% y			The y midpoints
% z			The z midpoints
% color		the colors the dots should show
% dotsize	The size of the plotted dots
% markertype string specifying the marker type. Options: see plot help
% Outputs:
% hLine		The handle of the line/scatter object
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se
% color:    The RGB value for the color in which the intensity should  be shown.


% define default values if values are not specified:
if ~exist('color', 'var')
	color = [0 0 0];
end
if ~exist('dotsize', 'var')
	dotsize = 10;
end
if ~exist('markertype', 'var')
	markertype = 'o';
end
	
hLine = plot_dots(h_axes, x, y, z, hist, dotsize, markertype, color);
end

function hLine = plot_dots(h_axes, xlabels, ylabels, zlabels, Ilabels, dotsize, markertype, color)
	hLine = scatter3(h_axes, xlabels, ylabels, zlabels, dotsize, 'filled', markertype);
	hLine.CData = plot.I_2_RGB(Ilabels, [1 1 1], color);
end