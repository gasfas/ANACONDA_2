function f = binomial_f (q, x, p)
f     = factorial(q)./(factorial(x) .* factorial(q - x)) .* (1 - p).^(q-x) .* p.^x;
end