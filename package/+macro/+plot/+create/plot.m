function [h_figure, h_axes, h_GraphObj, exp] = plot(exp, plot_md)
% This function creates a plot figure, axes and Graphical object, 
% with the specified styles in a new figure.
% Inputs:
% plot_md		The metadata struct, with optional fields: 
% 				fig (Figure properties)
%				axes (axes properties)
%				hist (histogram properties)
% Outputs:
% h_figure	The Figure handle
% h_ax		The Axes handle
% h_GraphObj The Graphical Object handle

% Create the new figure:
h_figure	= macro.plot.create.fig(plot_md.figure);
% Then create the new axes:
h_axes		= macro.plot.create.ax(h_figure, plot_md.axes);

if isfield(plot_md, 'cond')
	% Calculate the filter from a condition:
	[e_filter, exp]	= macro.filter.conditions_2_filter(exp, plot_md.cond);
	% Calculate the histogram with the filter:
	histogram	= macro.hist.create.hist(exp, plot_md.hist, e_filter);
else
	% Calculate the histogram:
	histogram	= macro.hist.create.hist(exp, plot_md.hist);
end

% And plot the Graphical Object in it:
h_GraphObj	= macro.hist.create.GraphObj(h_axes, histogram, plot_md.GraphObj);

end