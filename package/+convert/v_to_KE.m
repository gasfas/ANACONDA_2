function energy_eV = v_to_KE(v_ms, mass_amu)
% Calculate the kinetic energy of a particle (ion/electron/etc) with a certain
% given mass and velocity.
% Inputs:
% v_ms              Velocity in meter/second of the particle
% mass_amu          Mass of the particle (atomic mass units)
% Outputs:
% energy_eV         Kinetic energy in eV of the particle

% Convert to SI units:
m_kg        = mass_amu .*general.constants({'amu'});

% calculate the kinetic energy (in eV):
energy_eV   = m_kg*v_ms.^2 /(2*general.constants({'eVtoJ'}));

end