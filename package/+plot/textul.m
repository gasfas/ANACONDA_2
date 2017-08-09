% places a text in the plot,
% height = the vertical position at which the lower left point will be placed (normalized)
%width the horizonta position 

function h = textul(txt, height, width, color)
if ~exist('height', 'var')
	height = 0.5;	
end
if ~exist('width', 'var')
	width = 0.5;	
end
if ~exist('color', 'var')
	color = 'k'; % default color is black
end
a = axis;
wdth = a(2)-a(1);
ht = a(4)-a(3);
pos = [a(1)+width*wdth a(4)-height*ht];

h = text(pos(1),pos(2),txt,'Fontsize', 14, 'Color', color);
end