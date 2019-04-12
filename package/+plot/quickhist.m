function [h_figure, h_axes, h_GraphObj, plot_md] = quickhist(varargin)
% This function makes a quick histogram of the given data. The user can
% supply plot preferences through name value combinations.
% Inputs:
%	Input 1		is assumed the data. number of columns=number of dimensions
%	Input 2*n	is the name of the plot preference. e.g. 'axes.Type'
%				if the name plot_md is given, the entire plot_md is
%				replaced
%	Input 2*n+1	is the value of the plot preference. e.g. 'polaraxes'
%
% Example:
% plot.quickhist([1; 1.1; 1.5; 1.3], 'hist.Range', [0 3])
% Will plot these for datapoints, with the histogram limits between 0 and
% 3.
% 
% Note: plot.quickhist(fig, .....) will plot the figure in the appointed figure
% Note: plot.quickhist(ax, .....) will plot the figure in the appointed axes
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

nargin_act = nargin;
%% Fetch data/metadata:
plot_md = struct('figure', [], 'axes', [], 'hist', [], 'GraphObj', []);
if general.handle.isfigure(varargin{1})
	h_figure = varargin{1};
	varargin = varargin(2:end);
	nargin_act = nargin_act - 1;
end
if general.handle.isaxes(varargin{1})
	h_axes = varargin{1};
	h_figure = h_axes.Parent;
	varargin = varargin(2:end);
	nargin_act = nargin_act - 1;
end

i = nargin_act;
while i > 1
	name	= varargin{i-1};
	value	= varargin{i};
		if strcmpi(name, 'plot_md')
			plot_md = general.struct.catstruct(plot_md, value);
		else
			plot_md = general.struct.setsubfield(plot_md, name, value);
		end
	i = i - 2;
end
data		= varargin{1}; 
plot_md.hist.dim = general.matrix.nof_dims(data);

%% Make the plot:
if ~exist('h_figure', 'var')
	plot_md.figure		=  metadata.create.plot.figure_from_defaults(plot_md.figure);
	% Create the new figure:
	h_figure	= macro.plot.create.fig(plot_md.figure);
end
if ~exist('h_axes', 'var')
	plot_md.axes		=  metadata.create.plot.axes_from_defaults(plot_md.axes, plot_md.hist.dim);
	% Then create the new axes:
	h_axes		= macro.plot.create.ax(h_figure, plot_md.axes);
end

% Fill all the other metadata values with defaults:
plot_md.GraphObj	=  metadata.create.plot.GraphObj_from_defaults(plot_md.GraphObj, plot_md.hist.dim);
plot_md				=  metadata.create.plot.hist_from_data(plot_md, data);

% Calculate the histogram:
midpoints = hist.bins(plot_md.hist.Range, plot_md.hist.binsize);
[histogram.Count, histogram.midpoints] = hist.H_nD(data, midpoints);

% And plot the Graphical Object in it:
h_GraphObj	= macro.hist.create.GraphObj(h_axes, histogram, plot_md.GraphObj);
