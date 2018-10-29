function [PDF_broad, PDF_G ] = Gaussian_broadening(x, PDF_slim, sigma)
% This function calculates PDF resulting from Gaussian (possibly
% instrumental) broadening by convoluting.
% Input;
% x         The x-values of the Probability Density Function
% PDF_slim  The Probability Density Function
% sigma     The average value sigma.
% Output:
% PDF_broad The convoluted, broadened PDF
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% make sure the x_range is bigger than 3* sigma (>99 % of Gauss PDF):
x_dummy_max = max([abs(min(x)) abs(max(x)) 3*sigma]);

% Create a symmetric dummy x:
x_dummy = linspace(-x_dummy_max, x_dummy_max, 2*length(x)-1);

% expand the PDF to values that fall out of the (non-symmetric) x-range, to make it symmetric around 0:
PDF_slim_symm = interp1(x,PDF_slim,x_dummy,'pchip',0);

% Create a PDF object for the normal distribution:
pd = makedist('Normal','mu',0,'sigma',sigma);

% Create the Gaussian PDF:
PDF_G = pd.pdf(x_dummy);

% Convolute a truncated PDF:
PDF_unnorm_symm = conv(PDF_slim_symm, PDF_G, 'same');

% Re-shape the PDF to the original x-values:
PDF_broad_unnorm = interp1(x_dummy, PDF_unnorm_symm, x);

% We give the new distribution the same normalization as the given one:
PDF_broad = PDF_broad_unnorm .* trapz(x, PDF_slim)./trapz(x, PDF_broad_unnorm);
end

