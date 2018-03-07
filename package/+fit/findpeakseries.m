function [xpeaks, ypeaks, xwidths] = findpeakseries (xdata, ydata, MinPeakProminence, spacing_min, spacing_max, include_first, include_last, choose_series)
% This function finds a peak series in a given histogram/function. 

%% Find all peaks:
	[ypeaks_all, xpeaks_all, xwidths_all] = findpeaks(ydata, xdata, 'MinPeakProminence', MinPeakProminence);

%% Find peaks of interest
	% Now that the peaks are found, we try to extract the peaks of interest from them:
	% Make a difference matrix:
	diff_mat = write_diff_mat(xpeaks_all);
	% Identify the peak series with the correct spacing:
	is_spacing_of_interest_l	= diff_mat >= spacing_min & diff_mat <= spacing_max;
	is_spacing_of_interest_u	= diff_mat >= -spacing_max & diff_mat <= -spacing_min;
	is_spacing_of_interest		= is_spacing_of_interest_l | is_spacing_of_interest_u;
	
	% Extract the locations of correct spacing ( a peak in a series has a
	% peak at the left and right at the correct spacing):
	idx_spacing_of_interest = boolean(sum(is_spacing_of_interest_l, 1)>=1 & sum(is_spacing_of_interest_u, 1)>=1); % Note that a peak can be a superposition of two different series.
	
	% Now there can still be multiple peak series with the same spacing.
	% This routine automatically picks the longest series:
	xpeaks_cur	= xpeaks_all(idx_spacing_of_interest);
	diff_mat	= write_diff_mat(xpeaks_cur);
	
	% if there are indeces above or below the two off-axis diagonals, 
	% there are mutliple peak series.
	corr_spacing_mat = abs(diff_mat) > spacing_min & abs(diff_mat) < spacing_max;
	[rows, cols] = ind2sub(size(corr_spacing_mat), find(corr_spacing_mat));
% 	if max(abs(rows- cols)) > 1
		[is_spacing_of_interest, idx_spacing_of_interest] = select_series(xpeaks_all, is_spacing_of_interest, idx_spacing_of_interest,spacing_min, spacing_max, choose_series);
% 	end
	
%% Select first/last peak
	% Take the first/last of the series, only connected to a peak higher/lower in
	% the series:
	if include_first
		isbefore_second_peak = ~idx_spacing_of_interest & (1:length(ypeaks_all)) < find(idx_spacing_of_interest, 1, 'first');
		% Fill in:
		idx_spacing_of_interest(find(sum(is_spacing_of_interest, 1)>0 & isbefore_second_peak, 1, 'last')) = true;
	end
	if include_last
		isafter_second_last_peak = ~idx_spacing_of_interest & (1:length(ypeaks_all)) > find(idx_spacing_of_interest, 1, 'last');
		% Fill in:
		idx_spacing_of_interest(find(sum(is_spacing_of_interest, 1)>0 & isafter_second_last_peak, 1, 'first')) = true;
	end
	% Finally, extract the peaks of interest:
	[xpeaks, ypeaks, xwidths] = deal(xpeaks_all(idx_spacing_of_interest), ypeaks_all(idx_spacing_of_interest), xwidths_all(idx_spacing_of_interest));
	
% 	figure; plot(xdata, ydata, 'r'); hold on; plot(xpeaks_all, ypeaks_all, 'g*'); plot(xpeaks, ypeaks, 'k*');
end

%% Subfunctions:

function diff_mat = write_diff_mat(vector)

diff_mat = repmat(vector, 1, length(vector)) - repmat(vector', length(vector), 1);

end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [is_series_of_interest, idx_series_of_interest] = select_series(xpeaks_all, is_spacing_of_interest, idx_spacing_of_interest, spacing_min, spacing_max, choose_series)
xpeaks_sel	= xpeaks_all(idx_spacing_of_interest);
diff_mat_cur= write_diff_mat(xpeaks_sel);
corr_spacing_mat = abs(diff_mat_cur) > spacing_min & abs(diff_mat_cur) < spacing_max;
[rows, cols] = ind2sub(size(corr_spacing_mat), find(corr_spacing_mat));
ind_filled = []; ind_all = 1:length(xpeaks_sel);
i = 0;

while ~isempty(setdiff(ind_all, ind_filled))
	i = i + 1;
	% Check which indices are not yet filled into a series:
	ind_left	= setdiff(ind_all, ind_filled);
	ind			= ind_left(1); 
	series_incomplete = true; xpeaks_cur = []; ind_cur = [];
		while series_incomplete
			xpeaks_cur = [xpeaks_cur xpeaks_sel(ind)];
			ind_old = ind; ind_cur = [ind_cur ind];
			ind_filled = sort([ind_filled, ind]);
			% Find where the peak is located in the matrix:
			ind		= find(corr_spacing_mat(:, ind), 1, 'first');
			% Take the first one that is not yet treated:
			% remove the collected peak from the matrix:
			corr_spacing_mat(:, ind_old) = false;
			corr_spacing_mat(ind_old, :) = false;
			
			series_incomplete = ~isempty(ind);
		end
		% Fill the series in a struct:
		series.(['nr' num2str(i)]).xpeaks = xpeaks_cur;
		series.(['nr' num2str(i)]).ind		= ind_cur;
		series_length(i) = length(xpeaks_cur);
		% rerun 
		
end
idx_series_of_interest	= idx_spacing_of_interest;
is_series_of_interest	= is_spacing_of_interest;
if i > 0
	switch choose_series
		case 'longest'
			% Take the longest series:
			[~, series_nr]	= max(series_length);
		case 'first'
			series_nr	= 1;
	end
	xpeaks_longest_series	= series.(['nr' num2str(series_nr)]).xpeaks;
	ind_shorter_series		= setdiff(ind_all, series.(['nr' num2str(series_nr)]).ind);
	idx_series_of_interest	= idx_spacing_of_interest;
	idx_series_of_interest(idx_series_of_interest) = ismember(xpeaks_sel, xpeaks_longest_series);
	% remove the peaks from the series of interest:
	is_series_of_interest	= is_spacing_of_interest;
	idx_short_series		= idx_spacing_of_interest;
	idx_short_series(idx_spacing_of_interest) = ismember(ind_all, ind_shorter_series);
	is_series_of_interest(:,idx_short_series) = false;
	is_series_of_interest(idx_short_series,:) = false;
end
end
