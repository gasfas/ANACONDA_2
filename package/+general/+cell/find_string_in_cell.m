function [ idx ] = find_string_in_cell( C, string )
% This function takes a cell, searches for a keyword in the elements, and
% returns whether it is found, and in which element of the cell

idxC = strfind(C, string);
idx = find(not(cellfun('isempty', idxC)));
end

