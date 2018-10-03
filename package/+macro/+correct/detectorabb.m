function  [data_out] = detectorabb(data_in, metadata_in, det_name)
% This macro corrects the detector electrostatic abberation.
% Input:
% data_in        The experimental data.
% metadata_in    The corresponding metadata
% det_name      (optional) The name of the detector
% Output:
% data_out      The output data with corrected data.
% metadata_out  The corresponding metadata
data_out = data_in;

if exist('det_name', 'var')
    detnames = {det_name};
else % No detector name is given, so we fetch all detector names:
    detnames = fieldnames(metadata_in.det);
end

for i = 1:length(detnames)
    detname = detnames{i};  
    
    % find all X,Y,TOF signals:
    idx_X       = find(strcmp(metadata_in.det.(detname).signals, 'X [mm]'));
    idx_Y       = find(strcmp(metadata_in.det.(detname).signals, 'Y [mm]'));
%     idx_TOF     = find(strcmp(metadata_in.det.(detname).signals, 'TOF [ns]'));

    if ~general.struct.probe_field(data_out.h.(detname).corr_log, 'detectorabb')
        %         corrected.h.(detname).TOF = correct.Detector_abb(raw.h.(detname).raw(:,idx_TOF), metadata.corr.(detname)) 
        % Correction of the Drift tube/detector voltage mismatch.
        % First we correct the absolute TOF difference (from the theoretical value)
        % zero-Kinetic energy TOF correction:
        TOF_measured        = data_out.h.(detname).TOF;
        V_created           = metadata_in.spec.volt.Vs2a + (metadata_in.spec.volt.Ve2s - metadata_in.spec.volt.Vs2a) * metadata_in.spec.dist.s0./metadata_in.spec.dist.s;
        V_detector          = metadata_in.det.(detname).Front_Voltage;
        V_DriftTube         = metadata_in.spec.volt.Va2d;
        p_noKE              = metadata_in.corr.(detname).detectorabb.TOF_noKE.p_i;

        TOF_noKE       = correct.detector_abb.no_KE_TOF(TOF_measured, V_created, V_detector, V_DriftTube, p_noKE);

        % Radial TOF correction:
        if ~isempty(idx_X) && ~isempty(idx_Y)
            X                   = data_out.h.(detname).X;
            Y                   = data_out.h.(detname).Y;
            [theta, R]          = cart2pol(X, Y);
            R_det               = metadata_in.det.(detname).max_radius;
            p_R                 = metadata_in.corr.(detname).detectorabb.TOF_R.p_i;

            data_out.h.(detname).TOF = correct.detector_abb.R_TOF (TOF_noKE, V_created, V_detector, V_DriftTube, R, R_det, p_R);
        end

        % Then we correct the splat radius:
        if ~isempty(idx_X) && ~isempty(idx_Y)
            p_dR                = metadata_in.corr.(detname).detectorabb.dR.p_i;

            R_corr              = correct.detector_abb.dR(V_created, V_detector, V_DriftTube, R, R_det, p_dR);


            % Convert back to X and Y:
            [data_out.h.(detname).X, data_out.h.(detname).Y] = pol2cart(theta, R_corr);
        end

        disp(['Log: Detector abberation correction performed on ' detname])
        % add the correction name to the log:
        data_out.h.(detname).corr_log.detectorabb = true;
    elseif general.struct.probe_field(data_in.h.(detname).corr_log, 'detectorabb')
        disp('Log: Detector abberation correction already performed earlier')
    else
        % no correction needed
        data_out.h.(detname).corr_log.detectorabb = false;
    end
end

end
