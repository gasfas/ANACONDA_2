function  [data_out] = source_position(data_in, metadata_in, det_name)
% This macro calculates the source position for complete ion detection
% events
% Input:
% data_in        The experimental data, already converted
% metadata_in    The corresponding metadata
% det_name      (optional) The name of the detector
% Output:
% data_out      The output data with converted data.
% metadata_out  The corresponding metadata
% Note that this function does NOT take the shift due to the molecular beam
% velocity into account. To be implemented in the future?

data_out = data_in;

if exist('det_name', 'var')
    detnames = {det_name};
else % No detector name is given, so we fetch all detector names:
    detnames = fieldnames(metadata_in.det);
end

for i = 1:length(detnames)
    detname = detnames{i};
	detnr	= IO.detname_2_detnr(detname);

    % Calculation of the position of the ionization point. Only
    % performed for complete ion detections.
    events = data_out.e.raw(:,detnr);
    parent_mass = metadata_in.sample.mass;
    
    try	% Filter out the events that recorded the 'complete ion':
		e_f_complete                  = (data_out.e.(detname).m2q_l_sum == parent_mass);
	catch % apparently, the mass-to-charge sum is not calculated yet:
		% calculate the mass-to-charge of all hits registered in the event:
		data_out.e.(detname).m2q_l_sum = convert.event_sum(data_out.h.(detname).m2q_l, events);
		% Now we can filter out the events that recorded the 'complete ion':
		e_f_complete                  = (data_out.e.(detname).m2q_l_sum == parent_mass);
	end

    m               = data_out.h.(detname).m_l; % Mass
    q               = data_out.h.(detname).m_l./data_out.h.(detname).m2q_l; % Charge
    X               = data_out.h.(detname).X;
    Y               = data_out.h.(detname).Y;
    TOF             = data_out.h.(detname).TOF;
    dZ_range        = [metadata_in.spec.dist.s0-metadata_in.spec.dist.s metadata_in.spec.dist.s0]*1e3;
    TOF_2_m2q_md    = metadata_in.conv.(detname).m2q;


    if strcmpi(metadata_in.spec.name, 'Laksman')
        if strcmpi(metadata_in.spec.det_modes{detnr}, 'ion')
            dZ_2_dTOF = @(m2q, dZ) theory.TOF_afo_Z_Laksman (m2q, metadata_in.spec.volt, metadata_in.spec.dist, dZ);
        end
    else
        error ('spectrometer not recognized')
    end

    % convert these events to source positions:
    all_source_positions = convert.source_position(events, m, q, X, Y, TOF, TOF_2_m2q_md, dZ_range, dZ_2_dTOF);

    data_out.e.(detname).source_position = NaN*ones(size(events,1),3);
    % Fill in the source positions of only the complete events:
    data_out.e.(detname).source_position(e_f_complete,:) = all_source_positions(e_f_complete,:);

    disp(['Log: Interaction point conversion performed on ' detname])
end
end
