function hLine = filled_circle(axhandle, x,y,r, color)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
% SEE ALSO: plot.ellipse
N = 1e3;
theta	= linspace(0,2*pi,N);
R		= ones(1,N)*r;
[x_circle,y_circle] = pol2cart(theta,R);
x_circle	= x_circle + x;
y_circle	= y_circle + y;

hLine			= fill(axhandle, x_circle,y_circle,color);
end