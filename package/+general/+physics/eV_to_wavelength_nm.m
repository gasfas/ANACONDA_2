function [output_wavelength_nm] = eV_to_wavelength_nm(input_energy_eV)
% Calculating the wavenelength of a given photon energy.

% Fetching the constants:
consts_temp         = deal(general.constants({'h', 'c', 'eVtoJ'}));
h_Planck            = consts_temp(1); 
c                   = consts_temp(2); 
eVtoJ               = consts_temp(3); 

% Energy in Joule:
energy_J            = input_energy_eV.*eVtoJ;
% Calculating the wavelength:
output_wavelength_nm = h_Planck .* c ./ energy_J*1e9;

