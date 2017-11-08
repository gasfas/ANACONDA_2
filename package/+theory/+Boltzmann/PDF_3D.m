function [ PDF ] = PDF_3D(E_eV, Temp)
%This function gives the normalized Maxwell-Boltzmann 
% Probability Density Function (PDF), from a given momentum vector 2-norm.
% Input:
% E_eV      [eV] the (Kinetic) Energy.
% Temp:     [Kelvin] The temperature of the gas 
% Mass:     [a.m.u.] The mass of the gas
% Output:
% PDF:      [-] The probability at the given p_norm of the gas.
% Equations from https://en.wikipedia.org/wiki/Maxwell%E2%80%93Boltzmann_distribution#Distribution_for_the_momentum_vector

% Load the Boltzmann constant:
kb  = general.constants('kb'); % Boltzmann constant;
eV2J= general.constants('eVtoJ'); % momentum atomic units
% Convert to SI units:
E           = E_eV*eV2J;

PDF = 2*sqrt(E./(pi)).* (1./kb/Temp)^(3/2) .*exp(-E./(kb.*Temp)).*eV2J;

end

