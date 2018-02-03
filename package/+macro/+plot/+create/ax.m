function [h_axes] = ax(h_figure, axes_md)
% This function creates a plot axis into a specified figure, with the 
% specified plotstyle.
% Inputs:
% fig_h		The figure handle in which to plot.
% plot_md	The plot metadata struct, with the optional fields: 
% 				fig (Figure properties)
%				axes (axes properties)
%				hist (histogram properties)
% Outputs:
% h_axes	The Axes handle

if numel(axes_md)>1
	for i = 1:numel(axes_md)
		% Create the new axes:
		h_axes(i) = macro.plot.create.ax(h_figure, axes_md(i));

		% If axes have similar ranges, link them:
		if i > 1, coor = [];
			if general.struct.probe_field(h_axes(1), 'XRange') == general.struct.probe_field(h_axes(i), 'XRange')
				coor = [coor 'x'];
			end
			if general.struct.probe_field(h_axes(1), 'YRange') == general.struct.probe_field(h_axes(i), 'YRange')
				coor = [coor 'y'];
			end
			linkaxes([h_axes(1) h_axes(i)], coor);
		end
	end
else
	% Create the new axes:
	if ~isfield(axes_md, 'Type')
		axes_md.Type = 'axes';
	end
	switch axes_md.Type
		case 'polaraxes'
			h_axes = polaraxes('Parent', h_figure);
		case 'ternary'
			try [~, h_axes] = plot.ternary.ternaxes(11, axes_md.Xlim_scaled);
			catch [~, h_axes] = plot.ternary.ternaxes(11); end
% 			h_axes = axes('Parent', h_figure);
			plot.ternary.ternlabel(axes_md.XLabel.String, axes_md.YLabel.String, axes_md.ZLabel.String);
			try axes_md.XLim = axes_md.Xlim_scaled;
			catch axes_md.XLim = [0 1]; end
			try axes_md.YLim = axes_md.Ylim_scaled;
			catch axes_md.YLim = [0 1]; end
			axes_md.XTick = [];
			axes_md.YTick = [];
			axes_md = rmfield(axes_md, {'XLabel', 'YLabel', 'ZLabel'});
		otherwise
			h_axes = axes('Parent', h_figure);
	end
	% Copy the axes values into the handle:
	if ~isempty(axes_md)
		h_axes = macro.plot.fill.ax(h_axes, axes_md);
	end
end

end