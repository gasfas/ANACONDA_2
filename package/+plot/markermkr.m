function [markerstring, nof_variations] = markermkr(markernumber)
% Convenience function to create a string representing a marker 
% for different input numbers.
% Inputs:
% number	Number to indicate a number
% Outputs:
% markerstring		The char that denotes a marker style, for instance 'o'
%					for a circle
% nof_variations	The number of variations that can be made
% 
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

markerstyle = {'x', 'o', '*', '.', '+', 'square', 'diamond', 'v', '^', '>', '<'};
nof_variations = length(markerstyle);
markernumber = mod(markernumber, length(markerstyle))+1;
markerstring = markerstyle{markernumber};
end