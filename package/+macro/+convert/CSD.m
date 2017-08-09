function  [data_out] = CSD(data_in, metadata_in, det_name)
% This macro calculates the charge separation distance (CSD) for complete ion detection
% events
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
	all_nof_hits= IO.count_nof_hits(data_out.h);
	nof_hits	= all_nof_hits(detnr);
	eps_m		= metadata_in.sample.permittivity;
	KER			= data_out.e.(detname).KER_sum; % Fetch KER
	mult		= convert.event_multiplicity(events, nof_hits); % Fetch the multiplicity
	% TODO: so far, the CSD conversion assumes the same charges for all
	% particles involved. This might not be the case:
	h_f			= filter.events_2_hits_det(~isnan(KER), events, nof_hits);
	charges_all	= data_out.h.(detname).m_l(h_f)./data_out.h.(detname).m2q_l(h_f);
	charges_real= charges_all(~isnan(charges_all));
	if any(find(diff(charges_real)))
		warning('different charges for different particles. CSD assumes only one charge value for all particles.');
	end
	% pick the first value of charges (since they should all be the same):
	charge_unified	= charges_real(1);
	% convert the KER to Charge separation distance and fill them in to the
	% data file:
	if general.struct.probe_field(metadata_in.conv.(detname), 'CSD.include_C1_as_C2')
		% If there is only one particle detected, the default
		% behaviour is to return NaN CSD. if include1 == true, the potential V
		% is assumed to be all transfered to the kinetic energy of the one detected particle:
		mult(mult == 1) = 2;
	end
	data_out.e.(detname).CSD = theory.Coulomb.distance(eps_m, mult, charge_unified, KER);

    disp(['Log: CSD conversion performed on ' detname])
end
end
