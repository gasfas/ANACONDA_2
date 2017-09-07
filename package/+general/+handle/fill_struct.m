function handle = fill_struct(handle, struct)
% This function takes a handle, and fills in the subfields (with similar
% names) into the handle. Also subfields are supported, if the names are
% exactly similar. If the handle given is a collection of handles, all are
% treated the same.
% Inputs:
% handle	The handle to be filled in 
% struct	The struct containing the fields that need to be overwritten.

% Check the fieldnames of the handle and the struct:
h_fn = fieldnames(handle);
s_fn = fieldnames(struct);
nof_h = numel(handle);

% find the read-only fields, we will not try to change those:
get_fields			= get(handle);
set_fields			= set(handle);
read_only_fields	= setdiff(fieldnames(get_fields), fieldnames(set_fields));

% Compare the two and see which are similar:
loc_h = ismember(h_fn, s_fn);
% Filter the fieldnames that are the same:
sim_fn = h_fn(loc_h);
for i = 1:length(sim_fn)
	if ~any(strcmp(sim_fn{i}, read_only_fields))
		if any(ishandle(handle(1).(sim_fn{i}))) && ~isnumeric(handle(1).(sim_fn{i}))
			% Overwrite the found subfield:
			for h_nr = 1:nof_h
				handle(h_nr).(sim_fn{i}) = general.handle.fill_struct(handle(h_nr).(sim_fn{i}), struct.(sim_fn{i}));
			end
		else
			% overwrite the found field:
			for h_nr = 1:nof_h
				handle(h_nr).(sim_fn{i}) = struct.(sim_fn{i});
			end
		end
	end
end