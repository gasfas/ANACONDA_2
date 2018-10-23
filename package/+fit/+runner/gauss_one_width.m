function [ y_fit ] = gauss_one_width(PM, xdata)
% peak fit of independent Gauss peaks.
% This function fits a set of close Gaussian peaks, all the same width
% Input parameters:
% xdata         [n,1]
% parameters    [first_peak_centre, last_peak_centre, peak_spacing, peak_height, p_A, sigma_G, sigma_L, noise_level]
% Output parameters:
% y_fit			[n, 1] the fitted y values
%
% Shell written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

nof_peaks = (length(PM)-2)/2;

%parameters (PM):
mu              = PM(1:nof_peaks);% Average of Gaussian peaks
sigma           = PM(nof_peaks+1)*ones(1,nof_peaks);% Gaussian standard deviation
PH              = PM(nof_peaks+2:2*nof_peaks+1);% Peak height
y_bgr           = PM(end);% background

% calculating ydata:
y_fit           = theory.function.gauss_PDF(xdata, mu, sigma, PH) + y_bgr;
end