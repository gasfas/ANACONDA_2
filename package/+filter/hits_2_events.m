function [event_filter] = hits_2_events(hit_filter, events, nof_hits, condition)
% This function translates a hit filter into an event filter. 
% Input:
% hit_filter:           Boolean array, the original hit filter [nof_events, 1].
% events:               The event indeces of the same detector, [nof_events, 1]
% nof_hits              Number of hits for the relevant detector (scalar)
% condition:            String with three possibilities:
%                         1. 'AND': all hits in an event must be
%                         approved.
%                         2. 'OR': one or more hits in one event must be
%                         approved by hit_filter.
%                         2. 'XOR': exclusively one hit in one event must be
%                         approved by hit_filter.
%                         2. 'hit1': the first hit in the event must be
%                         approved by hit_filter.
%                         2. 'hit2': the second hit in the event must be
%                         approved by hit_filter.
%                         3. [n, 1] numeric (integer) array. This array
%                         gives the number of approved hits in an event that
%                         should result in an approved event.
% Output:
% event_filter:         The filter that can be applied to the events [nof_events, 1]


switch condition
	case 'hit1'
		event_filter = select_hit_nr(hit_filter, events, nof_hits, 1);
	case 'hit2'
		event_filter = select_hit_nr(hit_filter, events, nof_hits, 2);
	case 'hit3'
		event_filter = select_hit_nr(hit_filter, events, nof_hits, 3);
	otherwise
		event_filter = select_condition(hit_filter, events, nof_hits, condition);
end
end
% Local subfunctions:
function event_filter = select_hit_nr(hit_filter, events, nof_hits, hitnr)
% In case a hit number is specified, the hit filter is calculated again,
% afterwards the event filter is calculated with an 'XOR' condition.
% First calculate the events that contain enough hits:
event_hitnr_filter	= filter.events.multiplicity(events, hitnr, Inf, nof_hits);
% Translate this to the hit indeces:
hitnr_idx = events(event_hitnr_filter) + hitnr - 1;
% Initiate a new hit filter
hit_filter_2 = false(size(hit_filter));
% Fill in the hits that are approved by the hit filter, and are hit nr 3:
hit_filter_2(hitnr_idx) = hit_filter(hitnr_idx);
% Now convert this hit filter to an event filter:
event_filter = select_condition(hit_filter_2, events, nof_hits, 'XOR');
end

function event_filter = select_condition(hit_filter, events, nof_hits, condition)
% In case an 'AND', 'OR' or 'XOR' condition is chosen:
% Calculate the accumulative sum of the hit_filter, so that we know how
% many hits are approved:
CS = cumsum(hit_filter);
% fetch the events that registered a hit:
is_NaN_event = isnan(events);
events_noNaN = events(~is_NaN_event);% (events_noNan(1) must be 1)
% Initiate the event filter:
event_filter = false(size(events,1), size(hit_filter,2));
% Then fetch the values at event starts from that array:
approved_hits_before_eventstart = [zeros(1,size(hit_filter,2)); CS(events_noNaN(2:end)-1,:)];
% Take the difference, so that the number of approved hits per event are shown:
approved_hits_in_event = diff([approved_hits_before_eventstart; sum(hit_filter, 1)], 1, 1);
switch condition
	case 'OR' % If CS is larger than zero, this means that at least one hit in
	% that event is approved:
	event_filter(~is_NaN_event,:) = (approved_hits_in_event > 0);
	case 'XOR' %'Exclusive OR': only one of the hits in the event approved.
	event_filter(~is_NaN_event,:) = (approved_hits_in_event == 1);
	case 'AND'	% We can compare the number of approved hits per event with the 
	% number of hits in the event:
	multiplicity = convert.event_multiplicity(events_noNaN, nof_hits);
	% If the two numbers are equal, this means all the hits in that event are approved, thus
	% the event is approved as well
	event_filter(~is_NaN_event,:) = (approved_hits_in_event == repmat(multiplicity,1,size(hit_filter,2)));
	otherwise
	% We assume the user has given a certain number of approved hits in an event, that should result in an approved event.
	% The condition format should be a column:
	if size(condition, 2) > 1; condition = transpose(condition); end
	% Verify the number of approved hits:
	approved_events     = any(repmat(approved_hits_in_event, 1, length(condition)) == repmat(condition',size(approved_hits_in_event,1),1), 2);
	event_filter(~is_NaN_event) = approved_events;
end
end