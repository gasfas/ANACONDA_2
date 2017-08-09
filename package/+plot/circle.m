function hLine = circle(axhandle, x,y,r, color)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
% SEE ALSO: plot.ellipse

hLine = plot.ellipse(axhandle, x,y,r, r, color);

end