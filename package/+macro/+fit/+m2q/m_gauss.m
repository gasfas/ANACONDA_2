function [I] = m_gauss(parameters, x)
% This function evaluates a function, defined by its parameters, at a point
% x. The parameters in this function are related to Gaussian profiles.

% The first column of parameters defines the mean value of the distribution
% The second column defines the Gaussian width
% The third column defines the Lorentzian width
% The fourth colum defines the peak height of the Voigt profile

% The number of rows determines the number of peaks

% TODO: extra info about linewidth independence, maybe with defining BC's

x_0         = parameters(:,1);
sigma       = parameters(:,2);% FWHM given
ph          = parameters(:,3); % Peak height

% we assume that the widths of all the signals is the same
sigma(:)	= mean(sigma);

% PDF = exp(-(x-mu).^2/(2*sigma^2)) ./ (sigma (sqrt(2*pi)))

I = zeros(size(x));
for i = 1:size(parameters, 1) % loop over the number of channels:
        peak_i = x_0(1) * fit.voigt(x, x_0, sigma);
    I = I + peak_i*ph(i);
end

end
