function [Temp, sigma, KE_mean] = MB_KE(KE_container, PDF_exp, Temp_0, sigma_0)
%This function fits the Kinetic energy distribution to the theoretical
%Maxwell-Boltzmann distribution, broadened with a Gaussian distribution.
% Inputs: 
% KE_container		[n,1] the Kinetic energy values at which the
%					PDF is calculated
% PDF_exp			[n, 1] The probability density function at the
%					KE_container points
% Temp_0			scalar, the initial guess of the temperature in the Maxwell-Boltzmann
%					model.
% sigma_0			scalar, the initial guess of the broadening of the Gaussian distribution
% Outputs:
% Temp				The fitted temperature from the least-square fit
% sigma				scalar, the broadening of the Gaussian distribution
% KE_mean			The average kinetic energy of the given distribution
%
% written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% x(1) = Temp x(2) = sigma
% create the anonymous function:
fun = @(x, KE) fit.runner.MB_KE(KE, x(1), x(2));

[x] = lsqcurvefit(fun, [Temp_0, sigma_0], KE_container, PDF_exp, [0 0], [1e5 range(KE_container)]);

Temp    = x(1);
sigma   = x(2);

if nargout >= 3
	k = general.constants('kb');
	eVtoJ = general.constants('eVtoJ');
	KE_mean = 4*k*Temp./pi /eVtoJ;
end

