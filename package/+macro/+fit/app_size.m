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
	
% 	%% Find the peaks:
[x_peaks_of_interest, y_peaks_of_interest, widths_peaks_of_interest] = fit.findpeakseries (histogram.midpoints, histogram.Count, fit_md.MinPeakProminence, ...
		fit_md.peaks_of_interest.spacing.min, fit_md.peaks_of_interest.spacing.max, ...
		fit_md.peaks_of_interest.ifdo.include_first, fit_md.peaks_of_interest.ifdo.include_last, 'first');

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

		% Composition calculation:
		fit_param = calculate_composition(fit_md, fit_param, bare_mol_mass, est_size);
	end
	
	%% Output parameters
% 	Fill in the fit parameters:
	try fit_param.app_size_x			= x_peaks_of_interest(1);
		fit_param.x_peaks_of_interest	= x_peaks_of_interest;
		fit_param.y_peaks_of_interest	= y_peaks_of_interest;
		fit_param.x_widths_peaks_of_interest	= widths_peaks_of_interest;
	catch 
		fit_param.app_size_x			= [];
		fit_param.x_peaks_of_interest	= [];
		fit_param.y_peaks_of_interest	= [];
	end
	
end

% add the metadata to the fit parameters:
fit_param.md = fit_md;
end
%%
function fit_param = calculate_composition(fit_md, fit_param, bare_mol_mass, est_size)


if numel(fit_md.cluster_cation.unit_mass) == 2 % give the sizes of individual constituents:
			% Do a small least square fit to find the size of each component:
			cost_f_bnd = @(comp_size) ...
				abs(bare_mol_mass - fit_md.cluster_cation.unit_mass(1)*comp_size - ...
					fit_md.cluster_cation.unit_mass(2)*(fit_param.app_size_cation-comp_size));
			% Give an initial guess:
% 			IG_comp_sizes = fit_md.cluster_cation.comp_est./sum(fit_md.cluster_cation.comp_est)*est_size;
			% Run the minimum finder:
			comp1_size = fminbnd(cost_f_bnd, 0, est_size);
			if norm(comp1_size - round(comp1_size)) > 1e-3
				warning(['no proper size found for component 1(' num2str(comp1_size) '), no composition returned'])
			else
				fit_param.app_comp_cation(1) = comp1_size;
				fit_param.app_comp_cation(2) = fit_param.app_size_cation - comp1_size;
			end
		elseif numel(fit_md.cluster_cation.unit_mass) > 2 
			warning('TODO: implement searcher for higher order')
end
end
