function [ Efficiency ] = Eff(Mass_ion, Energy, A_open)
%This function calculates the ion detection eficiency, as predicted by
%Fraser (2002). It uses a table to interpolate between.
% Input:
% Mass_ion	[Dalton] Mass of the ion minimum of 100 Da
% Energy	[eV] Energy of the ion at splat (must be between 2.5 and 5 keV)
% A_open	The open area fraction of the MCP (usually around 0.6)
% Output:
% Efficiency Detection efficiency of the ion.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

fullfn = mfilename('fullpath'); datapath = fileparts(fullfn);
% Load the data:
d = load(fullfile(datapath, 'QE_i_2_5_kV_int.mat'));
Mass			= d.Mass;
Eff_2_5			= d.Eff_2_5;

d = load(fullfile(datapath, 'QE_i_5_kV_int.mat'));
Eff_5			= d.Eff_5;

% interpolate the data for the energy requested:
weight_2_5		= interp1([2.5 5], [0 1], Energy/1e3);
Eff_mod			= weight_2_5*Eff_2_5 + (1 - weight_2_5)*Eff_5;
Eff				= A_open./0.6*interp1(Mass, Eff_mod, Mass_ion);
end
% Efficiency = A_open.*(1 - exp(-1620.*((Energy./Mass).^1.75)));