function [ RGB ] = I_2_RGB(I, color_min, color_max)
%Convert intensities into RGB (n,3) matrices, interpolated between the
%minimum and maximum color.
% Inputs:
% I				Array of intensities (unscaled)
% color_min		The requested RGB color code of the minimum intensity
% color_max		The requested RGB color code of the maximum intensity
% Outputs:
% RGB			The intensity in RGB format
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if ~exist('color_min', 'var')
	color_min = [1 1 1];
end

if ~exist('color_max', 'var')
	color_max = [0 0 0];
end

RGB = ones(length(I), 3);
if range(I) ~= 0
	RGB(:,1) = interp1([min(I(:)), max(I(:))], [color_min(1), color_max(1)], I);
	RGB(:,2) = interp1([min(I(:)), max(I(:))], [color_min(2), color_max(2)], I);
	RGB(:,3) = interp1([min(I(:)), max(I(:))], [color_min(3), color_max(3)], I);
else 
	RGB = color_min;
end

