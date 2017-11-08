function [colorstring] = colormkr(colornumber)
% Convenience function to create a string representing a color for
% different input numbers. Annoying that Matlab does not do this himself:

% colors = {'k', 'b', 'r', 'g', 'k', 'c', 'y', 'm'};
colors = {	[0 0 0], [216 82 24], ...
			[236 176 31], [125 46 141], ...
			[49 79 79], [112 138 144], ...
			[65 105 225], [210 105 30], ...
			[46 139 87], [218 165 32]};

colornumber = mod(colornumber-1, length(colors))+1;
colorstring = colors{colornumber};
end