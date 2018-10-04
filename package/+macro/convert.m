function  [data_out] = convert(data_in, metadata_in)
% This macro executes a bunch of conversions of the corrected signals.
% Input:
% data_in		The experimental data, already corrected
% metadata_in   The corresponding metadata
% Output:
% data_out		The data with converted data.
% 
% The conversions executed:
% - TOF to m2q
% - TODO: X, Y, TOF to px,py,pz
% SEE ALSO macro.raw_to_corrected, macro.filter_to_plot
% macro.converted_to_filter

% The order of performing the different corrections depends on the order in
% which the detectors and 'ifdo' statements are defined in the metadata: 
% The ones defined first are evaluated first.

% execute all the conversion subroutines that are requested by the user:
[data_out] = general.macro.run_subroutines(data_in, metadata_in, 'convert');
