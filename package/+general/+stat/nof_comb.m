function [ b ] = nof_comb(n, k)
% This function calculates the number of combinations (b) a certain set of
% objects of size (n) can occur in a sample of size k.
% This is the same function as nchoosek, but allows n to be a vector.
% n!/((n–k)! k!).
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

switch any(n < k)
	case true
		error('The number of objects is smaller than the sample size');
	case false
		b = factorial(n)./(factorial(n-k) .* factorial(k));
end

end

