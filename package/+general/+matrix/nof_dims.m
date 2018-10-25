function [ n ] = nof_dims( array )
% This convenience function receives a matrix, counts the dimensions of it 
% and returns that number:
% Input:
% array 
% Output;
% n			number of dimensions of array.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

[d(1), d(2), d(3), d(4)] = size(array);
n = sum(d > 1);


end


