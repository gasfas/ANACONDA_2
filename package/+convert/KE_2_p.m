function [ p_abs ] = KE_2_p(KE, m)
%This function calculates the absolute momentum from a given kinetic
%energy.
% Input:
% KE        [n,1], The energy of the relevant particle [eV]
% m         [n,1], The mass of the particle [n,1], [a.m.u]
% Output:
% p_abs     [n,1], The absolute value of the momentum, [atomic momentum unit]
% SEE ALSO: convert.p_2_KE convert.momentum

% Convert to SI units:
KE_joule    = KE.*general.constants({'eVtoJ'});
m_kg        = m .*general.constants({'amu'});
amomu       = general.constants('momentum_au');

% calculate the momentum:
p_abs = sqrt(KE_joule.*2.*m_kg)./amomu;

end