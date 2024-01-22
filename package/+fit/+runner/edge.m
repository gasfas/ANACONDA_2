function [y_fit] = edge(PM, xdata)
% peak fit of edge.
% This function  a set of close Gaussian peaks, all the same width:
% Input parameters:
% PM            [first_peak_centre, last_peak_centre, peak_spacing, peak_height, p_A, sigma_G, sigma_L, noise_level]
% xdata         [n,1]
% Output parameters:
% y_fit			[n, 1] the fitted y values
%
% Shell written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if length(PM) > 3 % At least one gaussian peak
    nof_peaks = (length(PM)-4)/2;
    %parameters (PM):
    mu              = PM(1:nof_peaks);% Average of Gaussian peaks
    sigma           = PM(nof_peaks+1)*ones(1,nof_peaks);% Gaussian standard deviation
    PH              = PM(nof_peaks+2:2*nof_peaks+1);% Peak height
    % calculating ydata:
    y_fit           = theory.function.gauss_PDF(xdata, mu, sigma, PH) + y_bgr;
else
    nof_peaks = 0;
    y_bgr           = PM(1);% background
    edge            = PM(2);
    edge_slope      = PM(3);
    % calculating ydata:
    y_fit           = (xdata > edge).*(xdata-edge).*edge_slope + y_bgr;
end
end