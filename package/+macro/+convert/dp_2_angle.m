function  [data_out] = dpxz_2_angle(data_in, metadata_in, det_name)
% This macro converts the X,Y coordinates to R, theta (polar) coordinates.
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
    
    [data_out.h.(detname).dpxzPolar ] = car2pol(data_out.h.(detname).dp(:,1), data_out.h.(detname).dp(:,3));
    disp(['Log: dp to angle conversion performed on ' det_name])
end
end