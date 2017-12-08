function  [data_out] = R_circle(data_in, metadata_in, det_name)
% This macro corrects the detector centre by rotating.
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
    
    if general.struct.probe_field(metadata_in.corr.(detname).ifdo, 'R_circle') && ~general.struct.probe_field(data_in.h.(detname).corr_log, 'R_circle')
        % convert to radius:
        [theta, R] = cart2pol(data_out.h.(detname).X, data_out.h.(detname).Y);
        
		% Fetch the needed correction values:
		R_maxs			= metadata_in.corr.(detname).R_circle.R_maxs;
		R_avg			= metadata_in.corr.(detname).R_circle.R_avg;
		theta_sf	= metadata_in.corr.(detname).R_circle.theta;
		
		% rescale the radial values, so that they all line up to one
        % radius:
		R = correct.R_circle(R, theta, R_maxs, R_avg, theta_sf);
		
		 % convert back to cartesian:
        [data_out.h.(detname).X, data_out.h.(detname).Y] = pol2cart(theta, R);
		
        disp(['Log: Radial angle-dependent correction performed on ' detname])
        % add the correction name to the log:
        data_out.h.(detname).corr_log.R_circle = true;
    elseif general.struct.probe_field(data_in.h.(detname).corr_log, 'R_circle')
        disp(['Log: Radial angle-dependent correction already performed earlier on ' detname])
    else
        % no correction needed
        data_in.h.(detname).corr_log.R_circle = false;
    end

end
end
