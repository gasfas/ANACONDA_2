function [R] = B_helicoil_radius(q, m, v, B)
% This function calculates the helicoil radius of a charged particle due to a uniform magnetostatic force.
% Inputs:
% q         The charge of the particle [a.m.u.]
% m         The partilce's mass [Da]
% v         The velocity of the particle  perpendicular to the magnetic field [m/s]
% B         The absolute value of the magnetic field strength [Tesla]
% Outputs:
% F         The three-dimensional Lorenz force (Fx, Fy, Fz), [N]

% Convert to SI units:
q_Coulomb   = q * general.constants('q');
m_kg        = m * general.constants('amu');

% Calculate helicoil radius:
R = m_kg .* v ./(q_Coulomb .* B);
end
