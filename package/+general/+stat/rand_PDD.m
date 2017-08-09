function [numbers] = rand_PDD(values, PDD, size)
% This function creates random numbers based on a given probability density
% distribution. 
% Input:
% values        [n,1] The available values the random number can have, 
%               all outside that value is assumed to have zero probability
% PDD           [n, 1] The Probability density distribution, corresponding
%               to the given array 'values' defined before.
% size          m, the size of matrix with random numbers.
% Output:
% numbers       [m(1), m(2), ...] the output matrix with the random
%               numbers.
% SEE ALSO general.stat.randp

% In case the values are not uniformly distributed, they need to be interpolated:
values_uni          = linspace(min(values), max(values), length(values))';
PDD_uni             = interp1(values, PDD, values_uni);

numbers = min(values) + general.stat.randp(PDD_uni, size).*range(values)./length(PDD_uni);

end

