function  [data_out] = dTOF(data_in, metadata_in, det_name)
% This macro corrects the TOF (for example for signal propagation times).
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

if exist('det_name', 'var')
    detnames = {det_name};
else % No detector name is given, so we fetch all detector names:
    detnames = fieldnames(metadata_in.det);
end

for i = 1:length(detnames)
    detname = detnames{i};  

    % find the TOF signal:
    idx_TOF     = find(strcmp(metadata_in.det.(detname).signals, 'TOF [ns]'));

    if general.struct.probe_field(metadata_in.corr.(detname).ifdo, 'dTOF') 

        data_out.h.(detname).TOF = data_in.h.(detname).raw(:,idx_TOF) - metadata_in.corr.(detname).dTOF;
        disp(['Log: delta TOF correction performed on ' detname])
    else
        % no correction needed
        data_out.h.(detname).TOF      = data_in.h.(detname).raw(:,idx_TOF);
        
    end
end
end
