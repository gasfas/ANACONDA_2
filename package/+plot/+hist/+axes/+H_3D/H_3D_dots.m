function [ hLine ] = H_3D_dots(ax, hist, x, y, z, color, dotsize, markertype)
% This function enables the user to plot round circles, where the circle's
% color scales up with the a certain value, z.
%This function visualizes a double coincidence histogram in dots of the
%specified locations x and y.

% color:    The RGB value for the color in which the intensity should show.

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
	
hLine = plot_dots(ax, x, y, z, hist, dotsize, markertype, color);
end

function hLine = plot_dots(ax, xlabels, ylabels, zlabels, Ilabels, dotsize, markertype, color)
	hLine = scatter3(ax, xlabels, ylabels, zlabels, dotsize, 'filled', markertype);
	hLine.CData = plot.I_2_RGB(Ilabels, [1 1 1], color);
end