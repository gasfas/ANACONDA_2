function [h_figure] = fig(fig_md)
% This function creates a plot figure, with the specified plotstyle in a
% new figure.
% Inputs:
% fig_md		The metadata struct with figure preferences. Can also be a
%				list of structs, then multiple figures and handles are intiated.
% Outputs:
% h_figure	The Figure handle

if numel(fig_md)>1
	for i = 1:numel(fig_md)
		% Create the new figure:
		h_figure(i) = macro.plot.create.fig(fig_md(i));
	end
else
	% Create the new figure:
	h_figure = figure;
if ~isempty(fig_md)
	h_figure = general.handle.fill_struct(h_figure, fig_md);
end
end