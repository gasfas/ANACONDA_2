function  [fit_param, hFig, hAx, hLine] = angle_p_corr_C2(data_in, metadata_in, det_name)
% This macro executes momentum angle fits for double coincidence.
% Input:
% data_in        The experimental data, already converted
% metadata_in    The corresponding metadata
% det_name      (optional) The name of the detector
% Output:
% data_out      The output data with converted data.
% metadata_out  The corresponding metadata

[fit_param, hFig, hAx, hLine] = angle_p_corr(data_in, metadata_in, 2, det_name);

end