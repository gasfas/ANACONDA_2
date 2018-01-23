function [hFig, hAx, hGraphObj] = plot_all(fit_md, fit_param, ax)
% This function plots all the results of the fitting metadata in an
% oversight plot. 
% Input:
% fit_md	struct with the fitting metadata
% fit_param struct with the fitting results
% ax		(optional) axes handle to plot into.
% Output:
% hFig		Figure handle
% hAx		Axes handle
% hGraphObj	Graphical Object handle
if ~exist('ax', 'var')
	hFig = figure;
	hAx = axes;
else
	hFig = ax.Parent;
	hAx = ax;
end
try hFig = general.handle.fill_struct(hFig, fit_md.final_plot.figure); end
try hAx = general.handle.fill_struct(hAx, fit_md.final_plot.axes); end
hold(hAx, 'on')

if ~isfield(fit_md.final_plot, 'color_low_I')
fit_md.final_plot.color_low_I	= [1 1 1]; % White background color
end
if ~isfield(fit_md.final_plot, 'color_high_I')
fit_md.final_plot.color_high_I		= [1 0 0];
end
if ~isfield(fit_md.final_plot, 'dotsize')
fit_md.final_plot.dotsize		= 1;
end

switch fit_md.final_plot.GraphObj.Type
	case 'scatter'
		for i = 1:length(fit_param.q)

			q_cur	= fit_param.q(i);
			result	= fit_param.result(i, 1:8+q_cur);

			% The y-axis is symmetrically distributed around zero:
			y_pos	= -q_cur:2:q_cur;
			x_pos	= q_cur*ones(size(y_pos));
			I		= result(1:q_cur+1);
			
			full_I_colors	= composition_colors(fit_md, y_pos); %(local function)
			I_colors		= Intensity_colors(fit_md, full_I_colors, I);
			hGraphObj = scatter(hAx, x_pos, y_pos, fit_md.final_plot.dotsize, I_colors, 'filled');
			hGraphObj.CData = I_colors;
		end		
	otherwise
		% Fetch the intensity values:
		[fit_results, midpoints.dim1, midpoints.dim2] = macro.fit.m2q.I_at_q(fit_param.q, fit_md, fit_param);

		% create the function, depending on the graphical object Type:
		plot_f = str2func(['plot.hist.axes.H_2D.' fit_md.final_plot.GraphObj.Type]);
		
		hGraphObj = plot_f(hAx, midpoints, fit_results, fit_md.final_plot.GraphObj);

end
hGraphObj = general.handle.fill_struct(hGraphObj, fit_md.final_plot.GraphObj);
end	

function colors = composition_colors(fit_md, y_pos)
rel_comp = (y_pos - min(y_pos))./(diff(y_pos([1 end]))); % the relative composition
% We create a colormap to pick the right color from (component-dependent):
[cmap_comp] = plot.custom_RGB_colormap(fit_md.final_plot.color_comp_1, fit_md.final_plot.color_comp_2);
% And we pick the colors from there:
colors		= interp1(linspace(0,1,256), cmap_comp, rel_comp, 'Nearest');
end

function colors = Intensity_colors(fit_md, full_I_colors, I)

I_norm			= I./max(I); % normalize the intensity
color_zero_I	= repmat(fit_md.final_plot.color_low_I, size(full_I_colors,1),1);% Fetch the color at zero intensity
colors	= color_zero_I+(full_I_colors-color_zero_I).*repmat(I_norm', 1, 3);
end
















