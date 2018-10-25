function [ combined ] = combvec_vardim( matrix_cell )
% This function executes the combvec function for a cell containing multiple
% matrices that need to be combined. Basically, the function unpacks the
% cell and calls the combvec function.
% Input:
% matrix_cell	The one-dimensional cell containing the matrices
% Output:
% Combined		The matrix with all the matrices combined.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

arg	= [];

for i = 1:length(matrix_cell)
% 	For all elements in the cell, add in the argument:
	if i > 1
		arg = [arg  ', '];
	end
	arg = [arg  'matrix_cell{' num2str(i) '}'];
end

% execute the combvec command:
eval(['combined = combvec(' arg  ');']);

end

