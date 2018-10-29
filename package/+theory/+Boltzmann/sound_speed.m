function a = sound_speed(Temp, Mass, Heat_capac_ratio)
% This function calculates the local speed of sound of a given medium.
%	This function calculates the local speed of sound of an equilibrium
%	Boltzmann gas.
% Input:
% Temp:     [Kelvin] The temperature of the gas 
% Mass:     [a.m.u.] The mass of the gas
% Heat_capac_ration [] Heat capacity ratio (\gamma)
% Output:
% v_p:      [m/s] The most probable velocity of the gas.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

v_rms = theory.Boltzmann.root_mean_square_speed(Temp, Mass);
a	= sqrt(Heat_capac_ratio./3) .* v_rms;

end
