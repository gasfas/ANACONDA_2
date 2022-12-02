function  [data_out] = KER(data_in, metadata_in, det_name)
% This macro converts the momenta signals to KER signal.
% Input:
% data_in        The experimental data, already converted
% metadata_in    The corresponding metadata
% det_name      (optional) The name of the detector one wants to study.
% Output:
% data_out      The output data with converted data.
% metadata_out  The corresponding metadata
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

data_out = data_in;

if exist('det_name', 'var')
    detnames = {det_name};
else % No detector name is given, so we fetch all detector names:
    detnames = fieldnames(metadata_in.det);
end

for i = 1:length(detnames)
    detname = detnames{i};
	detnr	= general.data.pointer.detname_2_detnr(detname);
	
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
					data_out.h.(detname).KER = R_2_KE_EPICEA(metadata_in.conv.det1.KER, data_out.h.(detname).R);
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
end

%% Local subfunctions:
function [KER] = R_2_KE_EPICEA(KER_md, R)
% This function converts radia to energy values, specifically for the EPICEA 
% spectrometer electrons:
% We use the formula from Liu, Nicolas, and Miron, Rev. Sci. Instrum. 84, 033105 (2013)
% a_50			= -0.16504; %Dispersion coefficientat 50 eV pass;
% b_50			= 110.7; %Dispersion coefficient at 50 eV pass;
% [a, b]			= deal (a_50*KER_md.E_pass./50, b_50*KER_md.E_pass./50);

a			= -1.075  ; %(-1.523, -0.6275); %Dispersion coefficientat 250 eV pass;
b			= 430.2 ;%(316.8, 543.6); %Dispersion coefficient at 250 eV pass;

if KER_md.E_pass ~=	250 % If pass energy is not 250 eV, read the a and b values from metadata, if given:
    try a =KER_md.a	;	
        b =KER_md.b	;	
    catch
        error('Warning: a and b for 250 ev pass energy used')
    end
end

E0				= KER_md.E0;
R0				= KER_md.R0;
KER = convert.EPICEA.KE(R, E0, a, b, R0);
end
