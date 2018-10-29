function [TOF, p_fin, E_fin] = TOF_section(E, l, p_ini, m_kg, q)
% This function calculates the TOF of a particle through a single section
% Inputs:
% E         The electric field strength in the section [V/m]
% l         The distance from the particle to the end of the section [m]
% m_kg      The mass of the particle [kg]
% p_ini     The initial momentum of the particle (positive means in line with the electrostatic force) [atomic momentum unit]
% q         The charge of the particle [C]
% Output
% TOF       The TOF of the section [ns]
% v_fin     The final momentum [atomic momentum unit]
% SEE ALSO: correct.predict_TOF_Laksman.m
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% convert momentum atomic units to kg*m/s:
p_ini = p_ini * general.constants('momentum_au') ;

% This calculation is done by solving the polynomial equation:
% 0.5*q*E*TOF^2 + m*v_ini*TOF - m*l = 0
a           = 0.5*q*E;
b           = p_ini;
c           = -m_kg*l;
D           = (b.^2 - 4*a*c);
if D < 0
    error('the electric field is opposite the direction of the section end, particle will never reach it')
elseif a == 0
    TOF     = -c./b;
else
    TOF     = (-b + sqrt(D))./(2*a);
end

% Only positive TOF are real solutions:
TOF         = TOF(find(TOF>=0)) * 1e9;
% Calculate the energy and velocity when leaving the section:
E_fin       = 0.5*p_ini.^2./m_kg + E*l*q; %[Joules]
p_fin       = sqrt(2*m_kg.*E_fin)./general.constants('momentum_au'); %[kg*m/s]
end

