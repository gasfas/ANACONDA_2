
function  [data_out] = dpxyz_2_angle(data_in, metadata_in, det_name)
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
    dp              = data_out.h.(detname).dp;
    dpx             = dp(:,1);
    dpy             = dp(:,2);
    dpz             = dp(:,3);
   
    data_out.h.(detname).PolarAngle3D               = acos(dpx./sqrt(dpx.^2 + dpy.^2 + dpz.^2));
    az                                              = atan2(dpz,dpy);
    az_neg                                          = find(az <= 0);

    az(az_neg)      =  2*pi + az(az_neg);
    
    data_out.h.(detname).AzAngle3D = az;
end
end