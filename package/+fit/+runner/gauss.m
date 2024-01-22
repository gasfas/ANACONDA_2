function [ y_fit ] = gauss(PM, xdata)
% peak fit of independent Gauss peaks.
% This function fits a set of close Gaussian peaks, and thereby assumes a
% binomial distribution (see
% http://hyperphysics.phy-astr.gsu.edu/hbase/math/dice.html#c2)
% Input parameters:
% xdata         [n,1]
% parameters    [peak_centres, sigma, PH, y_bgr]
% Output parameters:
% y_fit			[n, 1] the fitted y values
%
% written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

nof_peaks = (length(PM) -2)/3;

%parameters (PM):
mu              = PM(1:nof_peaks);% Average of Gaussian peaks
sigma           = PM((nof_peaks+1):(2*nof_peaks));% Gaussian standard deviation
PH              = PM((2*nof_peaks+1):(3*nof_peaks));% Peak height
y_bgr           = PM(end);% background

% calculating ydata:
y_fit           = theory.function.gauss_PDF(xdata, mu, sigma, PH) + y_bgr;
%
% figure(2); hold on
% plot(xdata, y_fit)
% pause
end