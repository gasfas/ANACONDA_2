function [linestylestring, nof_variations] = markermkr(markernumber)
% Convenience function to create a string representing a marker for
% different input numbers:

linestyle = {'+', 'o', '*', '.', 'x', 'square', 'diamond', 'v', '^', '>', '<'};
nof_variations = length(linestyle);
markernumber = mod(markernumber, length(linestyle))+1;
linestylestring = linestyle{markernumber};
end