function [ D ] = D_sphere( n, method )
%This function calculates the sphere diameter of a 
% protonated ammonia ionic molecule, as a
%function of number of molecules, n.
% This function takes data from the article:
% H. Nakai et al. / Chemical Physics 262 (2000) 201-210
% table 1, B3LYP results.
% Input;
% n			number of molecules in the cluster
% method	(optional) can be 'interpolate'(default) or 'fit'
% Output
% D			The diameter of that cluster (Angstrom)
if ~exist('method', 'var')
	method = 'interpolate'
end

n_ref = [1 5 17];
D_ref = 2*[1.0312, ...
		1.0529+1.8838+1.0251, ...
		1.058+1.875+1.031+2.257+1.0241];
	
switch method
	case 'interpolate'
		% We interpolate to get D:
		D = interp1(n_ref, D_ref, n);
	case 'fit'
		warning('fit is not good; work on it!')
		% make a fit (cubic root):
		p = general.polyn.polyfitn(D_ref, n_ref, 'constant x^3');
		
		D = nthroot((n-p.Coefficients(1))/p.Coefficients(2), 3);
end
end

