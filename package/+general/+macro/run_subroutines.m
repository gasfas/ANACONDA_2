function [data_out] = run_subroutines(data_in, metadata_in, routine_name)
% This macro routing reads the metadata of one certain step (routine) in the analysis
% (correct, convert, etc), and checks which routines the user wants to
% perform in that step. 
% Input:
% data_in		The experimental data, already corrected
% metadata_in   The corresponding metadata
% routine_name	The name of analysis routine (for example 'convert', 'correct', etc.)
% Output:
% data_out		The data with converted data.

% Copy the data:
data_out = data_in;

% Find the short names of the routines:
switch routine_name
	case 'convert'
		routine_shortname = 'conv';
	case 'correct'
		routine_shortname = 'corr';
	case 'filter'
		routine_shortname = 'filt';
	case 'fit'
		routine_shortname = 'fit';
end

% Find the routines of detectors (or crossdetector) that are requested:
detnames = fieldnames(metadata_in.(routine_shortname));
for i = 1:length(detnames)
	detname = detnames{i};
	% find the requested correction routines:
	subroutine_names = general.struct.probe_field(metadata_in.(routine_shortname).(detname), 'ifdo');
	if ~isempty(subroutine_names) && isstruct(subroutine_names)
		% loop over all the mentioned subroutines:
		subroutine_name = fieldnames(subroutine_names);
		for j = 1:length(fieldnames(subroutine_names))
			% see if the user wants to perform this subroutine:
			if general.struct.probe_field(metadata_in.(routine_shortname).(detname).ifdo, subroutine_name{j})
				% see if the requested procedure exists:
% 				macro.(routine_name).(subroutine_name{j})
				% try to execute the subroutine procedure:
				try data_out = macro.(routine_name).(subroutine_name{j})(data_out, metadata_in, detname);
				catch disp(['Log: the ' routine_name ' macro called ' subroutine_name{j} ' failed to run on ' detname])
				end
			end
		end
				
	end
end

end