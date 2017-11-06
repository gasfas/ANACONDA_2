function [h_GraphObj] = Y_mean(h_axes, midpoints, Count, GraphObj_md)
% This function plots an average Y-value of a 2D histogram of given x- and 
% y-data.
% Input:
% h_axes:    The axis handle to plot the figure into
% midpoints		since dim ==2, struct with the field:
%					midpoints.dim1	[m, 1] array with the edges of the bin (x)
%					midpoints.dim2	[l, 1] array with the edges of the bin (y).
% Count			[m,l] array with the 2D histogram.
% Output:
% h_GraphObj	The Graphical Object handle (Patch)

[h_GraphObj] = plot.hist.axes.H_2D.Y_line(h_axes, midpoints, Count, GraphObj_md, 'mean')

% x_histdata = midpoints.dim1;
% y_histdata = midpoints.dim2;
% 
% % calculate the average value of the histogram:
% [mean_y, std_y] = hist.mean.H_2D(Count, y_histdata);
% approved_val	= ~isnan(x_histdata) & ~isnan(mean_y);
% x_histdata		= x_histdata(approved_val);
% mean_y			= mean_y(approved_val);
% std_y			= std_y(approved_val);
% Count			= Count(approved_val, :);
% 
% % We plot the average y-value vs all approved x-values:
% if length(x_histdata) > 1
% 	h_GraphObj = plot.shadedErrorBar(h_axes, x_histdata, mean_y, std_y);
% else
% 	h_GraphObj = errorbar(h_axes, x_histdata, mean_y, std_y);
% end

end