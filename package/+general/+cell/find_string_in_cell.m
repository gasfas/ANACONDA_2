function [ idx ] = find_string_in_cell( C, string )
% This function searches for a keyword in the elements of a given cell, and
% returns whether it is found, and in which element of the cell
% Inputs:
% C		cell, in which to look for a string
% string char, the string element name to look for
% Outputs:
% idx	The index nr of the element found. empty if not found.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se


idxC = strfind(C, string);
idx = find(not(cellfun('isempty', idxC)));
end

