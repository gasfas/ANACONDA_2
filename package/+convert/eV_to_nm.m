function [ wavelength_nm ] = eV_to_nm( photon_energy_eV )
% This function converts a photon energy to a wavelength of that photon as
% it propagates through vacuum.
% Inputs:
% photon_energy_eV: The photon energy in eV (scalar or array)
% Outputs:
% wavelength_nm:    The wavelength of the given photon energies (scalar or
%                   array)
h       = general.constants('h');
c       = general.constants('c');
JtoeV   = general.constants('JtoeV');

wavelength_nm = 1e9*h*c./(photon_energy_eV./JtoeV);
end