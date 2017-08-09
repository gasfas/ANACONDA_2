function [R_i] = n_2_R(n_i, rho_vol)
% This function calculates the spherical radius of a particle with a given density:
% Inputs:
% n_i		[n, m] The sizes of all fragments
% rho_vol	[n, m] The volume density of the spheres [units/m^3]
% Outputs:
% R_i		The radii of the clusters with n_i sizes [Angstrom].

R_i = nthroot((n_i*3)./(rho_vol*pi*4), 3)*1e10;
end