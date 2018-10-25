function [v_MB, v_MBx, v_MBy, v_MBz] = fetch_v_MB(sample_md)
% This function fetches the molecular beam velocity from
% metadata. If it is directly defined in the sample metadate, it will be
% copied. If the mach number, temperature, average mass and heat capacity
% ratio are defined, the beam speed is calculated
% The user can define the velocity directly, or a combination of mass,
% temperature and heat capacity ratio.
% Input
% sample_md		The sample metadata
% Output
% v_MB			The molecular beam velocity
% v_MBx			The molecular beam velocity in x-direction
% v_MBy			The molecular beam velocity in y-direction
% v_MBz			The molecular beam velocity in z-direction
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

try v_MB				= sample_md.v_MB;
catch v_MB				= sample_md.Mach_number * theory.Boltzmann.sound_speed(sample_md.T, sample_md.m_avg, sample_md.Heat_capac_ratio);
end
if nargout > 1
	[v_MBx, v_MBy, v_MBz] = deal(sample_md.v_direction(1) * v_MB, sample_md.v_direction(2) * v_MB, sample_md.v_direction(3) * v_MB);
end