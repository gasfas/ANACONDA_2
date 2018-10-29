function [ r ] = distance(eps_m, n, q,  V)
% This function calculates the distance between charge particles, from a given
% number of particles, charge, and the total coulomb potential (in eV) and 
% charges, separated a certain distance.
% Input:
% eps_m		scalar, the relative permittivity of the medium
% n			scalar, number of particles involved 
% q			scalar, the charges of all particles
%			assumed to be equal, [atomic charge unit] 
% V			[m, 1], potential energy of the specified arrangement [eV]
% Output:
% r			scalar, the center-of-mass distance between the particles, 
%			assumed to be equal [Ångstrom]
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

eps_0 = general.constants('eps0');
eps = eps_m*eps_0;
eVtoJ = general.constants('eVtoJ');

r = NaN*ones(size(V));

if any(n > 1)
% 	at least two particles need be involved to define a potential.
	% The number of particle-particle interactions depends on n:
	nof_crossterms			= NaN * ones(size(V));
	nof_crossterms(n>1)		= general.stat.nof_comb(n(n>1),2);
	% The distance between the particles can be calculated:
	r = (1./(4*pi*eps)) * eVtoJ * nof_crossterms * 1e10 * q^2 ./ V;

end

end