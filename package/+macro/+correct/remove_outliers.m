function  [data_out] = remove_outliers(data_in, metadata_in, det_name)
% This macro replaces outlier data with NaN .
% Input:
% data_in        The experimental data
% metadata_in    The corresponding metadata
% det_name       (optional) The name of the detector
% Output:
% data_out      The output data with corrected data.
% metadata_out  The corresponding metadata
data_out = data_in;

if exist('det_name', 'var')
    detnames = {det_name};
else % No detector name is given, so we fetch all detector names:
    detnames = fieldnames(metadata_in.det);
end

for i = 1:length(detnames)
    detname = detnames{i};  
	
	corr_md = metadata_in.corr.(detname).remove_outliers;

	% The outlier signals must have been specified by the user:
	try outl_signs = corr_md.signals;
	catch warning('outlier removal requested, but no signals specified.');
		outl_signs = struct();
	end

	sign_names = fieldnames(outl_signs);
	for outl_sign_nr = 1:length(sign_names)
		outl_signal = outl_signs.(sign_names{outl_sign_nr});
		% Read the data from the pointer:
		[condition_data, data_form] = IO.read_data_pointer(outl_signal.data_pointer, data_in);
		% And read the value of the actual condition:
		condition_value = outl_signal.value;
		% Check whether the conditions are discrete or continuous:
		switch outl_signal.type
			case 'discrete' % A discrete condition. Write the filter:
				f = filter.hits.labeled_hits(condition_data, condition_value);
			case 'continuous'
				f = general.matrix.filter_range(condition_data, outl_signal.value(1), outl_signal.value(2));
		end
		% Now we assign the NaN values:
		switch outl_signal.remove_method
			case 'signal_hit' % replace just the hit of the involved signal
				try [ signal_in ] = general.struct.getsubfield(data_in, outl_signal.data_pointer);
				catch warning ('the specified signal seems a composition of signals, and a single channel can therefore not be defined. All signals are treated.')
				end
			case 'full_hit' %('full_hit') The hit of every signal on the detector is replaced
				[data_out] = replace_NaN_full_hit(data_in, det_name, f);
			case 'full_event' %The full hit of the entire event on all detectors is replaced
				[data_out] = replace_NaN_full_event(data_in, det_name, fieldnames(metadata_in.det), f);
		end


		end
	end

	disp('Log: Data outlier removal performed')
	
end

% subfunctions:
function [data_out] = replace_NaN_full_hit(data_in, det_name, filt)
data_out = data_in;
% This function replaces all the signal values of a disproved hit into NaN
	% Find all the signals for this detector:
	signal_names = fieldnames(data_in.h.(det_name));
	for i = 1:length(signal_names)
		% do not change the 'raw' signal:
		signal_name = signal_names{i};
		switch signal_name
			case {'raw', 'corr_log'}
				% skip
			otherwise
					% replace the hits with NaN's:
					data_out.h.(det_name).(signal_names{i})(filt) = NaN;
		end
	end
end

function [data_out] = replace_NaN_full_event(data_in, det_name_default, detnames, filt)
data_out = data_in;
% calculate the number of hits of all detectors:
nof_hits_all	= IO.count_nof_hits(data_in.h);
	% loop over all detectors:
	for i = 1:length(detnames)
		det_name_cur = detnames{i};
		% translate the filter to this specific detector:
		if strcmp(det_name_default, det_name_cur)
			filt_det_cur	= filt;
		else
			% Find the detector number where the filter is already defined in:
			detnr_default	= IO.detname_2_detnr(det_name_default);
			% and of the current detector:
			detnr_cur		= IO.detname_2_detnr(det_name_cur);
			% Then translate the hit filter to an event filter:
			e_filt			= filter.hits_2_events(filt, data_in.e.raw(:,detnr_default), nof_hits_all(detnr_default), 'AND');
			% And translate that again to a hit filter of the requested detector:
			filt_det_cur	= filter.events_2_hits_det(e_filt, data_in.e.raw(:,detnr_cur), nof_hits_all(detnr_cur));
		end
		[data_out] = replace_NaN_full_hit(data_in, det_name_cur, filt_det_cur);
	end
end