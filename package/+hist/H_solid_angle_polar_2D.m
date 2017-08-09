function [ Count, theta_bins, R_bins] = H_solid_angle_polar_2D(theta, R, theta_bins_in, R_bins_in)
% Polar histogram calculator, that takes the sin(theta) solid angle into account
% by varying the binsize, for two-dimensional data.
% Input:
% axhandle:     The handle that the figure will be plotted into
% theta:        [n, 1] The theta-data [rad]
% R				[n, 1] The corresponding radial data [-]
% binsize_mean  [2,1] The average binsize of the histogram [rad], [R_unit]
% theta_range   [2,1] The maximum and minimum theta coordinate to include in the histogram
% R_range		[2,1] The maximum and minimum radial coordinate to include in the histogram


% bin the counts in the containers:
[Count, theta_bins, R_bins] = hist.H_2D(theta, R, theta_bins_in, R_bins_in);


% and apply the solid angle weighing factor:
weigh_factor = repmat(abs(sin(theta_bins)), 1, length(R_bins));
Count = Count./(weigh_factor);%
% If divided by zero, dismiss that datapoint:
Count(weigh_factor == 0) = NaN;

% % Normalize the spectrum:
% % norm_factor = trapz(containers, theta_hist);
% if max(Count) > 0
% 	norm_factor = max(Count);
% 	
% 	theta_hist_norm = Count./norm_factor;
% else
% 	theta_hist_norm = Count;
% end

end

