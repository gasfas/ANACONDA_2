function  [data_out] = convert(data_in, metadata_in)
% This macro executes a bunch of conversions of the corrected signals.
% Input:
% corrected     The experimental data, already converted
% metadata_in   The corresponding metadata
% Output:
% converted     The data with converted data.
% 
% The conversions executed:
% - TOF to m2q
% - TODO: X, Y, TOF to px,py,pz
% SEE ALSO macro.raw_to_corrected, macro.filter_to_plot
% macro.converted_to_filter

% execute the TOF to m2q conversion if TOF is one of the signals:
data_out = data_in;

% We fetch the detector names:
detnames = fieldnames(metadata_in.det);

for i = 1:length(detnames)
    detname = detnames{i}; 
	
    %% Hit conversion
    % R, theta conversion:
    if general.struct.probe_field(metadata_in, ['conv.' detname '.ifdo.R_theta']) && all(isfield(data_out.h.(detname), {'X', 'Y'}))
        [data_out] = macro.convert.R_theta(data_out, metadata_in, detname);
    end
    
    % Perform the m2q : 
    if general.struct.probe_field(metadata_in, ['conv.' detname '.ifdo.m2q']) && all(isfield(data_out.h.(detname), {'TOF'}))
        data_out = macro.convert.TOF_2_m2q(data_out, metadata_in, detname);
    end
    
    % m2q labeling:
    if general.struct.probe_field(metadata_in, ['conv.' detname '.ifdo.m2q_label']) && all(isfield(data_out.h.(detname), {'m2q'}))
        [data_out] = macro.convert.m2q_2_m2q_label(data_out, metadata_in, detname);
    end
    
    % m2q labeling of double coincidences
    if general.struct.probe_field(metadata_in, ['conv.' detname '.ifdo.m2q_label_Ci']) && all(isfield(data_out.h.(detname), {'m2q'}))
        [data_out] = macro.convert.m2q_2_m2q_label_Ci(data_out, metadata_in, detname);
    end
    
    % m2q group labeling
    if general.struct.probe_field(metadata_in, ['conv.' detname '.ifdo.m2q_group']) && all(isfield(data_out.h.(detname), {'m2q'}))
        [data_out] = macro.convert.m2q_2_m2q_group_label(data_out, metadata_in, detname);
    end
    
    % Cluster specific: Count number of constituents in measured fragment:
    if general.struct.probe_field(metadata_in, ['conv.' detname '.ifdo.cluster_size']) && all(isfield(data_out.h.(detname), {'m2q'}))
        [data_out] = macro.convert.m2q_2_cluster_size(data_out, metadata_in, detname);
    end    
    
    % Momentum conversion:    
    if general.struct.probe_field(metadata_in, ['conv.' detname '.ifdo.momentum']) && all(isfield(data_out.h.(detname), {'X', 'Y'}))
        [data_out] = macro.convert.momentum(data_out, metadata_in, detname);
    end
    
    % KER conversion:  
    if general.struct.probe_field(metadata_in, ['conv.' detname '.ifdo.KER']) 
        [data_out] = macro.convert.KER(data_out, metadata_in, detname);
	end
    
    % p_2_p angle, mutual angle between double coincident fragment momenta.
    if general.struct.probe_field(metadata_in, ['conv.' detname '.ifdo.angle_p_corr_C2']) && all(isfield(data_out.h.(detname), {'dp'}))
        [data_out] = macro.convert.angle_p_corr_Ci(data_out, metadata_in, 2, detname);
    end
 
    % p1_2_p2_2_p3 angle, mutual angle between triple coincident fragment momenta.
    if general.struct.probe_field(metadata_in, ['conv.' detname '.ifdo.angle_p_corr_C3']) && all(isfield(data_out.h.(detname), {'dp'}))
        [data_out] = macro.convert.angle_p_corr_Ci(data_out, metadata_in, 3, detname);
    end
    
    % p1_2_p2_2_p3 angle, mutual angle between triple coincident fragment momenta.
    if general.struct.probe_field(metadata_in, ['conv.' detname '.ifdo.angle_p_corr_C4']) && all(isfield(data_out.h.(detname), {'dp'}))
        [data_out] = macro.convert.angle_p_corr_Ci(data_out, metadata_in, 4, detname);
    end
    
    % p_2_pol_angle, angle between fragment momentum and polarization.
    if general.struct.probe_field(metadata_in, ['conv.' detname '.ifdo.p_2_pol_angle']) && all(isfield(data_out.h.(detname), {'dp'}))
        [data_out] = macro.convert.angle_p_2_eps(data_out, metadata_in, detname);        
    end   

    % Conversion to group histograms (for size distribution plots)
    if general.struct.probe_field(metadata_in, ['conv.' detname '.ifdo.q_label_hist']) && all(isfield(data_out.h.(detname), {'m2q'}))
        [data_out] = macro.convert.group_hist(data_out, metadata_in, detname);        
	end

	% Hack: overwrite signal with scrambled data:
    % Generation of background signal from physical data:
    if general.struct.probe_field(metadata_in, ['conv.' detname '.ifdo.bgr'])
        [data_out] = macro.convert.signal_2_bgr(data_out, metadata_in, detname);        
	end
	%% Event conversion:
    % Calculation of the position of the ionization point.
    if general.struct.probe_field(metadata_in, ['conv.' detname '.ifdo.source_position'])
        [data_out] = macro.convert.source_position(data_out, metadata_in, detname);
	end
	    
    % Calculation of the position of the Charge Separation Distance.
    if general.struct.probe_field(metadata_in, ['conv.' detname '.ifdo.CSD'])
        [data_out] = macro.convert.CSD(data_out, metadata_in, detname);
    end
	    
    % Calculation of the position of the Fragment asymmetry factor of an event.
    if general.struct.probe_field(metadata_in, ['conv.' detname '.ifdo.fragment_asymmetry'])
        [data_out] = macro.convert.fragment_asymmetry(data_out, metadata_in, detname);
    end	
end

% Cross-detector conversions:
% p_2_p angle, mutual angle between momenta from different detectors.
if general.struct.probe_field(metadata_in, ['conv.crossdet.ifdo.angle_p_corr'])
	[data_out] = macro.convert.angle_p_corr_crossdet(data_out, metadata_in);
end
end