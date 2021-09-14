function  [data_out] = lensabb(data_in, metadata_in, det_name)
% This macro corrects the detector electrostatic abberation.
% Input:
% data_in        The experimental data
% metadata_in    The corresponding metadata
% det_name      (optional) The name of the detector
% Output:
% data_out      The output data with corrected data.
% metadata_out  The corresponding metadata
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

data_out = data_in;

if exist('det_name', 'var');
    detnames = {det_name};
else % No detector name is given, so we fetch all detector names:
    detnames = fieldnames(metadata_in.det);
end

for i = 1:length(detnames);
    detname = detnames{i};  
    
    % find all X,Y,TOF signals:
    idx_X       = find(strcmp(metadata_in.det.(detname).signals, 'X [mm]'));
    idx_Y       = find(strcmp(metadata_in.det.(detname).signals, 'Y [mm]'));
%     idx_TOF     = find(strcmp(metadata_in.det.(detname).signals, 'TOF [ns]'));

    if ~general.struct.probe_field(data_out.h.(detname), 'corr_log.lensabb')       
        % First we correct the absolute TOF difference (from the theoretical value)
        % zero-Kinetic energy TOF correction:
        TOF_measured        = data_out.h.(detname).TOF;
        V_created           = metadata_in.spec.volt.Vs2a + (metadata_in.spec.volt.Ve2s - metadata_in.spec.volt.Vs2a) * metadata_in.spec.dist.s0./metadata_in.spec.dist.s;
        V_lens              = metadata_in.spec.volt.ion_lens1;
        V_DriftTube         = metadata_in.spec.volt.Va2d;
        p_noKE              = metadata_in.corr.(detname).lensabb.TOF_noKE.p_i;
        
        TOF_noKE       = correct.lens_abb.no_KE_TOF(TOF_measured, V_created, V_lens, V_DriftTube, p_noKE);
        
        % Radial TOF correction is not implemented yet for the lens-induced
        % abberation.        
   
        % Then we correct the splat radius:
        if ~isempty(idx_X) && ~isempty(idx_Y)
            X                   = data_out.h.(detname).X;
            Y                   = data_out.h.(detname).Y;
            [theta, R]          = cart2pol(X, Y);
            R_det               = metadata_in.det.(detname).max_radius;
            p_dR                = metadata_in.corr.(detname).lensabb.dR.p_i;

            R_corr              = correct.lens_abb.dR(V_created, V_lens, V_DriftTube, R, p_dR);

            % Convert back to X and Y:
            [data_out.h.(detname).X, data_out.h.(detname).Y] = pol2cart(theta, R_corr);
        end
        
        data_out.h.(detname).TOF = TOF_noKE;

        disp(['Log: Lens abberation correction performed on ' detname])
        % add the correction name to the log:
        data_out.h.(detname).corr_log.lensabb = true;
    elseif general.struct.probe_field(data_in.h.(detname).corr_log, 'lensabb')
        disp('Log: Lens abberation correction already performed earlier')
    else
        % no correction needed
        data_out.h.(detname).corr_log.lensabb = false;
    end
end

end
