function [RGB_value] = convert_2_RGB(color_value)
% This simple function translates a color value(in string or RGB format) to
% RGB format:
% Inputs:
% color_value	color value in either string ('w', 'white', 'g', etc) or
%				already in RGB format (e.g. [0 0 1]);
% Outputs:
% RGB		color value in RGB format

[~, RGB_value] = plot.color.colornames('MATLAB', color_value);
end
	