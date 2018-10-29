function [color] = colormkr(colorspec, max)
% Convenience function to create a string representing a color for
% different input numbers.
% Inputs:
% colorspec		Either a number, or name of a color. Options:
% 				'k', 'r', 'y', 'p', 'b'
% max			Maximum RGB intensity number
% Outputs:
% color			The RGB color code.
%
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% colors = {'k', 'b', 'r', 'g', 'k', 'c', 'y', 'm'};
colors = {	[0 0 0], [216 82 24], ...
			[236 176 31], [125 46 141], ...
			[49 79 79], [112 138 144], ...
			[65 105 225], [210 105 30], ...
			[46 139 87], [218 165 32]};
if isnumeric(colorspec) % The user wants a color picked by a number:
	colorspec = mod(colorspec-1, length(colors))+1;
	color = colors{colorspec};
else %We assume a name of a color is given:
	switch colorspec
		case {'k', 'black'}
			color = colors{1};
		case {'r', 'red'}
			color = colors{2};
		case {'y', 'yellow'}
			color = colors{3};
		case {'p', 'purple'}
			color = colors{4};
		case {'b', 'blue'}
			color = colors{7};
	end
end
	
	
if exist('max', 'var')
	color = color/256*max;
end
end