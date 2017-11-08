function [FWHM_below, FWHM_above]= FWHM_Y_peak(I, y_values, loc, I_peak)
% This function calculates the Full Width at Half Maximum (FWHM) of a peak
% found in a two-dimensional image along the x-axis.
% Inputs:
% I			[n, m] matrix with intensities. n: number of x values, m:
% number of y-values.
% y_values	[m, 1] array with the y-values associated for every column.
% loc		[m, 1] locations in I that belong to the peak that is of
%			interest.
% I_peak	(optional) The intensity at this peak. If not given, it is
%			calculated as I_peak = I(:,loc);
% Outputs;
% FWHM_below The Full width at half maximum (in y-units) below the peak.
% FWHM_above The Full width at half maximum (in y-units) above the peak.

if ~exist('I_peak', 'var')
	sub_peaks = sub2ind(size(I), loc, 1:size(I,2));
	I_peak = I(sub_peaks);
end

% calculate the y-values at the peaks:
y_peak = y_values(loc);

% Now we normalize the Intensity to the peak values:
I_norm	= I./(repmat(I_peak, 1, size(I,2)));

idx_peak = interp1(y_values, 1:length(y_values), y_peak, 'Nearest');

% Split the histogram in two parts: below and above the peak value, 
% and to avoid problems of non-singular interpolations, we remove other peaks
% if present
y_values_rep = repmat(y_values', size(I,1), 1);
is_below		= repmat(y_peak, 1, size(I,2)) > y_values_rep;
is_above		= repmat(y_peak, 1, size(I,2)) < y_values_rep;

% Find where the normalized Intensity matrix has a value below 0.5:
[I_below, I_above] = deal(I_norm, I_norm); 
[I_below(~is_below), I_above(~is_above)] = deal(1, 1);

[loc_I_below, loc_I_above] = deal(I_below < 0.5, I_above < 0.5);

% Find the first and last indeces of the values below and above:
[sub_below] = general.matrix.findfirst.findfirst(loc_I_below, 2, 1, 'last');
[sub_above] = general.matrix.findfirst.findfirst(loc_I_above, 2, 1, 'first');
% 
% FWHM_below	= zeros(size(loc));
% FWHM_above	= zeros(size(loc));
%
[min_valid_y_idx] = general.matrix.findfirst.findfirst(~isnan(I_below), 2, 1, 'first');
[max_valid_y_idx] = general.matrix.findfirst.findfirst(~isnan(I_above), 2, 1, 'last');

FWHM_below	= y_peak - y_values(min_valid_y_idx);
FWHM_above	= (y_values(max_valid_y_idx)-y_peak);

% % Only look at the indexes where we did find the I decrease below 0.5:
below_real	= (sub_below~=0 & ~isnan(sub_below));
above_real	= (sub_above~=0 & ~isnan(sub_above));
sub_below(~below_real)	= idx_peak(~below_real);
sub_above(~above_real)	= idx_peak(~above_real);

sub_below_pl_one		= min(sub_below+1, idx_peak);
sub_above_min_one		= max(sub_above-1, idx_peak);
% Fetch the intensities of the points one bin closer to the peak:
idx_below			= sub2ind(size(I_norm), (1:length(sub_below))', sub_below);
idx_above			= sub2ind(size(I_norm), (1:length(sub_above))', sub_above);
idx_below_pl_one	= sub2ind(size(I_norm), (1:length(sub_below))', sub_below_pl_one);
idx_above_min_one	= sub2ind(size(I_norm), (1:length(sub_above))', sub_above_min_one);

[Iy_below, Iy_below_pl_one]	= deal(I_norm(idx_below), I_norm(idx_below_pl_one));
[Iy_above, Iy_above_pl_one]	= deal(I_norm(idx_above), I_norm(idx_above_min_one));

% Interpolate to find a better approximation of the FWHM:
FWHM_below_all = y_peak - (y_values(sub_below) +  (y_values(sub_below_pl_one) - y_values(sub_below)).*(Iy_below - 0.5)./(Iy_below - Iy_below_pl_one));
FWHM_above_all = -y_peak + y_values(sub_above) +  (y_values(sub_above_min_one) - y_values(sub_above)).*(Iy_above - 0.5)./(Iy_above - Iy_above_pl_one);

% fill them in, but only if the FWHM is real:
FWHM_below(below_real)	= FWHM_below_all(below_real);
FWHM_above(above_real)	= FWHM_above_all(above_real);
end

	