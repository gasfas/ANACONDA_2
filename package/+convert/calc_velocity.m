function v_ms = calc_velocity(energy_eV, mass_amu)
% Calculate the velocity of a particle (ion/electron/etc) with a certain
% given energy.
% Inputs:
% energy_eV         Kinetic energy in eV of the particle
% mass_amu          Mass of the particle (atomic mass units)
% Outputs:
% v_ms              Velocity in meter/second of the particle

v_ms            = sqrt(2*energy_eV.*general.constants('eVtoJ')./(mass_amu.*general.constants('amu')));

end