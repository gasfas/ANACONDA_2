function  [data_out, hFig, hAx, hGraphObj] = fit(data_in, metadata_in)
% This macro executes a bunch of fits on the corrected and converted data.
% Input:
% data_in		The experimental data, already corrected and converted
% metadata_in   The corresponding metadata
% Output:
% data_out		The data with fitted data.
% SEE ALSO macro.correct, macro.convert, macro.filter

% The order of performing the different conversions depends on the order in
% which the detectors and 'ifdo' statements are defined in the metadata: 
% The ones defined first are evaluated first.

% execute all the conversion subroutines that are requested by the user:
[data_out] = general.macro.run_subroutines(data_in, metadata_in, 'fit');

end
