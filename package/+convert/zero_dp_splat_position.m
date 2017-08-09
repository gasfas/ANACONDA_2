function [X_0, Y_0, T_0] = zero_dp_splat_position(TOF_no_dp, labels_mass, labels_charge, E_ER, sample_md)
% This function calculates the splat position in the case a hypothetical 
% particle that experienced no momentum shift upon ionization, hits the detector. 
% Inputs:
% TOF_zero_KE		The nominal TOF if the particle has no kinetic energy
% labels_mass		the defined label's masses
% labels_charge		the defined label's charges
% E_ER				The electric field in the ionization region [V/m];
% sample_md			The sample metadata, containing fields:
% 						T
%						m_avg
%						v_direction
% Outputs:
% X_0				The X-position of zero dp particles
% Y_0				The Y-position of zero dp particles
% T_0				The T-value of zero dp particles

% The most probable velocities are calculated for all the labels:
v_p                 = sample_md.Mach_number * theory.Boltzmann_v_p(sample_md.T, sample_md.m_avg);
% The radii where the these velocity/mass particles will splat:
X_0                 = sample_md.v_direction(1)*v_p.*TOF_no_dp*1e-6;
Y_0                 = sample_md.v_direction(2)*v_p.*TOF_no_dp*1e-6;
T_0                 = sample_md.v_direction(3)*v_p.*labels_mass./(labels_charge.*E_ER) + TOF_no_dp;

end