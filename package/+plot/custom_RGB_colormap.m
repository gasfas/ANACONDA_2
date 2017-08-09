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
if ~exist('color_low', 'var');	color_low	= 'w'; end
if ~exist('color_high', 'var');	color_high	= 'r'; end
if ~exist('low_value', 'var');	low_value	= 0; end
if ~exist('high_value', 'var'); high_value	= 1; end

% First translate the colors given to RGB values, if they aren't already:
c_low_RGB	= plot.color.convert_2_RGB(color_low);
c_high_RGB	= plot.color.convert_2_RGB(color_high);

% Create a simple linear array from 0 to 1:
C = linspace(0, 1, 256)';
% Count the number of values that should fall in the color gradient:
nof_gradient_values = round((high_value-low_value)*256);
% And the values (linear scale between 0 and 1) where they should go:
gradient_values = linspace(low_value, high_value, nof_gradient_values);

for i = 1:3
colormap(1:256,i) = interp1(gradient_values, linspace(c_low_RGB(i), c_high_RGB(i), nof_gradient_values), C, 'nearest', 'extrap');
end

end