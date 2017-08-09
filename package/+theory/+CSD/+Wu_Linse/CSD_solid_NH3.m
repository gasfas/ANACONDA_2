function [CSD, asymmetry_factor] = CSD_solid_NH3(n_i)
% This function calculates the Charge Separation Distance between ammonia
% cluster fragments with a total n_total monomer units. Solid density of
% NH3 is assumed.
% Inputs:
% n_i				[k, C_nr] The sizes of the fragments
% Outputs:
% CSD				[k, 1]The charge separation distance [Angstrom]
% asymmetry_factor	[k, 1] The factor defined as: 
% 					std(n1, n2, ...)./mean(n1, n2, ...), with ni the number
% 					of monomers in a fragment

rho_vol		= 2.7055e28; %[molecules/m3]

% calculate the asymmetry factor from the fragment sizes:
asymmetry_factor = theory.CSD.asymmetry_factor(n_i);
C_nr = size(n_i,2);
if C_nr == 2
	R	= theory.CSD.n_2_R(n_i, rho_vol);
	CSD = sum(R, 2);
elseif C_nr == 3
	R	= theory.CSD.n_2_R(n_i, rho_vol);
	CSD = 2*mean(R, 2);
else
	error('TODO: CSD cannot be calculated for higher C_nrs yet')
end

	 