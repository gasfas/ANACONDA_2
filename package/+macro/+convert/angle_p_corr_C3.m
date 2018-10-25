function  [data_out] = angle_p_corr_C3(data_in, metadata_in, det_name)
% This macro calculates the angle between same-event momenta, in triple coincidence.
% Input:
% data_in       The experimental data, already converted
% metadata_in   The corresponding metadata
% det_name      (optional) The name of the detector
% Output:
% data_out      The output data with converted data.
% metadata_out  The corresponding metadata
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

data_out = macro.convert.angle_p_corr_Ci(data_in, metadata_in, 3, det_name);

end
