function  [data_out] = fragment_asymmetry(data_in, metadata_in, det_name)
% This macro calculates the fragment asymmetry factor (FAS) for ion detection
% events, from the labeled m2q hits.
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
	detnr	= IO.detname_2_detnr(detname);

    % Fetch the needed data:
    events		= data_out.e.raw(:,detnr);
	m2q_l		= data_out.h.(detname).m2q_l; % Fetch m2q labels

	% calculate the mean and standard deviation:
	[mean_m2q_l, std_m2q_l] = convert.event_mean(m2q_l, events);	
	data_out.e.(detname).fragment_asymmetry = real(std_m2q_l./mean_m2q_l);
	
% 	[min_m2q_l, max_m2q_l] = convert.event_extreme(m2q_l, events, 'min&max');
% 	data_out.e.(detname).fragment_asymmetry = max_m2q_l-min_m2q_l;
	
	disp(['Log: Fragment asymmetry factor calculated on ' detname])
end
end
