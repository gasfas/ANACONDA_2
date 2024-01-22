function [ photon_energy_eV ] = nm_to_eV( wavelength_nm )
% This function converts the wavelength value of a photon propagating 
% through vacuum to its photon energy.
% Inputs:
% wavelength_nm:    The wavelength of the given photon energies (scalar or
%                   array)
% Outputs:
% photon_energy_eV: The photon energy in eV (scalar or array)
h       = general.constants('h');
c       = general.constants('c');
JtoeV   = general.constants('JtoeV');

photon_energy_eV    = h*c./(wavelength_nm.*1e-9)*JtoeV;

end