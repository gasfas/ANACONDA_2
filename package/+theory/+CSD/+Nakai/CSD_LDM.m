function [ CSD ] = CSD_LDM(C_nr, n, method, include_asymm)
% This function calculates the predicted charge separation distance in
% protonated ammonia ionic molecule, as a
%function of number of molecules, n.
% This function takes data from the article:
% H. Nakai et al. / Chemical Physics 262 (2000) 201-210
% table 1, B3LYP results.
% Input;
% C_nr		number of fragments/charges.
% n			number of molecules in the cluster
% method	(optional) can be 'interpolate'(default) or 'fit'
% include_asymm logical, whether or not to include asymmetric fission.
% Output
% D			The diameter of that cluster (Angstrom)
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if ~exist('method', 'var')
	method = 'interpolate';
end
if ~exist('include_asymm', 'var')
	include_asymm = false;
end

shell_closed_n = [1 5 17];

switch C_nr
	case 2
		if include_asymm
			% Find the combinations that come to the given n:
			n_combs					= general.stat.nchoose2(shell_closed_n);
			n_pairs					= sum(n_combs, 2);
			% If they are found in the searched n, they are calculated first (asymmetric fission pairs can be among them):
			[is_n_found, n_subs]	= ismember(n, n_pairs);
			CSD(is_n_found)		= theory.CSD.Nakai.D_sphere(n_combs(n_subs(is_n_found),1), method)/2 + theory.CSD.Nakai.D_sphere(n_combs(n_subs(is_n_found),2), method)/2;
			CSD(~is_n_found)	= theory.CSD.Nakai.D_sphere(n(~is_n_found)/2, method);
		end
		CSD = theory.CSD.Nakai.D_sphere(n/2, method);
	case 3
		CSD = (1+sqrt(3)/2)/2*theory.CSD.Nakai.D_sphere(n/3, method);
end
	
end

