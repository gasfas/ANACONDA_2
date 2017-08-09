function [ N ] = norm_vectorarray( VECTOR_ARRAY, DIM )
%This function calculates the norm of a number of vectors, stored in an
%array. The dimension along which the vector is defined is denoted in 'DIM'
if ~exist('DIM', 'var')
	DIM = 2;
end
N = sqrt(sum(abs(VECTOR_ARRAY).^2,DIM));

end

