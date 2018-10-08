function [data_out] = correct(data_in, metadata_in)
% This macro applies the corrections to the
% raw signals. The result is given as an output.
% TODO: loop over corrections (all detectors), instead of all conversions
% for one detector.
% SEE ALSO macro.corrected_to_converted

% The order of performing the different corrections depends on the order in
% which the detectors and 'ifdo' statements are defined in the metadata: 
% The ones defined first are evaluated first.

% It is important that the correction procedure requested is described in a macro function
% defined with the exact same name as in the metadata, in the macro.correct directory.

% execute all the correction subroutines that are requested by the user:
[data_out] = general.macro.run_subroutines(data_in, metadata_in, 'correct');

%         write in the log:
% TODO: waiting for Lisa...
end
