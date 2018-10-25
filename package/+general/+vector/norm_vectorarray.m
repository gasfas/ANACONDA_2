function [ N ] = norm_vectorarray( VECTOR_ARRAY, DIM )
%This function calculates the norm of a number of vectors, stored in an
%array. The dimension along which the vector is defined is denoted in 'DIM'
% Inputs:
% VECTOR_ARRAY	[n, m] Array of vectors (matrix), of which the norms are
%				requested.
% DIM			The dimension along which the vectors are oriented
% Outputs:
% N				The norms of vectors in VECTOR_ARRAY.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if ~exist('DIM', 'var')
	DIM = 2;
end
N = sqrt(sum(abs(VECTOR_ARRAY).^2,DIM));

end

