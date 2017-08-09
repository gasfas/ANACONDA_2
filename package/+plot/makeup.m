function [] = makeup(axes_h, plotstyle)
% set the plot limits, labels, size, whathaveyou, defined in plottype_item
if iscell(axes_h)
% 	for i = 1:length(axes_h)
		plot.makeup(axes_h{1}, plotstyle);
% 	end
else
	gca = axes_h;
	lines = get(axes_h, 'children');
	if ~isempty(lines)
		line_h = lines(1); %the current line handle
	end
	% TODO: divide the makeup into functions for axes and line makeup.

	%% Axes properties
	% make axes_h the current axis:
	axes_original = gca; axes(axes_h);

	switch get(axes_h, 'Type')

		case 'polaraxes'
			if isfield(plotstyle, 'thetaLim')
				if length(plotstyle.thetaLim) == 2;
					% if so, rescale the angle range:
					axes_h.ThetaLim         = plotstyle.thetaLim;
				end
			end

			if isfield(plotstyle, 'rLim')
				if length(plotstyle.rLim) == 2;
					% if so, rescale the radial axis:
					axes_h.RAxis.Limits    = plotstyle.rLim;
				end
			end        
		otherwise

			if isfield(plotstyle, 'axis')
				if strcmpi(plotstyle.axis, 'equal')
			%         set(axes_h, 'Axis', 'equal')
					axis equal
				end
			end

			% Check the plottype:
			if ~isfield(plotstyle, 'plottype')
				plotstyle.plottype = 'default';
			end

			% Set the limits:

			% check if the user wants to scale x:
			if isfield(plotstyle, 'x_range') && (~strcmpi(plotstyle.plottype, 'solid_angle_polar_2D') && ~strcmpi(plotstyle.plottype, 'ternary'))
				if length(plotstyle.x_range) == 2
					% if so, rescale the x-axis:
					if ~range(plotstyle.x_range) == 0 % If the range is zero, this function will throw an error
						xlim(axes_h, plotstyle.x_range);
					end
				end
			end

			% check if the user wants to scale y:
			if isfield(plotstyle, 'y_range')
				if length(plotstyle.y_range) == 2
					if ~range(plotstyle.y_range) == 0 % If the range is zero, this function will throw an error
						if ~strcmpi(plotstyle.plottype, 'solid_angle_polar_2D')
							ylim(axes_h, plotstyle.y_range)
						else
							ylim(axes_h, [min(plotstyle.y_range) 1.05*max(plotstyle.y_range)])
						end
					end
				end
			end
			% check if the user wants to scale z:
			if isfield(plotstyle, 'z_range') && strcmpi(plotstyle.plottype, 'default')
				if length(plotstyle.z_range) == 2
					% if so, rescale the z-axis:
					if ~range(plotstyle.z_range) == 0 % If the range is zero, this function will throw an error
						zlim(axes_h, plotstyle.z_range)
					end
					% or if it is a 3D plot:
					if isfield(get(axes_h), 'ZLim')
						set(axes_h, 'ZLim', plotstyle.z_range);
					end
				end
			end

			% write the labels:
			% check if the user wants to label x:
			if isfield (plotstyle, 'x_label')
				xlabel(axes_h, plotstyle.x_label);
			end
			% check if the user wants to label y:
			if isfield (plotstyle, 'y_label')
				ylabel(axes_h, plotstyle.y_label);
			end
			% check if the user wants to label z:
			if isfield (plotstyle, 'z_label')
				zlabel(axes_h, plotstyle.z_label);
			end

			% change the ticks:
			if isfield (plotstyle, 'x_tick')
				set(gca,'XTick', sort(unique(plotstyle.x_tick)))
			end
			if isfield (plotstyle, 'y_tick')
				set(gca,'YTick', sort(unique(plotstyle.y_tick)))
			end
			if isfield (plotstyle, 'z_tick')
				set(gca,'ZTick', sort(unique(plotstyle.y_tick)))
			end

			% add a grid:
			if isfield(plotstyle, 'grid')
				switch plotstyle.grid
					case 'on'
						grid on 
					case 'off'
						grid off
					case 'minor'
						grid minor
				end
			end

			if isfield(plotstyle, 'position')
				set(gcf, 'Position', plotstyle.position)
			end

			if isfield(plotstyle, 'YTickLabelRotation')
				axes_h.XTickLabelRotation= plotstyle.YTickLabelRotation;
			end

			if isfield(plotstyle, 'XTickLabelRotation')
				axes_h.XTickLabelRotation= plotstyle.XTickLabelRotation;
			end

			if isfield(plotstyle, 'FontSize')
				axes_h.FontSize = plotstyle.FontSize;
			end
	end

	if isfield(plotstyle, 'title')
		title(plotstyle.title);
	end

	if isfield(plotstyle, 'Xdir')
		set(axes_h, 'Xdir', plotstyle.Xdir);
	end
	
	if isfield(plotstyle, 'Ydir')
		set(axes_h, 'Ydir', plotstyle.Ydir);
	end
	
	%% Line/contour style:
	% for 1D histograms:

	if exist('line_h', 'var')
		if strcmpi(line_h.Type, 'line')
			if isfield (plotstyle, 'color')
				set(line_h, 'Color', plotstyle.color)
			end

			if isfield(plotstyle, 'LineStyle')
				set(line_h, 'LineStyle', plotstyle.LineStyle)
			end

			if isfield(plotstyle, 'marker')
				set(line_h, 'Marker', plotstyle.marker)
			end
		end
	end

	% for 2D histograms:
	if general.struct.issubfield(plotstyle, 'colormap')
		if general.struct.issubfield(plotstyle.colormap, 'RGB')
			h = colormap(axes_h, plotstyle.colormap.RGB);
		elseif general.struct.issubfield(plotstyle.colormap, 'type')
			if strcmp(plotstyle.colormap.type, 'jet')
				colormap(axes_h, jet(256))
			elseif strcmp(plotstyle.colormap.type, 'hot')
				colormap(axes_h, hot(256))
			end
		end
	end

	if exist('line_h', 'var') && isfield(plotstyle, 'LegendDisplay') 
		set(get(get(line_h,'Annotation'),'LegendInformation'), 'IconDisplayStyle', plotstyle.LegendDisplay); 
	end


	%% area plot style:
	if exist('line_h', 'var')
		switch line_h.Type 
			case 'area'
				nof = numel(lines);
				for i = 1:nof
					lines(i).FaceColor = [0 0 0];
					lines(i).FaceAlpha = 1-i./(nof+1);
					lines(i).LineWidth = 1.5;
				end	
		end	
	end
	% Switch back to the original axis:
	axes(axes_original)
	end
end