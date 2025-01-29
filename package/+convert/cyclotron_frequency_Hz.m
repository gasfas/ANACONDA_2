function [f] = cyclotron_frequency_Hz(q, B, m)
% This function calculates the 3-dimensional Lorentz force on a particle.
% Inputs:
% q         The charge of the particle [a.u.]
% B         The three-dimensional magnetic field strength (Bx, By, Bz)
%           [Tesla]
% q         The mass of the particle [a.m.u.]

% Outputs:
% f         cyclotron frequency [rad/s]
% Convert to SI units:
q_Coulomb   = q * general.constants('q');
m_kg        = m * general.constants('amu');

f = q_Coulomb*B./(m_kg*2*pi);

end
