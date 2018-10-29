function h = textul(varargin)
% Function that places a text in the plot,
% Inputs: 
% ax		(optional), the axes to plot the text into.
% txt		(char) the text to be displayed (Latex interpreted)
% height	the vertical position at which the lower left point will be placed (normalized)
% width 	the hoirizontal position at which the lower left point will be placed (normalized)
% color		color char (e.g. 'b', 'r', etc) or the RGB value.
% Outputs: 
% h			handle to the text
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% see if the first input is an axes handle:
if isgraphics(varargin{1}, 'Axes')
	h_axes		= varargin{1};
	varargin	= varargin(2:end);
else
	h_axes = gca;
end

txt		= varargin{1};
try height	= varargin{2};
catch height = 0.5;
end
try width	= varargin{3};
catch width = 0.5;	
end
try color	= varargin{4};
catch color = 'k'; % default color is black
end

a = axis;
wdth = a(2)-a(1);
ht = a(4)-a(3);
pos = [a(1)+width*wdth a(4)-height*ht];

h = text(h_axes, pos(1),pos(2),txt,'Fontsize', 16, 'Color', color);
end
