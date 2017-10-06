function [ theta_count, containers_mids ] = H_solid_angle_polar(theta, binsize_mean, x_range, hist_factor)
% Polar histogram calculator, that takes the sin(theta) solid angle into account
% by varying the binsize.
% Input:
% theta			[n,1] angle data [rad]
% binsize_mean	[m, 1] average binsize [rad]
% x_range		[2, 1] the minimum and maximum angle [rad]
% hist_factor	(optional) scalar, multiplication factor of the histogram
% Outputs:
% theta_count	[m,1] the counts at the specified bins
% containers_mids

% specify the bin containers:
% containers =                plot.make_variable_binsize(binsize_mean, x_range, @(x) 1./sin(x));
containers =                 hist.bins(x_range, binsize_mean);

% remove the hits outside the range (to prevent edge effects, and convert 
% it to a one-dimensional array):
theta                        = theta(theta >= x_range(1) & theta <= x_range(2));

% bin the counts in the containers:
[theta_hist, containers_mids] = hist.H_1D(theta, containers);

% and apply the solid angle weighing factor:
theta_hist = theta_hist./(abs(sin(containers_mids)));%

theta_hist(sin(containers_mids) == 0) = NaN;

% Normalize the spectrum:
% norm_factor = trapz(containers, theta_hist);
if max(theta_hist) > 0
	norm_factor = max(theta_hist);
	
	theta_count = theta_hist./norm_factor;
else
	theta_count = theta_hist;
end

if exist('hist_factor', 'var')
	theta_count = hist_factor*theta_count;
end
end

