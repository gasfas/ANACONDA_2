function handle = fill_struct(handle, struct)
% This function takes a handle, and fills in the subfields of a struct (with similar
% names) into the handle. Also subfields are supported, if the names are
% exactly similar. If the handle given is a collection of handles, all are
% treated the same. If 'handle' is not a handle at all, The function
% returns it in the original form. If a collection of structs are given,
% only the first one is added.
% Inputs:
% handle	The handle to be filled in 
% struct	The struct containing the fields that need to be overwritten.

if ~isempty(struct(1)) && ishandle(handle(1))
	% Check the fieldnames of the handle and the struct:
	h_fn = fieldnames(handle);
	s_fn = fieldnames(struct);
	% Count the number of handles and structs given:
	nof_h = numel(handle);
	nof_s = numel(struct);
	% If they are not the same amount, only the first valid numbers are
	% used:
	if nof_h < nof_s
		struct = struct(1:nof_h);
	end

	% find the read-only fields, we will not try to change those:
	get_fields			= get(handle(1));
	set_fields			= set(handle(1));
	read_only_fields	= setdiff(fieldnames(get_fields), fieldnames(set_fields));

	% Compare the two and see which are similar:
	loc_h = ismember(h_fn, s_fn);
	% Filter the fieldnames that are the same:
	sim_fn = h_fn(loc_h);
	for i = 1:length(sim_fn)
		if ~any(strcmp(sim_fn{i}, read_only_fields))
			if any(ishandle(handle(1).(sim_fn{i}))) & ~isnumeric(handle(1).(sim_fn{i}))
				% Overwrite the found subfield:
				for h_nr = 1:nof_h
					structnr = min(length(struct), h_nr);
					% If the given struct is smaller than the handle, we fill the handle with the last element in the struct:
					handle(h_nr).(sim_fn{i}) = general.handle.fill_struct(handle(h_nr).(sim_fn{i}), struct(structnr).(sim_fn{i}));
				end
			else
				% overwrite the found field:
				for h_nr = 1:nof_h
					try 
						% If the given struct is smaller than the handle, we fill the handle with the last element in the struct:
						structnr = min(length(struct), h_nr);
						handle(h_nr).(sim_fn{i}) = struct(structnr).(sim_fn{i});
					catch warning(['Struct field ' sim_fn{i} ' failed to copy'])
					end
				end
			end
		end
	end
end