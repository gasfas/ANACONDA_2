function [ beta ] = beta_function(theta, Intensity)
% This function fits the given intensity over an angle theta with the
% beta-function. 

% First we normalize the given intensity:

norm_factor = trapz(theta, Intensity);
Int_norm    = Intensity./norm_factor;

% Then we try to fit that with the beta distribution.
% Our first guess is uniform distribution:
beta_0 = 0;

fun = @(beta_fun, theta) theory.function.beta(theta, beta_fun);

beta = lsqcurvefit(fun,beta_0,theta,Int_norm, -1, 2);


end