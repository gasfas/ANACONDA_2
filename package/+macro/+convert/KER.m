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
	
	switch metadata_in.spec.det_modes{detnr}
		case 'ion' % we assume a TOF mass spectrometer, and that the momenta are known.
			% Momentum to Kinetic energy conversion:
			m_l         = data_out.h.(detname).m_l;
			dp			= data_out.h.(detname).dp;
			% Calculate the kinetic energy:
			data_out.h.(detname).KER	= convert.p_2_KE(0, dp, m_l);
			% The sum of all Kinetic energies in one event (if possible):
			try data_out.e.(detname).KER_sum = convert.event_sum(data_out.h.(detname).KER, data_out.e.raw(:,detnr)); catch; end
		case 'electron' % we assume that we need to calculate KE with a custom formula for each spectrometer:
			switch metadata_in.spec.name
				case 'EPICEA'
					data_out.h.(detname).KER = R_2_KE_EPICEA(metadata_in.conv.det1.KER, data_out.h.(detname).R)
                case 'CIEL'
                	% Momentum to Kinetic energy conversion:
					m_l         = data_out.h.(detname).m_l;
					dp			= data_out.h.(detname).dp;
					% Calculate the kinetic energy:
					data_out.h.(detname).KER	= convert.p_2_KE(0, dp, m_l);
					% The sum of all Kinetic energies in one event (if possible):
					try data_out.e.(detname).KER_sum = convert.event_sum(data_out.h.(detname).KER, data_out.e.raw(:,detnr)); catch; end
			otherwise
					error('spectrometer not recognized. TODO: implement KER conversion routine for this spectrometer')
			end
		otherwise
			error('no KER conversion for this type of particle')
	end
			disp(['Log: Kinetic energy release conversion performed on ' detname])
end

%% Local subfunctions:
function [KER] = R_2_KE_EPICEA(KER_md, R)
% This function converts radia to energy values, specifically for the EPICEA 
% spectrometer electrons:
% We use the formula from Liu, Nicolas, and Miron, Rev. Sci. Instrum. 84, 033105 (2013)
a_50			= -0.16504; %Dispersion coefficientat 50 eV pass;
b_50			= 110.7; %Dispersion coefficient at 50 eV pass;
[a, b]			= deal (a_50*KER_md.E_pass./50, b_50*KER_md.E_pass./50);
E0				= KER_md.E0;
R0				= KER_md.R0;
KER = E0 + a*(R - R0) + b*(1./R - 1./R0);
end
