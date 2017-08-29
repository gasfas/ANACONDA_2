function [ dKE ] = p_2_KE(p_0, p_1, m)
%This function calculates the difference in Kinetic energy between two
%momenta. dKE = KE(1) - KE(2)
% Input:
% p0        The initial momentum array [n,3], [atomic momentum unit]
% p1        The final momentum array [n,3], [atomic momentum unit]
% m         The mass of the particle [n,1], [atomic mass unit]
% Output:
% dKE       The difference in Kinetic energy between state 1 and 2 [eV]
% SEE ALSO: convert.momentum convert.KE_2_p

eVtoJ   = general.constants('eVtoJ');
amu     = general.constants('amu');
amomu   = general.constants('momentum_au');

dp      = amomu * (p_1 - p_0);

dKE     = (1./(2*m*amu)) .* ( general.vector.norm_vectorarray(dp, 2).^2 ) ./ eVtoJ;

end