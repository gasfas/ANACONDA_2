function [ v_p ] = v_p( Temp, Mass )
%This function calculates the most probable velocity of an equilibrium
%Boltzmann gas.
% Input:
% Temp:     [Kelvin] The temperature of the gas 
% Mass:     [a.m.u.] The mass of the gas
% Output:
% v_p:      [m/s] The most probable velocity of the gas.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% Load the Boltzmann constant:
R   = general.constants('R');
% Note that this formula ignores gamma/(gamma-1).
v_p = sqrt(2.*R.*Temp./Mass);

end

