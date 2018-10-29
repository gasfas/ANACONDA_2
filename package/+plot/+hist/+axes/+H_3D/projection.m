function [h_GraphObj] = projection(h_axes, midpoints, Count, GraphObj_md)
% This function draws 2D projections of a 3D histogram.
% Inputs:
% h_axes	the axes handle of the plot
% midpoints	struct, the midpoints in the histogram, stored as
%			midpoints.dim1 and midpoints.dim2 (for x and y, respectively)
% Count		The histogram count matrix
% GraphObj_md	The metadata describing the graphical object.
% Outputs:
% hLine		The handle of the Graphical Object
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% Project the histograms on the outer walls:

%% X-Projection:
Proj_x = sum(Count, 1); % sum over x-coordinate
Proj_x = permute(Proj_x, [2, 3, 1]);
XData	= max(midpoints.dim1)*ones(size(Proj_x));
[YData, ZData]	= meshgrid(midpoints.dim2, midpoints.dim3);

h_GraphObj(1) = surface( ...
	'XData', XData,...
	'YData', YData',...
	'ZData', ZData',...
	'CData',Proj_x);
view(3)
hold on 

%% Y_projection
Proj_y = sum(Count, 2); % sum over x-coordinate
Proj_y = permute(Proj_y, [1, 3, 2]);
YData	= max(midpoints.dim2)*ones(size(Proj_y));
[XData, ZData]	= meshgrid(midpoints.dim1, midpoints.dim3);

h_GraphObj(2) = surface( ...
	'XData', XData',...
	'YData', YData,...
	'ZData', ZData',...
	'CData',Proj_y);

%% Z-projection:
Proj_z = sum(Count, 3); % sum over x-coordinate
ZData	= min(midpoints.dim3)*ones(size(Proj_z));
[XData, YData]	= meshgrid(midpoints.dim1, midpoints.dim2);

h_GraphObj(3) = surface( ...
	'XData', XData',...
	'YData', YData',...
	'ZData', ZData,...
	'CData',Proj_z);

%% Draw a 3D grid:
plot.grid_3D(h_GraphObj(1).Parent,	[min(midpoints.dim1)-10, 0, max(midpoints.dim1)], ...
								[min(midpoints.dim2)-10, 0, max(midpoints.dim2)], ...
								[min(midpoints.dim2), 0, max(midpoints.dim3)+10], 'k');
end
