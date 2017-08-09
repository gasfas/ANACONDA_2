function [ Efficiency ] = Eff(Mass, md, detname)
%This function calculates the detection efficiency for a requested mass
%value.
% Inputs:
% Mass			Array of masses
% md			metadata, containing fields 'det' (detector info) and
%				'spec' (spectrometer info)
% Output:
% Efficiency	The modeled efficiency (fraction)
if ~exist('detname', 'var')
	detname = 'det1';
end

Ion_energy	= md.spec.volt.V_created - md.det.(detname).Front_Voltage;
Eff_0		= md.det.(detname).Eff.Gilmore.m_0;
Age_factor	= md.det.(detname).Eff.Gilmore.Age_factor;
Efficiency	= theory.QE.Gilmore.Eff(Mass, Ion_energy, Eff_0, Age_factor);
end

