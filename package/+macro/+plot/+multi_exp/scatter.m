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

if isfield(plot_md, 'GraphObj')
	GraphObj_md = plot_md.GraphObj;
else
	GraphObj_md = [];
end

if ~isfield(GraphObj_md, 'color_low')
GraphObj_md.color_low	= [1 1 1]; % White background color
end
if ~isfield(GraphObj_md, 'color_high')
GraphObj_md.color_high		= [1 0 0];
end
if ~isfield(GraphObj_md, 'dotsize')
GraphObj_md.dotsize		= 100;
end
Int_color = repmat(GraphObj_md.color_low, numel(C), 1) - repmat((C(:)-min(C(:)))./(max(C(:)) - min(C(:))), 1, 3) .* (repmat(GraphObj_md.color_low-GraphObj_md.color_high, numel(C), 1));

try h_figure	= macro.plot.create.fig(plot_md.figure); catch h_figure = figure; end
try h_axes		= macro.plot.create.ax(h_figure, plot_md.axes); catch h_axes = axes(h_figure); end
h_GraphObj		= scatter(h_axes(1), X, Y, GraphObj_md.dotsize, Int_color, 'filled');

try h_figure = general.handle.fill_struct(h_figure, plot_md.figure); end
try h_GraphObj = general.handle.fill_struct(h_GraphObj, plot_md.GraphObj); end

% Plot surface in background:
if general.struct.probe_field(GraphObj_md, 'ifdo.Delaunay')
	% Delaunay triangulation:
	tri		= delaunay(X, Y);  
	tr		= triangulation(tri, X, Y, C);
	hold on
    h_GraphObj(2) = trisurf(tr);
	% Plot the surface in the background:
% 	h_GraphObj(2)= trisurf(tri, X, Y, C);
	view(0,90)
	uistack(h_GraphObj(2), 'bottom')
	h_GraphObj(2).FaceAlpha = 0.2;
	h_GraphObj(2).EdgeAlpha = 0;
	colormap(plot.custom_RGB_colormap())
elseif general.struct.probe_field(GraphObj_md, 'ifdo.interp2')
	% Find the minimum and maximum points that span the square:
	hold on
	[~, idx_Xmax] = max(X); [~, idx_Xmin] = min(X);
	[~, idx_Ymax] = max(Y); [~, idx_Ymin] = min(Y);
	[X_mg, Y_mg] = meshgrid(linspace(X(idx_Xmin), X(idx_Xmax), 10), linspace(Y(idx_Ymin), Y(idx_Ymax), 10));
	F = scatteredInterpolant(X, Y, C, 'linear');
	Vq = F(X_mg,Y_mg);
	[~, h_GraphObj(2)] = contourf(h_axes(2), X_mg, Y_mg, Vq, 'LineStyle','none');
	colormap(h_axes(2), plot.custom_RGB_colormap([1 1 1], [0.6 0.6 0.6]))
	uistack(h_GraphObj(2), 'bottom');
	h_GraphObj(2).LevelList = linspace(h_GraphObj(2).LevelList(1), h_GraphObj(2).LevelList(end), 50);
	h_axes(1).Color = 'none';
end

if ~general.struct.issubfield(plot_md, 'axes.Title')
	htitle = title(h_axes(1), {['min: ' num2str(min(C(:))) ','], ['max: ' num2str(max(C(:)))]});
	htitle.Position = [350 600 0];
end
uistack(h_axes(1), 'top')