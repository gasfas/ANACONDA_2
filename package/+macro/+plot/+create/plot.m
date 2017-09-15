function [h_figure, h_axes, h_GraphObj, exp] = plot(varargin)
% This function creates a plot figure, axes and Graphical object, 
% with the specified styles in a new figure.
% Inputs:
% handle		(optional) handle of a figure or axes to plot into.
% exp			The experimental data.
% plot_md		The metadata struct, with optional fields: 
% 				fig (Figure properties)
%				axes (axes properties)
%				hist (histogram properties)
% Outputs:
% h_figure	The Figure handle
% h_ax		The Axes handle
% h_GraphObj The Graphical Object handle

if ishandle(varargin{1})
	handle	= varargin{1};
	exp		= varargin{2};
	plot_md	= varargin{3};
	if isgraphics(handle, 'Axes')
		h_axes = handle;
		h_figure = h_axes.Parent;
	elseif isgraphics(handle, 'Figure')
		h_figure = handle;
	else
		error('no valid handle given')
	end
else 
	exp		= varargin{1};
	plot_md	= varargin{2};
end

% Create the new figure:
if ~exist('h_figure', 'var')
	h_figure	= macro.plot.create.fig(plot_md.figure);
else
	h_figure	= general.handle.fill_struct(h_figure, plot_md.figure);
end
% Then create the new axes:
if ~exist('h_axes', 'var')
	h_axes		= macro.plot.create.ax(h_figure, plot_md.axes);
else
	h_axes	= general.handle.fill_struct(h_axes, plot_md.axes);
end

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