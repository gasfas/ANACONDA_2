function event_data = event_hitnr_det(hit_data, events, hitname)
% This function takes a hit value, and stores it at the row index of the
% event. The user indicates which hit is selected. Only one detector. If
% that hit is not detected, NaN is returned in that row.
% Inputs:
% hit_data		The array of the hits (n, l);
% events		The event indeces of the relevant detector (m, 1);
% hitnr			(Optional) Specification of which hit to choose. Possibilities:
%				- 'hit1' (or 2, 3, etc), will pick the first, second, etc
%				hit.
%				- 'first', the first as 'hit1'
%				- 'last', the last hit of the event.
%				- 1 (integer number), will choose the first, second,
%				etcetera. 
%				(Default: 'hit1')
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if ~exist('hitname', 'var') % No hitname given, we give default value:
	hitname = 'hit1';
end

if ischar(hitname)
	if contains(hitname, 'hit')
		hitnr = str2num(hitname(4:end));
	elseif strcmpi(hitname, 'first')
		hitnr = 1;
	end
else
	hitnr = hitname;
end

nof_hits = length(hit_data);
% Count the number of hits in each event (multiplicity):
event_mult = convert.event_multiplicity(events, nof_hits);
% Initiate an empty event data array:
event_data = NaN*ones(size(events, 1), size(hit_data, 2));
% If no hits have been registered on this detector, we remove it from the
% event list:
valid_events = events;

switch hitname
	case {'last'}
		isinvalid				= event_mult < 1;
		valid_events(~isinvalid) = [];
		event_data(valid_events, :) = hit_data(int32(valid_events)+event_mult(event_mult ~=0)-1, :);
	otherwise
		isinvalid				= event_mult < hitnr;
		valid_events(isinvalid) = [];
		event_data(~isinvalid, :) = hit_data(int32(valid_events)+hitnr-1, :);
end
end