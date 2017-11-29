function  [data_out] = TOF_2_m2q(data_in, metadata_in, det_name)
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
    detname		= detnames{i}; 
    detnr		= IO.detname_2_detnr(detname);
    % execute the TOF to m2q conversion if TOF is one of the signals:
    if general.struct.probe_field(metadata_in.conv.(detname).ifdo, 'm2q') && all(isfield(data_out.h.(detname), {'TOF'}));
        % Convert to m2q:
        TOF             = data_in.h.(detname).TOF;
        factor          = metadata_in.conv.(detname).TOF_2_m2q.factor;
        t0              = metadata_in.conv.(detname).TOF_2_m2q.t0;
        data_out.h.(detname).m2q = convert.TOF_2_m2q(TOF, factor, t0);
		% Calculate the sum of masses, to the event property (if possible):
        try data_out.e.(detname).m2q_sum = convert.event_sum(data_out.h.(detname).m2q, data_in.e.raw(:, detnr)); catch; end
        disp(['Log: m2q conversion performed on ' detname])
    end
end
end
