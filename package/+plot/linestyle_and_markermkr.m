function [linestylestring, markerstring, nof_variations] = linestyle_and_markermkr(number)
% Convenience function to create a string representing a marker and linestyle 
% for different input numbers.
% Inputs:
% number	Number to indicate a number
% Outputs:
% linestylestring	The char that denotes a color, for instance 'k' for
%					black
% markerstring		The char that denotes a marker style, for instance 'o'
%					for a circle
% nof_variations	The number of variations that can be made
% 
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% First we vary the linestyle, then the markers:
[linestylestring, nof_ls_var] = plot.linestylemkr(number);
markernumber = floor(number./nof_ls_var);

[markerstring, nof_mr_var] = plot.markermkr(markernumber);
nof_variations = nof_ls_var*nof_mr_var;
end