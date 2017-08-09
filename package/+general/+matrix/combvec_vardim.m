function [ combined ] = combvec_vardim( matrix_cell )
% This function executes the combvec function for a cell containing multipl
% matrices that need to be combined. Basically, the function unpacks the
% cell and calls the function.
% Input:
% matrix_cell	The one-dimensional cell containing the matrices
% Output:
% Combined		The matrix with all the matrices combined.

arg	= [];

for i = 1:length(matrix_cell)
	if i > 1; 
		arg = [arg  ', '];
	end
	arg = [arg  'matrix_cell{' num2str(i) '}'];
end
eval(['combined = combvec(' arg  ');']);

end

