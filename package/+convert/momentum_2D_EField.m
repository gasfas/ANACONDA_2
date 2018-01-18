function [p, p_0] = momentum_2D(X, Y, X_0, Y_0, mass, TOF_nominal)
% The function converts X, Y to the in-plane momentum. 
% Input:
% X             [n, 1] array, the (corrected) X coordinates [ns]
% Y             [n, 1] array, the (corrected) Y coordinates [ns]
% mass          [n, 1] array or scalar, the mass of the particles.
% Output:
% p             [n, 3] the final momentum [atomic momentum unit]
% p_0           [n, 3] the time-zero momentum [atomic momentum unit]

p = [mass.*X./TOF_nominal mass.*Y./TOF_nominal].*general.constants({'amu'}).*1e6./ general.constants('momentum_au');
p_0 = [mass.*X_0./TOF_nominal mass.*Y_0./TOF_nominal].*general.constants({'amu'}).*1e6./ general.constants('momentum_au');

% If only scalars are used for the p_0 calculation:
if size(p_0, 1) ~= size(p, 1)
	p_0 = repmat(p_0, size(p, 1), 1);
end
end