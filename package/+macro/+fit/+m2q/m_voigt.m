function [I] = m_voigt(parameters, x)
% This function evaluates a function, defined by its parameters, at a point
% x. The parameters in this function are related to voigt profiles.

% The first column of parameters defines the mean value of the distribution
% The second column defines the Gaussian width
% The third column defines the Lorentzian width
% The fourth colum defines the peak height of the Voigt profile

% The number of rows determines the number of peaks

% TODO: extra info about linewidth independence, maybe with defining BC's

x_0         = parameters(:,1);
Gam_G       = parameters(:,2); % function voigt expects FWHM
Gam_L       = parameters(:,3); % function voigt expects FWHM
ph          = parameters(:,4);

% we assume that the widths of all the signals is the same
Gam_G(:)	= mean(Gam_G);
Gam_L(:)	= mean(Gam_L);

I = zeros(size(x));
for i = 1:size(parameters, 1) % loop over the number of channels:
    peak_i = fit.voigt(x,x_0(i),Gam_G(i), Gam_L(i));
    I = I + peak_i*ph(i);
end

end