function [linestylestring, nof_variations] = linestylemkr(linestylenumber)
% Convenience function to create a string representing a linestyle 
% for different input numbers.
% Inputs:
% number	Number to indicate a number
% Outputs:
% linestylestring	The char that denotes a color, for instance 'k' for
%					black
% nof_variations	The number of variations that can be made
% 
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se


linestyle = {'-', '--', '-.', ':'};
nof_variations = length(linestyle);
linestylenumber = mod(linestylenumber-1, length(linestyle))+1;
linestylestring = linestyle{linestylenumber};
end