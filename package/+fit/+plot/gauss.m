function [ ydata, hLine ] = gauss(ax, xdata, FP, plotstyle)
% Convenience function to plot fitted Gaussian curves.
% Inputs:
% xdata         [n, 1] xdata to calculate the Probability Density (PD) at
% FP            Struct with the fields:
%               FP.mu.value     The mean of all peaks
%               FP.sigma.value  The standard deviation of all peaks
%               FP.PH.value     The peak height of all peaks
%               FP.y_bgr.value  The background y-value.

ydata = theory.function.gauss_PDF(xdata, FP.mu.value, FP.sigma.value, FP.PH.value) + FP.y_bgr.value;

hLine = plot(ax, xdata, ydata);

if nargin >= 4
    plot.makeup(ax, plotstyle)
end

end

