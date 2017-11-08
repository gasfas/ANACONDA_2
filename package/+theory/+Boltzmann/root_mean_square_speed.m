function [ v_rms ] = root_mean_square_speed( Temp, Mass )
%This function calculates the root mean square speed of an equilibrium
%Boltzmann gas.
% Input:
% Temp:     [Kelvin] The temperature of the gas 
% Mass:     [a.m.u.] The mass of the gas
% Output:
% v_rms:      [m/s] The root mean square velocity of the gas.

% Load the Boltzmann constant:
R   = general.constants('R');

v_rms = sqrt(3.*R.*Temp./Mass);

end

