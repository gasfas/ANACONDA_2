function [ Int_norm ] = beta_function ( theta, beta )
% This function returns the normalized intensity of the angular
% distribution probability density from the dipole approximation.
% Inputs:
% theta     [n, 1] The angle of emission direction with respect to polarization [rad]
% beta      scalar, characteristic dipole asymmetry parameter
% Outputs:
% Int       [n, 1] Normalized intensity [].
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

Int = 1./(4*pi) * (1 + beta/4*(3*cos(2*theta) + 1));
norm_factor = trapz(theta, Int);
Int_norm = Int./norm_factor;

end