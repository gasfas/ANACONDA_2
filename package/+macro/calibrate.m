function  [data_out] = calibrate(data_in, metadata_in)
% This macro executes a calibration of the corrected and converted signals.
% Input:
% data_in   The experimental data, already corrected and converted
% metadata_in   The corresponding metadata
% Output:
% data_out     .
% 
% The calibration executed:
% - TOF to m2q for factor and t0
% - TODO: momentum, KER



data_out = data_in;

% We fetch the detector names:
detnames = fieldnames(metadata_in.det);

for i = 1:length(detnames)
    detname = detnames{i};
    
    if general.struct.probe_field(metadata_in, ['calib.' detname '.ifdo.TOF_2_m2q']) && all(isfield(data_out.h.(detname), {'TOF'}))
        [data_out] = macro.calibrate.TOF_2_m2q(data_out,metadata_in, detname);
    end
end