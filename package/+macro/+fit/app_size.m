function  [fit_param] = app_size(data_in, metadata_in, det_name)
% This macro finds appearance size of a series of peaks. For instance, the 
% appearance size of a set of doubly charged clusters.
% Input:
% data_in        The experimental data, already converted
% metadata_in    The corresponding metadata
% det_name      (optional) The name of the detector
% Output:
% data_out      The output data with converted data.
% metadata_out  The corresponding metadata

if exist(det_name, 'var')
    detnames = det_name;
else % No detector name is given, so we fetch all detector names:
    detnames = fieldnames(metadata_in.det);
end

for i = 1:length(detnames)
    detname = detnames{i};
	
    fit_md = metadata_in.fit.(detname).app_size;
	
	if general.struct.issubfield(fit_md, 'cond') % condition applied:
		e_f = macro.filter.conditions_2_filter(data_in, fit_md.cond);
		% Make the histogram:
		histogram = macro.hist.create.hist(data_in, fit_md.hist, e_f);
	else % just raw m2q data:
		histogram = macro.hist.create.hist(data_in, fit_md.hist);
	end
	
	% Apply a histogram smoothing, if requested:
	try histogram.Count = medfilt1(histogram.Count, fit_md.medfilt_order); end
	
	%% Find all peaks:
	[y_peaks, x_peaks] = findpeaks(histogram.Count, histogram.midpoints, ...
					'MinPeakProminence', fit_md.MinPeakProminence);
				
	%% Find peaks of interest
	% Now that the peaks are found, we try to extract the peaks of interest from them:
	% Make a difference matrix:
	diff_mat = repmat(x_peaks, 1, length(x_peaks)) - repmat(x_peaks', length(x_peaks), 1);
	% Identify the peak series with the correct spacing:
	is_spacing_of_interest = diff_mat >= fit_md.peaks_of_interest.spacing.min & diff_mat <= fit_md.peaks_of_interest.spacing.max | ...
		diff_mat >= -fit_md.peaks_of_interest.spacing.max & diff_mat <= -fit_md.peaks_of_interest.spacing.min;

	% Extract the locations of correct spacing ( a peak in a series has a
	% peak at the left and right at the correct spacing):
	idx_spacing_of_interest = boolean(sum(is_spacing_of_interest, 1)>=2); % Note that a peak can be a superposition of two different series.

	%% Select first/last peak
	% Take the first/last of the series, only connected to a peak higher/lower in
	% the series:
	if general.struct.probe_field(fit_md.peaks_of_interest, 'ifdo.include_first')
		isbefore_second_peak = ~idx_spacing_of_interest & (1:length(y_peaks)) < find(idx_spacing_of_interest, 1, 'first');
		% Fill in:
		idx_spacing_of_interest(find(sum(is_spacing_of_interest, 1)>0 & isbefore_second_peak, 1, 'last')) = true;
	end
	if general.struct.probe_field(fit_md.peaks_of_interest, 'ifdo.include_last')
		isafter_second_last_peak = ~idx_spacing_of_interest & (1:length(y_peaks)) > find(idx_spacing_of_interest, 1, 'last');
		% Fill in:
		idx_spacing_of_interest(find(sum(is_spacing_of_interest, 1)>0 & isafter_second_last_peak, 1, 'first')) = true;
	end
	% Finally, extract the peaks of interest:
	[x_peaks_of_interest, y_peaks_of_interest] = deal(x_peaks(idx_spacing_of_interest), y_peaks(idx_spacing_of_interest));

	%% Plot
	if general.struct.probe_field(fit_md.ifdo, 'final_plot')% If the user wants to see a 'final' oversight plot of the fits:
		[~, h_axes, h_GrObj] = macro.plot.create.plot(data_in, fit_md);
		h_axes(1).YLim = [0 max(h_GrObj.YData)];
		hold on; plot(h_axes(1), x_peaks_of_interest, y_peaks_of_interest, 'k*')
		plot(h_axes(1), histogram.midpoints, histogram.Count, 'r')
	end
	
	%% Calculate cation size
	% If requested, the mass-to-charge signal can be converted to a cluster
	% size:
	if general.struct.probe_field(fit_md.ifdo, 'calc_cluster_cation_size')
		bare_mol_mass = round((x_peaks_of_interest(1)* fit_md.cluster_cation.charge) - fit_md.cluster_cation.protonation);
		% Estimate to which size it belongs:
		
		if numel(fit_md.cluster_cation.unit_mass) > 1 % If it is a mixed cluster, we use an estimate of the composition:
			avg_mass = (fit_md.cluster_cation.unit_mass*fit_md.cluster_cation.comp_est')./sum(fit_md.cluster_cation.comp_est);
		else
			avg_mass = fit_md.cluster_cation.unit_mass;
		end
		% Give an estimated size:
		est_size = bare_mol_mass/avg_mass;
		% Calculate the closest match to an integer value of the size:
		fit_param.app_size_cation = round(est_size);
		if numel(fit_md.cluster_cation.unit_mass) == 2 % give the sizes of individual constituents:
			% Do a small least square fit to find the size of each component:
			cost_f_bnd = @(comp_size) abs(bare_mol_mass - fit_md.cluster_cation.unit_mass(1)*comp_size(1) - ...
				fit_md.cluster_cation.unit_mass(2:end)*(fit_param.app_size_cation-comp_size));
			% Give an initial guess:
			IG_comp_sizes = fit_md.cluster_cation.comp_est./sum(fit_md.cluster_cation.comp_est)*est_size;
			% Run the minimum finder:
			comp1_size = fminbnd(cost_f_bnd, 0, est_size);
			if norm(comp1_size - round(comp1_size)) > 1e-3
				warning(['no proper size found for component 1(' num2str(comp1_size) '), no composition returned'])
			else
				fit_param.app_comp_cation(1) = comp1_size;
				fit_param.app_comp_cation(2) = fit_param.app_size_cation - fit_param.app_comp_cation(1);
			end
		elseif numel(fit_md.cluster_cation.unit_mass) > 2 
			warning('TODO: implement searcher for higher order')
		end
	end
	
	%% Output parameters
% 	Fill in the fit parameters:
	try fit_param.app_size_x			= x_peaks_of_interest(1);
		fit_param.x_peaks_of_interest	= x_peaks_of_interest;
		fit_param.y_peaks_of_interest	= y_peaks_of_interest;
	catch 
		fit_param.app_size_x			= [];
		fit_param.x_peaks_of_interest	= [];
		fit_param.y_peaks_of_interest	= [];
	end
	
end

% add the metadata to the fit parameters:
fit_param.md = fit_md;
end