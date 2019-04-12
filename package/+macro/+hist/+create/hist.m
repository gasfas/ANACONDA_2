function [histogram] = hist(exp, hist_md, e_filter)
% This function calculates a histogram from signal (given by pointers in
% metadata), and returns it.
% Inputs:
% exp		struct, The experiment metadata, with field 'e' (events), 'h' (hits) and subfields.
% hist_md	struct, The histogram metadat, with field 'pointer' (data
%			pointing to data in exp), 'Range' and 'binsize'.
% e_filter  (optional) event (logical) filter
% Outputs:
% histogram	struct, containing the fields 'Count' (the histogram matrix),
%			and 'midpoints', giving the midpoints in each dimension.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% If multiple histograms are defined, perform this function recursively:
if numel(hist_md)>1
	histogram = struct('Count', [], 'midpoints', []);
	for i = 1:numel(hist_md)
		% Calculate histogram 'i':
		if exist('e_filter', 'var')
			histogram(i) = macro.hist.create.hist(exp, hist_md(i), e_filter);
		else
			histogram(i) = macro.hist.create.hist(exp, hist_md(i));
		end
	end
else
	if exist('e_filter', 'var')
		hist_data = fetch_data(exp, hist_md, e_filter);
        hist_data(isnan(hist_data(:,1)),:) = [];
	else
		hist_data = fetch_data(exp, hist_md);
        hist_data(isnan(hist_data(:,1)),:) = [];
	end
end

%% HISTOGRAM
%Make a histogram from the fetched signals:

if strcmp(general.struct.probe_field(hist_md, 'Type'), 'ternary')
	% Create ternary axis histogram. We assume that all three signals are given. We normalize the datapoints:
	norm_factor = sum(hist_data, 2);
	hist_data_n = hist_data./norm_factor;
	% Only one binsize possible, so in case multiple binsizes
	% are given:
	hist_md.binsize	= [mean(hist_md.binsize) mean(hist_md.binsize)]./mean(diff(hist_md.Range, 1, 2));
	hist_md.Range	= [0 1; 0 1];
	% convert the C1, C2 coordinates data to x,y coordinates (rotating 60 degrees):
	[hist_data(:,1), hist_data(:,2)] = plot.ternary.terncoords(hist_data_n(:,1), hist_data_n(:,2), hist_data_n(:,3));
	hist_data(:,3) = [];
end

% Add signal as background subtraction if requested:
if general.struct.issubfield(hist_md, 'bgr')
	if isfield(hist_md.bgr, 'cond')
		% Calculate the filter from a condition:
		[bgr_e_filter, exp]	= macro.filter.conditions_2_filter(exp, hist_md.bgr.cond);
		% Fetch the data with the filter:
		bgr_hist_data = fetch_data(exp, hist_md.bgr.hist, bgr_e_filter);
	else
		% Fetch the data without the filter:
		bgr_hist_data = fetch_data(exp, hist_md.bgr.hist);
	end
	% add this background data to the signal, and include the weights:
	weight = [ones(size(hist_data)); -hist_md.bgr.weight*ones(size(bgr_hist_data))];
	hist_data = [hist_data; bgr_hist_data];
	% Create the histogram:
	midpoints = hist.bins(hist_md.Range, hist_md.binsize);
	[histogram.Count, histogram.midpoints] = hist.H_nD(hist_data, midpoints, weight);
else
	% Create regular histogram:
	midpoints = hist.bins(hist_md.Range, hist_md.binsize);
	[histogram.Count, histogram.midpoints] = hist.H_nD(hist_data, midpoints);
end

%% Apply histogram saturation if requested:
if isfield(hist_md, 'saturation_limits')
	sf	= 1./max(histogram.Count(:));
	histogram.Count(histogram.Count.*sf < hist_md.saturation_limits(1)) = hist_md.saturation_limits(1)./sf;
	histogram.Count(histogram.Count.*sf > hist_md.saturation_limits(2)) = hist_md.saturation_limits(2)./sf;
end

%% Apply intensity solid angle correction if requested:
if general.struct.probe_field(hist_md, 'ifdo.Solid_angle_correction')
	% This means the user want to apply a solid angle correction. Select dimension:
	Theta_dim = hist_md.Solid_angle_correction.Dim_nr;
	histogram = hist.solid_angle_correction(histogram, Theta_dim);
end

%% Apply Intensity normalization if requested:
if general.struct.probe_field(hist_md, 'Integrated_value')
	switch hist_md.dim
		case 1	
			histogram.Count = histogram.Count./trapz(histogram.midpoints, histogram.Count)* hist_md.Integrated_value;
		case 2
			histogram.Count = histogram.Count./sum(histogram.Count(:)) * hist_md.Integrated_value;
	end
elseif  general.struct.probe_field(hist_md, 'Maximum_value')
	histogram.Count = histogram.Count./max(histogram.Count(:)) * hist_md.Maximum_value;
end

%% Apply logarithmic rescaling if requested:
if general.struct.probe_field(hist_md, 'Intensity_scaling')
	switch hist_md.Intensity_scaling
		case {'log', 'logarithmic', 'Log', 'Logarithmic'}
			
			if min(histogram.Count(:)) < 0 % Make sure there are no negative values:
				histogram.Count(histogram.Count<0) = 0;
				disp('Warning: negative values in histogram ignored in log scale')
			end
			histogram.Count = log(histogram.Count);	end
			histogram.Count(histogram.Count == -Inf) = 0;
end

end

%% Local subfunctions

function hist_data = fetch_data(exp, hist_md, e_filter)
	
%% Are we dealing with an event or hit property?
isevent_signal	= IO.data_pointer.is_event_signal( hist_md.pointer );
isevent			= any(isevent_signal) || isfield(hist_md, 'hitselect');

%% EVENTS
if isevent
	if any(~isevent_signal) % This means some signals come from hits:
		hit_sign_nr = find(~isevent_signal);
		detnrs = IO.det_nr_from_fieldname(hist_md.pointer(hit_sign_nr));
		hitnrs = hist_md.hitselect(hit_sign_nr);
		hit_detnrs_sort = sortrows([detnrs' hitnrs']);
		pair_idx		= [diff(hit_detnrs_sort(:,1))>0; true];
		[unique_detnrs, max_hitnrs]	= deal(hit_detnrs_sort(pair_idx, 1), hit_detnrs_sort(pair_idx, 2));
		% now we know the detector numbers and their highest hit number requested, we calculate the event filters:
		hitnr_filter = true(size(exp.e.raw, 1),1); nof_hits_det = general.data.count_nof_hits(exp.h);
		for j = 1:length(unique_detnrs)
			[detnr, hitnr] = deal(unique_detnrs(j), max_hitnrs(j));
			hitnr_filter = hitnr_filter & filter.events.multiplicity(exp.e.raw(:,detnr), hitnr, Inf, nof_hits_det(detnr));
		end
	else
		hitnr_filter = true(size(general.data.pointer.read(hist_md.pointer{1}, exp), 1), 1);
	end
	if exist('e_filter', 'var') % apply external event filter if requested:
		hitnr_filter = hitnr_filter & e_filter;
	end
	% Initialize the histogram data:
	hist_data = zeros(sum(hitnr_filter), hist_md.dim);
	% The hitnr filter will be applied to all signals:
	col_nr = 1;
	for sign_nr = 1:length(hist_md.pointer)
		if isevent_signal(sign_nr) % we deal with an event signal:
			event_data = general.data.pointer.read(hist_md.pointer{sign_nr}, exp);
			nof_cols		= size(event_data, 2);
			hist_data(:,col_nr:col_nr+nof_cols-1) = event_data(hitnr_filter,:);
		else % we deal with a hit signal, accompanied with hitselect:
			detnr			= IO.det_nr_from_fieldname(hist_md.pointer{sign_nr});
			hitnr = hist_md.hitselect(sign_nr);
			hit_data		= general.data.pointer.read(hist_md.pointer{sign_nr}, exp);
			nof_cols		= size(hit_data, 2);
			detnr			= IO.det_nr_from_fieldname(hist_md.pointer{sign_nr});
			hist_data(:,col_nr:col_nr+nof_cols-1) = hit_data(exp.e.raw(hitnr_filter, detnr)+hitnr-1);
		end
		col_nr = col_nr + nof_cols;
	end
% End of event data selection.
%% HITS
elseif ~isevent%% This means we are dealing with hits:
	hit_data1	= general.data.pointer.read(hist_md.pointer{1}, exp);
	nof_hits	= size(hit_data1, 1);
	if exist('e_filter', 'var') % translate the event filter to a hit filter:
		detnr		= IO.det_nr_from_fieldname(hist_md.pointer{1});
		hit_filter	= filter.events_2_hits_det(e_filter, exp.e.raw(:,detnr), nof_hits);
	else
		hit_filter	= true(nof_hits, 1);
	end
	hist_data = NaN*zeros(sum(hit_filter), hist_md.dim);
	col_nr = 1;
	for sign_nr	= 1:length(hist_md.pointer)
		hit_data		= general.data.pointer.read(hist_md.pointer{sign_nr}, exp);
		if size(hit_data, 1) ~= size(hit_data1, 1)
			error('different size data-arrays given, cannot be plotted')
		end
		hit_data		= hit_data(hit_filter,:);
		nof_cols		= size(hit_data, 2);
		hist_data(:,col_nr:col_nr+nof_cols-1) = hit_data;
		col_nr = col_nr + nof_cols;
	end
end

end
% End of hit data selection
