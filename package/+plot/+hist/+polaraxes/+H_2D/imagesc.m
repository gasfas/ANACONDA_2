function [ hLine ] = imagesc(h_axes, midpoints, Count)

% Unfortunately, MATLAB (expensive software) does not support the plotting 
% of surfaces in a PolarAxes.... It is easy in Python (free, matplotlib.pyplot).

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
colormap(imagesc_axes, plot.custom_RGB_colormap('w','r',0,1));

