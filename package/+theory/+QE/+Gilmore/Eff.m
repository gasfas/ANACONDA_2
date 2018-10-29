function [ Efficiency ] = Eff(Mass_ion, Energy, Eff_0, Age_factor)
%This function calculates the ion detection eficiency, as predicted by
%Fraser (2002). It uses a table to interpolate between.
% Input:
% Mass_ion	[Dalton] Mass of the ion.
% Energy	[eV] Energy of the ion at splat (must be between 2 and 5 keV)
% Eff_0 	The detection efficiency at zero mass (function of MCP open area
%			ratio and grid gransmissions)
% Output:
% Efficiency Detection efficiency of the ion.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

fullfn = mfilename('fullpath'); datapath = fileparts(fullfn);
% Load the data:
d = load(fullfile(datapath, 'QE_i_2_kV_int.mat'));
Mass_2			= d.Mass;
Eff_2			= d.Eff_2;

d = load(fullfile(datapath, 'QE_i_5_kV_int.mat'));
Mass_5			= d.Mass;
Eff_5			= d.Eff_5;

Mass_ion		= Mass_ion.*Age_factor;

% interpolate the data for the energy requested:
weight_2		= interp1([2 5], [1 0], Energy/1e3);
% interpolate the Efficiencies for the mass requested:
req_Efficiency_2= interp1(Mass_2, Eff_2, Mass_ion, 'linear', 'extrap');
req_Efficiency_5= interp1(Mass_5, Eff_5, Mass_ion, 'linear', 'extrap');
% interpolate the efficiencies for the energy requested:

Eff_mod			= weight_2*req_Efficiency_2 + (1 - weight_2)*req_Efficiency_5;
% Efficiency		= Eff_0*(1 - Age_factor*(1 - Eff_mod));
Efficiency		= Eff_0*(Eff_mod);
end
% Efficiency = A_open.*(1 - exp(-1620.*((Energy./Mass).^1.75)));