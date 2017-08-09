function [linestylestring, markerstring, nof_variations] = linestyle_and_markermkr(number)
% Convenience function to create a string representing a marker for
% different input numbers:

% First we vary the linestyle, then the markers:
[linestylestring, nof_ls_var] = plot.linestylemkr(number);
markernumber = floor(number./nof_ls_var);

[markerstring, nof_mr_var] = plot.markermkr(markernumber);
nof_variations = nof_ls_var*nof_mr_var;
end