function  [data_out] = dpyz_2_angle(data_in, metadata_in, det_name)
% This macro converts the X,Y coordinates to R, theta (polar) coordinates.
% Input:
% data_in        The experimental data, already converted
% metadata_in    The corresponding metadata
% det_name      (optional) The name of the detector
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
    dpy = data_out.h.(detname).dp(:,2);
    dpz = data_out.h.(detname).dp(:,3);
   
    PyPz  = atan2(dpz,dpy);
    PyPz_neg         = find(PyPz <= 0);

    PyPz(PyPz_neg)      =  2*pi + PyPz(PyPz_neg);
    
    data_out.h.(detname).PolarPyPz  = PyPz;
    disp(['Log: dp to angle conversion performed on ' det_name])
end
end