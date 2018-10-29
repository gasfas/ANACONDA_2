function hLine = circle(axhandle, x,y,r, color)
% This function simplifies the drawing of a circle in a plot. 
% 0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
% Inputs:
%x		The X-coordinate of the center of the circle
%y		The Y-coordinate of the center of the circle
%r		The radius of the circle
% color The color of the circle
% hLine	the line handle of the drawn line
%
% SEE ALSO: plot.ellipse

hLine = plot.ellipse(axhandle, x,y,r, r, color);

end