function [ cell_out ] = pre_postscript_to_cellstring( cell_in, pre, post)
% add a prescript and/or postscript to a cell array of strings
% 

cell_out = strcat(pre, cell_in, post);

end

