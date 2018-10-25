function [ cell_out ] = pre_postscript_to_cellstring( cell_in, pre, post)
% add a prescript and/or postscript to a cell array of strings
% Inputs: 
% cell_in	The input char cell, where a pre- and/or post script is added to
% pre		char, the text added before each char element of cell_in
% post		char, the text added after each char element of cell_in
% Outputs:
% cell_out	The output cell, with the added post and/or prescripts
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% If the cell contains numbers, they are converted to strings:
cell_in = cellfun(@num2str, cell_in, 'UniformOutput', false);

cell_out = strcat(pre, cell_in, post);

end

