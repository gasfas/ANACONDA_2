function [ V ] = potential(eps_m, q, r)
% This function calculates the couomb potential (in eV) as caused by two
% charges, separated a certain distance.
% Input:
% eps_m		scalar, the relative permittivity of the medium
% q			[n, 1], the charges of the particles, [atomic charge unit] 
% r			[nchoosek(n, 2), 1], the center-of-mass distance between the particles [Ångstrom]
%			The distances must be specified in the same order nchoosek
%			specifies the numbers. Example:
%			If 4 charges are specified, (nchoosek(4, 2)=) 6 combinations
%			are possible. Their respective distances should be specified as
%			follows:
% 				nchoosek(1:4, 2) = 
%				The distance from [	1 to 1]
%									1 to  2
% 									1 to  3
% 									1 to  4
% 									2 to  3
% 									2 to  4
% 									3 to  4]
%			If only one distance is given, all radii are assumed equal.
% Output:
% V			[eV] potential energy of the specified arrangement

eps_0 = general.constants('eps0');
eps = eps_m*eps_0;
eVtoJ = general.constants('eVtoJ');

dist_idx = general.stat.nchoose2(1:length(q));

if size(q,2) > 1
	q = q';
end
if size(r,2) > 1
	r = r';
end
if length(r) ~= size(dist_idx,1) % Not the expected number of radii: 
	%We assume all radii equal to the first given:
	r = r(1)*ones(size(dist_idx,1),1);
end

V = (1./(4*pi*eps)) * eVtoJ * 1e10 * sum(q(dist_idx(:,1)).*q(dist_idx(:,2))./(r));

end

