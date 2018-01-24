function [h_GraphObj] = Y_line(h_axes, midpoints, Count, GraphObj_md, Type)
% This function plots an average Y-value, or the peak Y-value of a 2D 
% histogram of given x- and y-data.
% Input:
% h_axes:    The axis handle to plot the figure into
% midpoints		since dim ==2, struct with the field:
%					midpoints.dim1	[m, 1] array with the edges of the bin (x)
%					midpoints.dim2	[l, 1] array with the edges of the bin (y).
% Count			[m,l] array with the 2D histogram.
% GraphObj_md The metadata of the graphical object.
% Output:
% h_GraphObj	The Graphical Object handle (Patch)

% If y-smoothening is requested:
if isfield(GraphObj_md, 'medfilt_Y_radius')
	Count = medfilt2(Count, [1 GraphObj_md.medfilt_Y_radius]);
end

% If the user has specified a minimum of Count value, to be considered
% valid to calculate a y-value for:
if isfield(GraphObj_md, 'hist_threshold')
isinvalid			= sum(Count, 2) < GraphObj_md.hist_threshold;
Count(isinvalid, :) = 0;
end

[x_histbins, y_histbins]	= deal(midpoints.dim1, midpoints.dim2);

switch Type
	case 'mean'
		% calculate the average value of the histogram:
		[y_val, std_y] = hist.mean.H_2D(Count, y_histbins);
		approved_val	= ~isnan(x_histbins) & ~isnan(y_val);
		[dy.below, dy.above] = deal(std_y, std_y);
	case 'peak'
		% find the peak value of the histogram:
		[y_val, dy]	= hist.peak.H_2D(Count, y_histbins);
		approved_val	= ~isnan(x_histbins) & ~isnan(y_val);
end

x_histbins				= x_histbins(approved_val);
y_val					= y_val(approved_val);
Count					= Count(approved_val, :);
[dy.below, dy.above]	= deal(dy.below(approved_val), dy.above(approved_val));


% We plot the average y-value vs all approved x-values:
switch general.struct.probe_field(GraphObj_md, 'show_FWHM')
	case false	% no FWHM shown, so we just plot a line:
		h_GraphObj = plot(h_axes, x_histbins, y_val);
	otherwise
		% peak width is requested:
	if length(x_histbins) > 1 %More than one point can form a line:
		h_GraphObj = plot.shadedErrorBar(h_axes, x_histbins, y_val, [dy.above, dy.below]);
	elseif length(x_histbins) == 1 % We plot a point with errorbar:
		h_GraphObj = errorbar(h_axes, midpoints.dim1(approved_val), y_val, dy.below, dy.above);
	else
		h_GraphObj = errorbar(h_axes, 0, 0);
	end
end

end