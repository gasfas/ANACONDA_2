function is_equal = isequal(matrix1, matrix2)
% This function is the same as the in-built function 'eq', with the
% exception that it accepts different-sized matrices.
% Inputs:
% matrix1, matrix2 :	The matrices one wants to know their similarity.
% Outputs:
% is_equal				Logical, whether the matrices are exactly the same
%						or not
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

try	
	is_equal = all(all(matrix1 == matrix2));
catch
	is_equal = false;
end
end