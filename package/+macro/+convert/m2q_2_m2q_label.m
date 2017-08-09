function  [data_out] = m2q_2_m2q_label(data_in, metadata_in, det_name)
% This macro converts the m2q signal to m2q-label signal.
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
    detname = detnames{i};
	detnr = IO.det_nr_from_fieldname(detname);
	
    expected_m2q_labels     = metadata_in.conv.(detname).m2q_labels;
    expected_m_labels       = metadata_in.conv.(detname).mass_labels;
    search_radius           = metadata_in.conv.(detname).m2q_label.search_radius;
    labelling_signal        = general.struct.probe_field(metadata_in.conv.(detname).m2q_label, 'signal');

    switch labelling_signal
        case 'TOF'
            % The labeling is done based on the TOF signal (hit based)
            factor = metadata_in.conv.(detname).TOF_2_m2q.factor;
            t0 = metadata_in.conv.(detname).TOF_2_m2q.t0;
            expected_TOF_labels = convert.m2q_2_TOF(expected_m2q_labels, metadata_in.conv.(detname).TOF_2_m2q.factor, metadata_in.conv.(detname).TOF_2_m2q.t0);
            % Convert the given TOF search radii to m2q search radii:
            search_radius_m2q = abs(expected_m2q_labels - convert.TOF_2_m2q(expected_TOF_labels-search_radius, factor, t0));
        otherwise
            % The labeling is done based on the m2q signal (default)
            search_radius_m2q = search_radius;
	end
	
	% grouping the hits in labels:
	[data_out.h.(detname).m2q_l]   = convert.signal_2_label(data_out.h.(detname).m2q, expected_m2q_labels, search_radius_m2q);
	% creating the mass labels as well:
	[data_out.h.(detname).m_l]     = convert.label_2_label(data_out.h.(detname).m2q_l, expected_m2q_labels, expected_m_labels, NaN);
	% Write the event-summed m2q:
	data_out.e.(detname).m2q_l_sum	= convert.event_sum(data_out.h.(detname).m2q_l, data_out.e.raw(:,detnr));
			
    disp(['Log: m2q labeling performed on ' detname])
end
end
