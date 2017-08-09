function [colorstring] = colormkr(colornumber)
% Convenience function to create a string representing a color for
% different input numbers. Annoying that Matlab does not do this himself:

colors = {'k', 'b', 'r', 'g', 'k', 'c', 'y', 'm'};
colornumber = mod(colornumber-1, length(colors))+1;
colorstring = colors{colornumber};
end