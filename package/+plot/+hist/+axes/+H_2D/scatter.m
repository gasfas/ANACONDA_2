function [ hLine ] = scatter(h_axes, midpoints, Count, GraphObj_md)
% This function plots a 2-dimensional histogram in the form of dots, where
% the color represent the intensity of the histogram.
% Inputs:
% h_axes	the axes handle of the plot
% midpoints	struct, the midpoints in the histogram, stored as
%			midpoints.dim1 and midpoints.dim2 (for x and y, respectively)
% Count		The histogram count matrix
% GraphObj_md	The metadata describing the graphical object.
% Outputs:
% hLine		The handle of the line/scatter object
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

[xtemp, ytemp] = meshgrid(midpoints.dim1, midpoints.dim2); 
xlabels = reshape(xtemp, [numel(xtemp), 1]); 
ylabels = reshape(ytemp, [numel(ytemp), 1]); 

if ~isfield(GraphObj_md, 'color_ low')
GraphObj_md.color_low	= [1 1 1]; % White background color
end
if ~isfield(GraphObj_md, 'color_high')
GraphObj_md.color_high		= [1 0 0];
end
if ~isfield(GraphObj_md, 'high_value')
GraphObj_md.high_value = max(Count(:));
end
if ~isfield(GraphObj_md, 'low_value')
GraphObj_md.low_value = min(Count(:));
end

if ~isfield(GraphObj_md, 'dotsize')
GraphObj_md.dotsize		= 10;
end
Count = Count';
Int_color = repmat(GraphObj_md.color_low, numel(Count), 1) - repmat(((Count(:)-GraphObj_md.low_value))./(GraphObj_md.high_value-GraphObj_md.low_value), 1, 3) .* ...
	(repmat(GraphObj_md.color_low-GraphObj_md.color_high, numel(Count), 1));
hLine = scatter(h_axes, xlabels, ylabels, GraphObj_md.dotsize, Int_color, 'filled');
hLine.CData = Int_color;

end