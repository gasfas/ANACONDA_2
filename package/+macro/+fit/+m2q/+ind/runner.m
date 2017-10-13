function [ ydata, y_comp] = runner(parameters, xdata)
%  This function fits a set of close Gaussian peaks, and does not assume a
% certain relation between the peak intensities.
% Inputs:
% parameters 	[n,1] array of fitting parameters for this specific fit.
% 		[first_peak_centre, last_peak_centre, peak_spacing, peak_height, p_A, sigma_G, sigma_L, noise_level]
% xdata 	[m, 1] the x-data at which to plot the fitting intensity line
% Outputs:
% ydata 	[m, 1] the fit at xdata, resulting from the given parameters

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
YV              = macro.fit.m2q.PDfunction.voigt(X, mu, sigma_G, sigma_L); % Voigt profile
PDF             = rph; % relative peak heights
y_norm			= repmat(PDF, size(xdata,1), 1).*YV;
y_sum			= sum(y_norm,2); % the normalized ydata

ydata           = peak_height./max(y_sum) * y_sum + noise_level; % adding the noise

if nargin > 1
	y_comp		= peak_height./max(y_sum) * y_norm + noise_level;
end
end
