function [h_GraphObj] = Y_peak(h_axes, midpoints, Count, GraphObj_md)
% This function plots the Y-value with highest intensity of a 2D histogram of given x- and y-data.
% Input:
% h_axes:    The axis handle to plot the figure into
% midpoints		since dim ==2, struct with the field:
%					midpoints.dim1	[m, 1] array with the edges of the bin (x)
%					midpoints.dim2	[l, 1] array with the edges of the bin (y).
% Count			[m,l] array with the 2D histogram.
% Output:
% h_GraphObj	The Graphical Object handle (Patch)

% If y-smoothening is requested:
if isfield(GraphObj_md, 'medfilt_Y_radius')
	Count = medfilt2(Count, [1 GraphObj_md.medfilt_Y_radius]);
end

% calculate the average value of the histogram:
[max_y, FWHM]	= hist.peak.H_2D(Count, midpoints.dim2);
approved_val	= ~isnan(midpoints.dim1) & ~isnan(max_y);
midpoints.dim1	= midpoints.dim1(approved_val);
max_y			= max_y(approved_val);
FWHM.below		= FWHM.below(approved_val);
FWHM.above		= FWHM.above(approved_val);
Count			= Count(approved_val, :);

% We plot the average y-value vs all approved x-values:
% We choose different functions, depending on the user's preference:
switch general.struct.probe_field(GraphObj_md, 'show_FWHM')
	case false	% no FWHM shown, so we just plot a line:
		h_GraphObj = plot(h_axes, midpoints.dim1, max_y);
	otherwise	% FWHM shown, so we plot a line and a patch surface around it:
		if length(midpoints.dim1) > 1
			h_GraphObj = plot.shadedErrorBar(h_axes, midpoints.dim1, max_y, [FWHM.above, FWHM.below]);
		else
			h_GraphObj = errorbar(h_axes, midpoints.dim1, max_y, FWHM);
		end
end

end