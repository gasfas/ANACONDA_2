function [factor] = asymmetry_factor(n_i)
% This function calculates the 'assymmetry factor', defined as:
% The factor is defined as: 
% 					std(n1, n2, ...)./mean(n1, n2, ...), with ni the number
% 					of monomers in a fragment
% Inputs:
% n_i		[n, C_nr] The sizes of all fragments
% Outputs:
% factor	The asymmetry factor

factor = std(n_i, 0, 2) ./ mean(n_i, 2);
end