function I_rebin = H_1D_rebin_intensity(I, rebin_factor)
% re-binning (increasing binsize with rebin_factor)

% Re-bin it if requested:
hist_length = size(I, 1);
I           = I(1:floor(hist_length/rebin_factor)*rebin_factor); % skim off end 
I_rebin     = mean(reshape(I,rebin_factor,floor(hist_length/rebin_factor)),1); % re-bin

end
