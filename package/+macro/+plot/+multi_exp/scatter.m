function [h_figure, h_axes, h_GraphObj, exp] = scatter(exps, mds, plot_md, x_pointer, y_pointer, c_pointer)
% Plot 2D scatter plot of multiple experiments.
% Usage: If one would want to know the behavior of a measured value as the 
% function of two experiment variables (e.g. photon energy and nozzle
% temperature), This function can be used.
% Inputs:
% exps		Struct containing the multiple experimental data as subfields.
% exps		Struct containing the multiple experimental metadata as subfields.
% plot_md	The plot metadata (excluding hist). Defining xlabels, colormap, etc.
% x_pointer string that points to the value that gives the x-value in the
%			scatter plot
% y_pointer string that points to the value that gives the y-value in the
%			scatter plot
% c_pointer string that points to the value that gives the c-value in the
%			scatter plot

% loop over all experiments:
expnames = fieldnames(exps);
try expnames(find(strcmp(expnames, 'info'))) = []; end

X			= NaN * zeros(length(expnames), 1);
Y			= NaN * zeros(length(expnames), 1);
C			= NaN * zeros(length(expnames), 1);

% Apply conditions if they are defined:


for i = 1:length(expnames)
	expname = expnames{i};
	exp		= exps.(expname);
	exp_md	= mds.(expname);
	X(i)		= eval(x_pointer);
	Y(i)		= eval(y_pointer);
	C(i)	= eval(c_pointer);
end

if isfield(plot_md, 'Graphobj_md')
	GraphObj_md = plot_md.GraphObj;
else
	GraphObj_md = [];
end

if ~isfield(GraphObj_md, 'color_ low')
GraphObj_md.color_low	= [1 1 1]; % White background color
end
if ~isfield(GraphObj_md, 'color_high')
GraphObj_md.color_high		= [1 0 0];
end
if ~isfield(GraphObj_md, 'dotsize')
GraphObj_md.dotsize		= 100;
end
Int_color = repmat(GraphObj_md.color_low, numel(C), 1) - repmat(C(:)./ max(max(C)), 1, 3) .* (repmat(GraphObj_md.color_low-GraphObj_md.color_high, numel(C), 1));

try h_figure	= macro.plot.create.fig(plot_md.fig); catch h_figure = figure; end
h_axes = axes(h_figure);
h_GraphObj		= scatter(h_axes, X, Y, GraphObj_md.dotsize, Int_color, 'filled');

try h_axes = general.handle.fill_struct(h_axes, plot_md.axes); end