function hLine = filled_circle(axhandle, x,y,r, color)
% This function plots a filled circle of any specified size, color,
% position. 0.01 is the angle step, bigger values will draw the circle
% faster but you might notice imperfections (not very smooth)
% Inputs:
% x		x-coordinate of the center of the circle
% y		y-coordinate of the center of the circle
% r		The radius of the circle
% Outputs:
% hLine	handle of the drawn line.
% SEE ALSO: plot.ellipse
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

N = 1e3;
theta	= linspace(0,2*pi,N);
R		= ones(1,N)*r;
[x_circle,y_circle] = pol2cart(theta,R);
x_circle	= x_circle + x;
y_circle	= y_circle + y;

hLine			= fill(axhandle, x_circle,y_circle,color);
end