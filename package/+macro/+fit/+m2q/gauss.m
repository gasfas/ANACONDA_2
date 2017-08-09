function [ ydata ] = gauss_peaks(parameters, xdata)
% This function draws Gaussian peaks from given parameters and x-values.
% Input parameters:
% xdata         [n,1]
% parameters    [first_peak_centre, last_peak_centre, peak_spacing, peak_height, p_A, sigma_G, sigma_L, noise_level]
% Output parameters:
% ydata

%parameters:
% mu              = repmat(parameters(end-6):parameters(end-4):parameters(end-5), length(xdata), 1);
centers         = linspace(parameters(end-6), parameters(end-5), round((parameters(end-5)-parameters(end-6)+parameters(end-4))./parameters(end-4)));
mu              = repmat(centers,  length(xdata), 1);
q               = size(mu,2) - 1; % q is the number of dice throws
peak_height     = parameters(end-3);
sigma_G         = parameters(end-2);% Gaussian standard deviation* ones(length(xdata), q+1);
sigma_L         = parameters(end-1);% Lorentzian standard deviation
noise_level     = parameters(end);
rph             = parameters(1:q+1); % The relative peak height.

% calculating ydata:
X               = repmat(xdata, 1, q+1); % the xdata in useful form
YV              = fit.voigt(X, mu, sigma_G, sigma_L); % Voigt profile
PDF             = rph;% the peaks in binomial distribution
y_norm          = sum(repmat(PDF, size(xdata,1), 1).*YV,2); % the normalized ydata
ydata           = peak_height./max(y_norm) * y_norm + noise_level; % adding the noise
end
