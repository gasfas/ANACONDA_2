function [F] = Lorentz_force(q, E, v, B)
% This function calculates the 3-dimensional Lorentz force on a particle.
% Inputs:
% q         The charge of the particle [a.m.u.]
% E         The three-dimensional field strength (Ex, Ey, Ez) [v/m]
% v         The velocity of the particle [m/s]
% B         The three-dimensional magnetic field strength (Bx, By, Bz)
%           [Tesla]
% Outputs:
% F         The three-dimensional Lorenz force (Fx, Fy, Fz), [N]

% Convert to SI units:
q_Coulomb = q * general.constants('q');
% Calculate Lorentz force:
F = q_Coulomb * (E + cross(v, B));
end
