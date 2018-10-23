function R_corr = R_circle(R_raw, theta_raw, R_maxs, R_avg, theta_scaling_factor)
% This function rescales the radius of the electron hits, due to
% non-roundness of the spectrometer.
% Inputs:
% -R_raw				[l,1] The radius before correction
% -theta_raw			[l,1] The theta before correction [rad]
% -R_maxs				[n,k] The radial positions of found maxima.
% -R_avg				[k,1] The radial positions of the average maxima.
% -theta_scaling_factor	[n,1] The corresponding angle.
% Outputs:
% R_corr				[l,1] The corrected radius.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% Calculate the radial shift that needs to be made:
R_shift_c = R_maxs - repmat(R_avg', length(theta_scaling_factor), 1);

% Interpolate the scaling factors to the points of the data:
R_corr = R_raw - interp2(R_avg, theta_scaling_factor, R_shift_c, R_raw, theta_raw, 'spline');

end