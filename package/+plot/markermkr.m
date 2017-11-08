function [markerstring, nof_variations] = markermkr(markernumber)
% Convenience function to create a string representing a marker for
% different input numbers:

markerstyle = {'x', 'o', '*', '.', '+', 'square', 'diamond', 'v', '^', '>', '<'};
nof_variations = length(markerstyle);
markernumber = mod(markernumber, length(markerstyle))+1;
markerstring = markerstyle{markernumber};
end