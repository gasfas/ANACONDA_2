function f = binomial_f (q, x, p)
% Binomial coefficients calculator
% Inputs:
% q		The number of coin throws
% x		The final outcome of which the probability is requested
% p		The probability to add one at a coin throw
% Outputs:
% f		The normalized probability of final outcomes x
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

f     = factorial(q)./(factorial(x) .* factorial(q - x)) .* (1 - p).^(q-x) .* p.^x;
end