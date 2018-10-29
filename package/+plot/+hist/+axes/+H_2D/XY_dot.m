function [h_GraphObj] = XY_dot(h_axes, midpoints, Count, GraphObj_md, Type)
% This function plots an average or peak X and Y-value, of a 2D histogram 
% with given x- and y-data.
% Input:
% h_axes:    The axis handle to plot the figure into
% midpoints		since dim ==2, struct with the field:
%					midpoints.dim1	[m, 1] array with the edges of the bin (x)
%					midpoints.dim2	[l, 1] array with the edges of the bin (y).
% Count			[m,l] array with the 2D histogram.
% GraphObj_md The metadata of the graphical object.
% Type		char specifying the plot type requested. Two options:
% 				'mean': The average value in X and Y is calculated and
% 				plotted
%				'peak' The XY location of the highest histogram value is
%				plotted
% Output:
% h_GraphObj	The Graphical Object handle
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

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

% exchange NaN's for zero's:
Count(isnan(Count)) = 0;

switch Type
	case 'mean'
		% calculate the average value of the histogram in X and Y:
		x_hist	= sum(Count, 2)./sum(Count(:));
		y_hist	= sum(Count, 1)'./sum(Count(:));
		x_val = sum(midpoints.dim1.*x_hist);
		y_val = sum(midpoints.dim2.*y_hist);
		if general.struct.probe_field(GraphObj_md, 'show_FWHM')
			warning('FWHM not supported yet')
		end
	case 'peak'
		% find the peak value of the histogram:
		[val, idx] = max(Count(:));
		[row, col] = ind2sub(size(Count), idx);
		x_val = midpoints.dim1(row);
		y_val = midpoints.dim2(col);
		if general.struct.probe_field(GraphObj_md, 'show_FWHM')
			warning('FWHM not supported yet')	
		end
end

% Make the plot:
h_GraphObj = plot(h_axes, x_val, y_val);

end