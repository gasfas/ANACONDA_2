function [ F ] = force_ampl(eps_m, q1, q2, r)
% This function calculates the absolute value (amplitude) of the 
% Coulomb force (in eV) as caused by two charges, separated a certain distance.
% Input:
% eps_m		scalar, the relative permittivity of the medium
% q1		scalar, the charges of the particles, [atomic charge unit] 
% q2		scalar, the charges of the particles, [atomic charge unit] 
% r			scalar, the center-of-mass distance between the particles [Ångstrom]
% Output:
% F			scalar, potential energy of the specified arrangement, [N]

eps_0 = general.constants('eps0');
eps = eps_m*eps_0;
q_Coulomb = general.constants('q');

F = (1./(4*pi*eps)) * q1.*q2.*(q_Coulomb.^2)./((r).^2);

end

