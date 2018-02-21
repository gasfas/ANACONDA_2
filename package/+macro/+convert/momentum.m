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
    %rawdata_size = size(data_out.h.(detname).raw);
    if general.struct.issubfield(data_out.h.(detname), 'TOF')
		% This means we can perform 3D momentum conversion:
		TOF         = data_out.h.(detname).TOF;
		% Electric field in the source region:
		E_ER        = theory.TOF.calc_field_strength(0, 80 , .180 );
		sample_md   = metadata_in.sample;
        spec_md     = metadata_in.spec;
        switch metadata_in.spec.det_modes{detnr} % what kind of particle does this detector see
			case 'ion' % if it sees ions:
				m2q_l       = data_out.h.(detname).m2q_l;
				m_l         = data_out.h.(detname).m_l;
				% And from metadata:
				labels      = metadata_in.conv.(detname).m2q_labels;
				labels_mass = metadata_in.conv.(detname).mass_labels;
				% Obtain the TOF values that should correspond to zero momentum values:
% 				labels_TOF_no_p = convert.m2q_2_TOF(labels, m2qfactor, t0);
				labels_TOF_no_p = calc_labels_TOF_no_p(labels, metadata_in.conv.(detname).TOF_2_m2q);
				% Calculate the momentum:
                
				[data_out.h.(detname).p, data_out.h.(detname).p_0] = convert.momentum_3D_EField(TOF, X, Y, m2q_l, m_l, labels, labels_mass, labels_TOF_no_p, E_ER, sample_md, metadata_in.spec.det_modes{detnr});
				data_out.h.(detname).dp = data_out.h.(detname).p - data_out.h.(detname).p_0;
				% calculate the elevation angle phi:
				[~, data_out.h.(detname).dp_phi]					= cart2sph(data_out.h.(detname).dp(:,1), data_out.h.(detname).dp(:,2), data_out.h.(detname).dp(:,3));
				% Calculate the momentum norm
				data_out.h.(detname).dp_norm						= general.vector.norm_vectorarray(data_out.h.(detname).dp, 2);
			
			case 'electron' % if the detector sees electrons:
                m2q_l           = data_out.h.(detname).m2q_l;
				%m_l             = m2q_l;
                labels          = metadata_in.conv.(detname).m2q_labels;
                %labels_mass     = labels;
				labels_TOF_no_p = calc_labels_TOF_no_p(labels, metadata_in.conv.(detname).TOF_2_m2q); %[ns] important to notice here is that the mass and charge are both taken
                % in atomic units. Therefore, the factor which is optimized
                % (so far by hand) to obtain m2q = 1 after conversion
                % is a factor for conversion to m2q in a.m.u, thus if we
                % want to use this factor obtain
                % [data_out.h.(detname).p, data_out.h.(detname).p_0] = convert.momentum_2D_EBfield(TOF, X, Y, m2q_l, m2q_l, labels, labels, labels_TOF_no_p, E_ER, sample_md);
             	[data_out.h.(detname).p, data_out.h.(detname).p_0] = convert.momentum_3D_EField(TOF, X, Y, m2q_l, m2q_l, labels, labels, labels_TOF_no_p, E_ER, sample_md, spec_md);
                data_out.h.(detname).dp = data_out.h.(detname).p - data_out.h.(detname).p_0;
        end

	else % There is only X, and Y component measured, so 2D momentum:
		TOF_nominal = metadata_in.conv.(detname).momentum.TOF_nominal;
		mass = metadata_in.conv.(detname).momentum.mass; % here we assume that the mass is not determined, if no TOF is known.
		[X_0, Y_0] = deal (metadata_in.conv.(detname).momentum.X_0, metadata_in.conv.(detname).momentum.Y_0);
        [data_out.h.(detname).p, data_out.h.(detname).p_0] = convert.momentum_2D_EField(X, Y, X_0, Y_0, mass, TOF_nominal);
		data_out.h.(detname).dp = data_out.h.(detname).p - data_out.h.(detname).p_0;
    end

	% Calculate the radial component:
	data_out.h.(detname).dp_R							= general.vector.norm_vectorarray(data_out.h.(detname).dp(:,1:2), 2);
	% Sum of all momenta in one event (if possible):
    try data_out.e.(detname).dp_sum = convert.event_sum(data_out.h.(detname).dp, data_out.e.raw(:,detnr)); catch; end
    % calculate the norm of the momentum sum (if possible):
    try data_out.e.(detname).dp_sum_norm = general.vector.norm_vectorarray(data_out.e.(detname).dp_sum, 2); catch; end
	
	% remove unused fields for memory saving:
	%data_out.h.(detname) = rmfield(data_out.h.(detname), 'p');
	%data_out.h.(detname) = rmfield(data_out.h.(detname), 'p_0');

	disp(['Log: momentum conversion performed on ' detname])
end
end

%% Subfunctions:
function labels_TOF_no_p = calc_labels_TOF_no_p(labels, TOF_2_m2q_md)
% This function calculates the nominal TOF, when the particle is assumed to have
% a momentum component of zero magnitude along the TOF direction
	m2qfactor		= TOF_2_m2q_md.factor; 
	t0				= TOF_2_m2q_md.t0;

	labels_TOF_no_p = convert.m2q_2_TOF(labels, m2qfactor, t0);

end