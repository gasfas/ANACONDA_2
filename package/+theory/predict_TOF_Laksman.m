function [ TOF_total, TOF_ER, TOF_AR, TOF_DT, Ek_s2a, Ek_a2d] = predict_TOF_Laksman (p_ini, m, q, volt, dist)
% The TOF of a zero kinetic energy in a two-field Wiley-Mclaren spectrometer 
% is predicted from simple electrostatic formula's. Be aware that this 
% prediction does not take any abberations or field irregularities 
% (eg. lens) into account. Using similar to Joakim's thesis.
% Input 
% p_ini         [kg*m/s] initial momentum of the particle
% m             [a.m.u] mass of the particle.
% q             elementary charge of the particle (so electron: q = -1)
% volt          struct with the fields giving the voltages:
%   Ve2s          [V] Voltage of grid separating electron side and source region
%   Vs2a			[V] Voltage of grid separating source and acceleration region;
%   Va2d			[V] Voltage of grid separating acceleration region and drift tube;
% dist          struct with the fields giving the relevant distances:
%   s             [m] electron grid to ion acceleration region grid  
%   s0 			[m] source to ion acceleration region grid  
%   d 			[m] length of accelation region
%   D 			[m] length of drift tube
% Output:
% TOF_total     [ns] Predicted total Time Of Flight.
% TOF_ER        [ns] Predicted Time Of Flight in extraction region (or interaction region).
% TOF_AR        [ns] Predicted Time Of Flight in acceleration region.
% TOF_DT        [ns] Predicted Time Of Flight in drift tube.
% Ek_s2a      	[Joule] source region to acceleration region
% Ek_a2d      	[Joule] acceleration region to drift region
% SEE ALSO: correct.Detector_abb, general.TOF_section
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

Ve2s = volt.Ve2s; Vs2a = volt.Vs2a; Va2d = volt.Va2d;
s = dist.s; s0 = dist.s0; d = dist.d; D = dist.D;

% preparing needed values:
[dummy]     = general.constants({'q', 'amu'});
q_C         = q * general.constants('q');  % [C] particle charge in Coulomb
m_kg        = m * general.constants('amu');  % [kg] particle mass;
E_ER        = theory.TOF.calc_field_strength(Vs2a, Ve2s, s); % [V/m] Electrostatic field strength in the source region
E_AR        = theory.TOF.calc_field_strength(Va2d, Vs2a, d); % [V/m] Electrostatic field strength in the acceleration region

% Calculating TOF:
[TOF_ER, p_fin_ER]      = theory.TOF.section(E_ER, s0, p_ini, m_kg, q_C); %[ns]
[TOF_AR, p_fin_AR]      = theory.TOF.section(E_AR, d, p_fin_ER, m_kg, q_C); %[ns]
[TOF_DT]                = theory.TOF.section(0, D, p_fin_AR, m_kg, q_C); %[ns]

TOF_total   = TOF_ER + TOF_AR + TOF_DT;

% Calculating the Kinetic energy at the separation between regions (grids):
Ek_s2a      = E_ER * s0 * q_C ; %[Joule] source region to acceleration region
Ek_a2d      = Ek_s2a + E_AR * d; %[Joule] acceleration region to drift region

end

