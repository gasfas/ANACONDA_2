function [data, data_form]= read_data_pointer(pointer, exp)
% Function that reads the data from a given experiment, with the pointer
% specified.
% Inputs:
% -pointer	String with the pointer to the signal
% -exp		(struct) Experimental data (with subfields e and h for events and hits
% Outputs:
% data		Array of data pointer
% data_form	The type of data, either 'hits' or 'events'
% read data from pointer:
	try data		= eval(['exp.' pointer]);
		% If the given string is not a valid field name, it might
		% be a script, with a signal in it:
	catch 
 % In case we have to prepare some ('hitnr') variables:
		hit_str_in_pointer = findstr(pointer, 'select_only_hit_');
		if ~isempty(hit_str_in_pointer)

			%% Find the detectors that suffer hit selection:
			% First, find which detector(s) were addressed:
			[detnames, detnrs, det_idxs]	= IO.data_pointer.pointer_2_detnames(pointer);
			% Then find out what the highest hit number for each detector
			% is:
			for k = 1:length(hit_str_in_pointer)
				[i, detname, detnr] = find_corr_det(k, hit_str_in_pointer, det_idxs, detnames, detnrs);
				% Find which hitnumber was requested:
				hitnr	= str2num(pointer(i+16)); % TODO: only up to 9 hits in one event allowed.
				try hitmax.(detname).max = max(hitmax.(detname).max, hitnr);
				catch hitmax.(detname).max = hitnr;
				end
			end

			%% creating the event filter:
			% Now we can create an event filter, that only allows events with sufficient hits on all respective detectors:
			e_f_all = true(size(exp.e.raw,1),1);
			fns = fieldnames(hitmax);
			for i = 1:length(fns)
				detname			= fns{i};
				detnr			= IO.detname_2_detnr(detname);
				nof_hits		= size(exp.h.(detname).raw, 1);
				e_f_all			= e_f_all & filter.events.multiplicity(exp.e.raw(:,detnr), hitmax.(detname).max, Inf, nof_hits);
			end

			%% Defining the hit rows:
			hitnrs = [];
			for k = 1:length(hit_str_in_pointer)
				[i, detname, detnr] = find_corr_det(k, hit_str_in_pointer, det_idxs, detnames, detnrs);
				% Find which hitnumber was requested:
				hitnr	= str2num(pointer(i+16)); % TODO: only up to 9 hits in one event allowed.
				% Write the new variable for this hitnumber:
				hit_rows.(detname).(['hit' num2str(hitnr)]) = exp.e.raw(e_f_all, detnr)+hitnr-1;
				% rename the hitnr in the string to the variable name (detector-specific):
				pointer(i:i+16) = [detname 'rplc_txt_hit' num2str(hitnr)] ;% to be replaced
				hitnrs = [hitnrs hitnr];
			end

				%% Rename the pointer:
			for k = 1:length(hit_str_in_pointer)
				[i, detname] = find_corr_det(k, hit_str_in_pointer, det_idxs, detnames, detnrs);
				pointer = replace(pointer,[detname 'rplc_txt_hit' num2str(hitnrs(k))],['hit_rows.' detname '.hit' num2str(hitnrs(k))]); % replace the string
			end
			% We start with NaNs, and fill up the valid entries:
			data = NaN*ones(size(exp.e.raw, 1),1); %TODO: one-dimensional array of data assumed here.
			data(e_f_all) = eval(pointer);
			data_form	= 'events';
		else
		data		=  eval(pointer);
		end
end
if ~exist('data_form', 'var') 
	if IO.data_pointer.is_event_signal(pointer)
		data_form = 'events';
	else
		data_form = 'hits';
	end
end
end

function [i, detname, detnr] = find_corr_det(k, hit_str_in_pointer, det_idxs, detnames, detnrs)
				i = hit_str_in_pointer(k);
				% Find which detector was addressed for this hitnr:
				det_mention_nr = find(i>det_idxs, 1, 'last');
				detname = detnames{det_mention_nr};
				detnr	= detnrs(det_mention_nr);
end