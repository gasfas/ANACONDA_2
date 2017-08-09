function [linestylestring, nof_variations] = linestylemkr(linestylenumber)
% Convenience function to create a string representing a linestyle for
% different input numbers:

linestyle = {'-', '--', ':', '-.'};
nof_variations = length(linestyle);
linestylenumber = mod(linestylenumber-1, length(linestyle))+1;
linestylestring = linestyle{linestylenumber};
end