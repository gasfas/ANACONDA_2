function  [data_out] = momentum(data_in, metadata_in, det_name)
% This macro converts the TOF/m2q and X,Y signal to momentum signal.
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
	detnr	= IO.det_nr_from_fieldname(detname);
    % As mentioned in the manual, a so-called time-zero momentum and final
    % momentum are defined.
    % Preparing the variables needed:
    X           = data_out.h.(detname).X;
    Y           = data_out.h.(detname).Y;
	if general.struct.issubfield(data_out.h.(detname), 'TOF')
		% This means we can perform 3D momentum conversion:
		TOF         = data_out.h.(detname).TOF;
	
		m2q_l       = data_out.h.(detname).m2q_l;
		m_l         = data_out.h.(detname).m_l;
		% And from metadata:
		labels      = metadata_in.conv.(detname).m2q_labels;
		labels_mass = metadata_in.conv.(detname).mass_labels;
		m2qfactor   = metadata_in.conv.(detname).TOF_2_m2q.factor; 
		t0          = metadata_in.conv.(detname).TOF_2_m2q.t0;
		E_ER        = theory.TOF.calc_field_strength(metadata_in.spec.volt.Ve2s, metadata_in.spec.volt.Vs2a, metadata_in.spec.dist.s);
		sample_md   = metadata_in.sample;
		% Obtain the TOF values that should correspond to zero momentum values:
		labels_TOF_no_p = convert.m2q_2_TOF(labels, m2qfactor, t0);
		% Calculate the momentum:
		[data_out.h.(detname).p, data_out.h.(detname).p_0] = convert.momentum_3D(TOF, X, Y, m2q_l, m_l, labels, labels_mass, labels_TOF_no_p, E_ER, sample_md);
		data_out.h.(detname).dp = data_out.h.(detname).p - data_out.h.(detname).p_0;
		% calculate the elevation angle phi:
		[~, data_out.h.(detname).dp_phi]					= cart2sph(data_out.h.(detname).dp(:,1), data_out.h.(detname).dp(:,2), data_out.h.(detname).dp(:,3));
		% Calculate the momentum norm
		data_out.h.(detname).dp_norm						= general.vector.norm_vectorarray(data_out.h.(detname).dp, 2);

	
	else % There is only X, and Y component measured, so 2D momentum:
		TOF_nominal = metadata_in.conv.(detname).momentum.TOF_nominal;
		mass = metadata_in.conv.(detname).momentum.mass; % here we assume that the mass is not determined, if no TOF is known.
		[X_0, Y_0] = deal (metadata_in.conv.(detname).momentum.X_0, metadata_in.conv.(detname).momentum.Y_0);
		[data_out.h.(detname).p, data_out.h.(detname).p_0] = convert.momentum_2D(X, Y, X_0, Y_0, mass, TOF_nominal);
		data_out.h.(detname).dp = data_out.h.(detname).p - data_out.h.(detname).p_0;
	end

	% Calculate the radial component:
	data_out.h.(detname).dp_R							= general.vector.norm_vectorarray(data_out.h.(detname).dp(:,1:2), 2);
	% Sum of all momenta in one event:
    data_out.e.(detname).dp_sum = convert.event_sum(data_out.h.(detname).dp, data_out.e.raw(:,detnr));
    % calculate the norm of the momentum sum:
    data_out.e.(detname).dp_sum_norm = general.vector.norm_vectorarray(data_out.e.(detname).dp_sum, 2);
	
	
	% remove unused fields for memory saving:
	data_out.h.(detname) = rmfield(data_out.h.(detname), 'p');
	data_out.h.(detname) = rmfield(data_out.h.(detname), 'p_0');

	disp(['Log: momentum conversion performed on ' detname])
end
end
