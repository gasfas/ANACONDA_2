function  [data_out] = KER(data_in, metadata_in, det_name)
% This macro converts the momenta signals to KER signal.
% Input:
% data_in        The experimental data, already converted
% metadata_in    The corresponding metadata
% det_name      (optional) The name of the detector one wants to study.
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
	detnr	= IO.detname_2_detnr(detname);
	
        % Momentum to Kinetic energy conversion:
    m_l         = data_out.h.(detname).m_l;
    dp			= data_out.h.(detname).dp;
    % Calculate the kinetic energy:
    data_out.h.(detname).KER	= convert.p_2_KE(0, dp, m_l);
    % The sum of all Kinetic energies in one event:
    data_out.e.(detname).KER_sum = convert.event_sum(data_out.h.(detname).KER, data_out.e.raw(:,detnr));
    disp(['Log: Kinetic energy release conversion performed on ' detname])
end
end
