function [ y ] = gauss_PDF(x, mu, sigma, PH, show_components)
% [ y ] = Gauss_PDF(x, mu, sigma, PH)
% This function gives the PD from a Normal Gaussian distribution at
% any point x.
% Inputs:
% x         [n, 1] The x-points at which the data is requested
% mu        [nof_peaks, 1] The mean of the Normal distribution
% sigma     [nof_peaks, 1]The standard deviation of the distribution.
%           Note: if 'mu' and 'sigma' are arrays, multiple peaks overlay, and the
%           distribution is normalized according to the number of peaks.
% PH        [nof_peaks, 1], The Peak height of the peaks
% Outputs:
% y         [n, 1] The PD at the requested points

if ~exist('mu', 'var')
	mu = zeros(size(x));
end
if ~exist('sigma', 'var')
        sigma = 1;
end
if ~exist('PH', 'var')
    PH = ones(size(sigma));
end
if ~exist('show_components', 'var')
	show_components = false;
end

% we need all inputs to be a column vector:
if size(x,2) > 1
	x = transpose(x);
end
if size(mu,2) > 1
	mu = transpose(mu);
end
if size(sigma,2) > 1
	sigma = transpose(sigma);
end
if size(PH,2) > 1
	PH = transpose(PH);
end

% The peak height correction matrix:
PH_corr = diag(PH);

if length(mu) > 1
    x       = repmat(x, 1, length(mu));
    mu      = repmat(mu', size(x,1), 1);
    sigma   = repmat(sigma', size(x,1), 1);
end
% calculate the PDF:
if ~isempty(x)
	y = exp(- 0.5 * ((x - mu) ./ sigma) .^ 2) * PH_corr;
else
	y = [];
end
if show_components
	% We keep y separated for different gaussian peaks.
else
    % Unite the two curves:
    y = sum(y, 2);
end
end

