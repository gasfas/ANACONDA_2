function  [data_out] = bgr(data_in, metadata_in, det_name)
% This macro converts specified multi-hit signals to background signals.
% Input:
% data_in        The experimental data, already converted
% metadata_in    The corresponding metadata
% det_name      (optional) The name of the detector
% Output:
% data_out      The output data with converted data.
% metadata_out  The corresponding metadata

data_out = data_in;

if exist('det_name', 'var')
    detnames = {det_name};
else % No detector name is given, so we fetch all detector names:
    detnames = fieldnames(metadata_in.det);
end

for i = 1:length(detnames)
    detname		= detnames{i}; 
    detnr		= IO.detname_2_detnr(detname);
	% Fetch the signal names that are requested to be converted:
	signal_names = metadata_in.conv.(detname).bgr.signal_name;
	for signal_name = signal_names
		SN_char		= signal_name{:};
		% shuffle the data by shifting the hits one or several rows down, and the first hit(s) to become the last:
		data_out.h.(detname).([SN_char '_bgr']) = general.vector.shuffle(data_out.h.(detname).(SN_char));
		if any(strcmp(SN_char, {'TOF', 'm2q'}))
			% These signals have, by definition, the size of the hits ordered:
			data_out.h.(detname).([SN_char '_bgr']) = convert.sorted_hits(data_out.h.(detname).([SN_char '_bgr']), data_out.e.raw(:,detnr), 'ascend');
		end
		% Hack: Overwrite the signal with the newly generated noise:
% 		data_out.h.(detname).(SN_char) = data_out.h.(detname).([SN_char '_bgr']);
	end
	signal_names_sep = general.cell.pre_postscript_to_cellstring(signal_names, '', ', ');
    disp(['Log: Background signal created for ' detname ' on the signal(s) ' signal_names_sep{:}])
end
end
