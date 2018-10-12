function  [data_out] = convert(data_in, metadata_in)
% This macro executes a bunch of conversions of the corrected signals.
% Input:
% data_in		The experimental data, already corrected
% metadata_in   The corresponding metadata
% Output:
% data_out		The data with converted data.
% 
% The conversions executed:
% - m2q, px,py,pz,KER and many more
% SEE ALSO macro.correct, macro.filter, macro.fit

% The order of performing the different conversions depends on the order in
% which the detectors and 'ifdo' statements are defined in the metadata: 
% The ones defined first are evaluated first.

% execute all the conversion subroutines that are requested by the user:
[data_out] = general.macro.run_subroutines(data_in, metadata_in, 'convert');

end