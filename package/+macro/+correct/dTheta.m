function  [data_out] = dTheta(data_in, metadata_in, det_name)
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

for i = 1:length(detnames);
    detname = detnames{i};  
    
    if general.struct.probe_field(metadata_in.corr.(detname).ifdo, 'dTheta') && ~general.struct.probe_field(data_in.h.(detname).corr_log, 'dTheta')
        % rotate the X,Y -values so that the polarization vector is along x:
        % convert to radius:
        [theta, R] = cart2pol(data_out.h.(detname).X, data_out.h.(detname).Y);
        % rotate the specified angle:
        theta = theta + metadata_in.corr.(detname).dTheta*pi/180;
        % convert back to cartesian:
        [data_out.h.(detname).X, data_out.h.(detname).Y] = pol2cart(theta, R);

        disp(['Log: Detector image rotation correction performed on ' detname])
        % add the correction name to the log:
        data_out.h.(detname).corr_log.dTheta = true;
    elseif general.struct.probe_field(data_in.h.(detname).corr_log, 'dTheta')
        disp(['Log: Detector image rotation correction already performed earlier on ' detname])
    else
        % no correction needed
        data_in.h.(detname).corr_log.dTheta = false;
    end

end
end
