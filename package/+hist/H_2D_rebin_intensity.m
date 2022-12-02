function I_rebin = H_2D_rebin_intensity(I, rebin_factor)
% re-binning (increasing binsize, decreasing number of bins) of a given 2D
% matrix I. Inputs:
% - I: [n,m] The binned histogram matrix.
% - rebin_factor: [1,2] or scalar: The rebinning factor in column and row direction.
% If a scalar is given, the rebinning is assumed the same in both directions.
% Ouput:
% I_rebin: [floor(n/rebin_factor(1)), floor(m/rebin_factor(end))]: The
% re-binned 2-dimensional matrix.

% Fetch the matrix size:
[hist_x, hist_y] = size(I);
% skim off the last mod(rebin_factor,n) elements that don't fit in. a full bin.
I           = I(1:floor(hist_x/rebin_factor(1))*rebin_factor(1), 1:floor(hist_y/rebin_factor(end))*rebin_factor(end));
% Calculate the skimmed off I size:
[hist_x_skimmed, hist_y_skimmed] = size(I);
% Re-bin by generating a 3D matrix of which the average is calculated:
I_rebin     = mean(reshape(I, [floor(hist_y_skimmed/rebin_factor(end)),rebin_factor(end), hist_x_skimmed]),1);
I_rebin     = permute(I_rebin,[2,3,1]);
% I_rebin     = mean(reshape(I,rebin_factor,floor(hist_length/rebin_factor)),1); % re-bin

end
