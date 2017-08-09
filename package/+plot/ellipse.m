function hLine = ellipse(axhandle, x,y,r_x, r_y, color)
% This function plots a ellipse shape in a give axis.
% Input:
% axhandle: The axis handle to plot the figure into
% x         x-coordinate of the center of the circle
% y         y-coordinate of the center of the circle
% r_x       radius in x-direction 
% r_y       radius in y-direction
% color     color of the ellipse
% Output:
% no output.
% NOTE: 0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
% NOTE: this function can only plot ellipses with their major and minor
% axes aligned with the x. or y-axes.
% SEE ALSO plot.circle

ang=(0:0.01:2*pi)'; 

% make matrix for different centra and radii:
xp= repmat(r_x,length(ang),1) .* repmat(cos(ang), 1, length(r_x));
xplot = repmat(xp,1, length(x)) + repmat(x, size(xp,1),length(r_x));

yp= repmat(r_y,length(ang),1) .* repmat(sin(ang), 1, length(r_y));
yplot = repmat(yp,1, length(x)) + repmat(y, size(yp,1),length(r_y));

hLine = plot(axhandle, xplot, yplot, 'Color', color);
end
