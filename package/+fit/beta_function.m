function [ beta ] = beta_function(theta, Intensity)
% This function fits the given intensity over an angle theta with the
% beta-function. (as defined in Cooper, J., and  R.N. Zare, 1969, in
% Lectures in Theoretical Physics, edited by S. Geltman, K.T. Mahanthappa, 
% and W.E. Britten (Gordon and Breach, New York), Vol. XI-C, pp. 317-337. )
% Inputs:
% theta		[n, 1], containers of the angles at which the intensity is defined
% Intensity [n, 1], array of intensities at specified angle theta
% Outputs:
% beta		scalar, at which the beta distribution fits the intensity best.
%
% written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% First we normalize the given intensity:

norm_factor = trapz(theta, Intensity);
Int_norm    = Intensity./norm_factor;

% Then we try to fit that with the beta distribution.
% Our first guess is uniform distribution:
beta_0 = 0;

fun = @(beta_fun, theta) theory.function.beta(theta, beta_fun);

beta = lsqcurvefit(fun,beta_0,theta,Int_norm, -1, 2);


end