function [histogram] = solid_angle_correction(histogram, theta_dim_nr)
% This function applies a solid angle correction to given histogram data.
% Inputs:
% histogram	struct, containing the fields 'Count' (the histogram matrix),
%			and 'midpoints', giving the midpoints in each dimension.
% Outputs:
% histogram; the same struct, but now with corrected intensity.

% We fetch the angular midpoints:
dim				= general.matrix.nof_dims(histogram.Count);
% Calculate the weigh factor:
switch dim
	case 1
		weigh_factor = abs(sin(histogram.midpoints));
	case 2
		theta_midpoints = histogram.midpoints.(['dim' num2str(theta_dim_nr)]);
		switch theta_dim_nr
			case 1
				weigh_factor = repmat(abs(sin(theta_midpoints)), 1, length(histogram.midpoints.dim2));
			case 2 
				weigh_factor = repmat(abs(sin(theta_midpoints))', length(histogram.dim1), 1);
		end
end

% and apply the solid angle weighing factor:
histogram.Count = histogram.Count./(weigh_factor);%
% If divided by zero, dismiss that datapoint:
histogram.Count(weigh_factor == 0) = NaN;
end