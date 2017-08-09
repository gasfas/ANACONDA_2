function [FWHM_below, FWHM_above]= FWHM_Y_peak(I, y_values, loc, I_peak)
% This function calculates the Full Width at Half Maximum (FWHM) of a peak
% found in a two-dimensional image along the x-axis.
% Inputs:
% I			[n, m] matrix with intensities
% y_values	[m, 1] array with the y-values associated for every column.
% loc		[m, 1] locations in I that belong to the peak that is of
%			interest.
% I_peak	(optional) The intensity at this peak. If not given, it is
%			calculated as I_peak = I(:,loc);
% Outputs;
% FWHM_below The Full width at half maximum (in y-units) below the peak.
% FWHM_above The Full width at half maximum (in y-units) above the peak.

if ~exist('I_peak', 'var')
	I_peak = I(:,loc);
end

% calculate the y-values at the peaks:
y_peak = y_values(loc);

% Now we normalize the Intensity to the peak values:
I_norm	= I./(repmat(I_peak, 1, size(I,2)));

idx_peak = interp1(1:length(y_values), y_values, y_peak, 'Nearest');
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
[loc_below] = general.matrix.findfirst.findfirst(loc_I_below, 2, 1, 'last');
[loc_above] = general.matrix.findfirst.findfirst(loc_I_above, 2, 1, 'first');

FWHM_below = NaN*size(loc);
FWHM_above = NaN*size(loc);

% Calculate the y-positions from those by interpolation:
FWHM_below(loc_below>0) = abs(y_peak(loc_below>0) - y_values(loc_below(loc_below>0)));
FWHM_above(loc_above>0) = abs(y_peak(loc_above>0) - y_values(loc_above(loc_above>0)));
end

	