function [ hLine ] = imagesc(h_axes, midpoints, Count, GraphObj_md)
% This function draws a two-dimensional plot in polar coordinates.
% Unfortunately, MATLAB (expensive software) does not support the plotting 
% of surfaces in a PolarAxes.... It is easy in Python (free, matplotlib.pyplot).
% Input:
% h_axes		The axes handle
% midpoints:   array with linearly increasing values, around which the bins
%               are calculated
% Count:		The number of counts that fell into the corresponding
%               container.
% GraphObj_md	The prefered metadata of the Graphical Object.
% Output:		
% hLine			The output handle (Graphical Object). 
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% As a workaround, we add an axes on top of the polaraxes:
imagesc_axes = axes('Position', h_axes.Position, 'Color', 'none');

[~, ~, ~, hLine] = plot.polarplot3d(imagesc_axes, midpoints.dim1, midpoints.dim2, Count', []);

axis(imagesc_axes, 'equal')
imagesc_axes.Visible		= 'off';
scale_factor			= 0.8;
imagesc_axes.Position(3:4)=  scale_factor*h_axes.Position(3:4);
imagesc_axes.Position(1) =  imagesc_axes.Position(1)+scale_factor/2*(imagesc_axes.Position(3) - imagesc_axes.Position(1));
hlink = linkprop([h_axes, imagesc_axes],'Position');
uistack(h_axes, 'top')
colormap(imagesc_axes, plot.myjet);  %plot.custom_RGB_colormap('w','r',0,1)  plot.myjet
c = colorbar;
% caxis([0 1])
c.Position = [0.8733,0.288,0.04667,0.526];

