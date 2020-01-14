function [colormap] = custom_RGB_colormap(color_low, color_high, low_value, high_value)
% This function generates a custom RGB colormap.
% Inputs (all optional):
% color_low		The color (RGB or string code e.g. 'w') at low intensities.
% color_high	The color (RGB or string code e.g. 'w') at high intensities
%				run   [clr,rgb] = plot.color.colornames('MATLAB'); [char(strcat(clr,{'  '})),num2str(rgb)]
%				to find out which colornames are available.
% low_value		The value at which the interpolation of colors should start
%				(from 0 to 1). Below that is saturated with color_low
% high_value	The value at which the interpolation of colors should end
%				(from 0 to 1). Above the value is saturated with color_high
% Outputs:
% colormap		The RGB colormap (256, 3)
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if ~exist('color_low', 'var');	color_low	= [0  1  1];end %'w'; end %
if ~exist('color_high', 'var');	color_high	= 'r'; end 
if ~exist('low_value', 'var');	low_value	= 0; end
if ~exist('high_value', 'var'); high_value	= 1; end

% First translate the colors given to RGB values, if they aren't already:
if length(color_low) ~= 3
	c_low_RGB	= plot.color.convert_2_RGB(color_low);
else
	c_low_RGB = color_low;
end
if length(color_high) ~= 3
	c_high_RGB	= plot.color.convert_2_RGB(color_high);
else
	c_high_RGB = color_high;
end
n=256;
% Create a simple linear array from 0 to 1:
C = linspace(0, 1, n)';%256
% Count the number of values that should fall in the color gradient:
nof_gradient_values = round((high_value-low_value)*n);
% And the values (linear scale between 0 and 1) where they should go:
gradient_values = linspace(low_value, high_value, nof_gradient_values);
colormap=zeros(n,3);
for i = 1:3
colormap(1:n,i) = interp1(gradient_values, linspace(c_low_RGB(i), c_high_RGB(i), nof_gradient_values), C, 'nearest', 'extrap');
end

end