function [ cell_out ] = pre_postscript_to_cellstring( cell_in, pre, post)
% add a prescript and/or postscript to a cell array of strings

% If the cell contains numbers, they are converted to strings:
cell_in = cellfun(@num2str, cell_in, 'UniformOutput', false);

cell_out = strcat(pre, cell_in, post);

end

