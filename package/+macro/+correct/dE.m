function  [data_out] = dE(data_in, metadata_in, det_name)
% This macro corrects the E (for example for absolute scales).
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

    % find the E signal:
    idx_E     = find(strcmpi(metadata_in.det.(detname).signals, 'E [eV]'));

    if general.struct.probe_field(metadata_in.corr.(detname).ifdo, 'dE') && ~general.struct.probe_field(data_in.h.(detname).corr_log, 'dE')

        data_out.h.(detname).KER = data_in.h.(detname).raw(:,idx_E) - metadata_in.corr.(detname).dE;
        disp(['Log: delta E correction performed on ' detname])
%         write in the log:
        data_out.h.(detname).corr_log.dE = true;
    elseif general.struct.probe_field(data_in.h.(detname).corr_log, 'dE')
        disp(['Delta E correction already performed earlier on ' detname])
    else
        % no correction requested
        data_out.h.(detname).TOF      = data_in.h.(detname).raw(:,idx_E);
        data_out.h.(detname).corr_log.dTOF = false;
    end
    
end
end
