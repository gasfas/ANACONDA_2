function  [data_out] = m2q_2_m2q_group_label(data_in, metadata_in, det_name)
% This macro converts the m2q signal to m2q-group-label signal.
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
    expected_m2q_labels_min     = metadata_in.conv.(detname).m2q_group_labels.min;
    expected_m2q_labels_max     = metadata_in.conv.(detname).m2q_group_labels.max;
    expected_m2q_labels_mean    = mean([expected_m2q_labels_min expected_m2q_labels_max], 2);
    expected_m2q_labels_name    = metadata_in.conv.(detname).m2q_group_labels.name;

    search_radius               = diff([expected_m2q_labels_min expected_m2q_labels_max], 1, 2)/2 + metadata_in.conv.(detname).m2q_group_labels.search_radius;
    % grouping them in labels:
    [data_out.h.(detname).m2q_group_l]   = convert.signal_2_label(data_out.h.(detname).m2q, expected_m2q_labels_mean, search_radius);
    % creating the mass labels as well:
    [data_out.h.(detname).m2q_group_l_name]     = convert.label_2_label(data_out.h.(detname).m2q_group_l, expected_m2q_labels_mean, expected_m2q_labels_name, NaN);
    disp('Log: m2q group labeling performed')
end
end
