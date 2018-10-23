function [hit_filter] = events_2_hits_det(event_filter, events, nof_hits)
% This function translates an event filter into a hit filter, for one detector only. 
% Input:
% event_filter:         Boolean array, the original event filter [nof_events, 1].
%                       Note: if size(event_filter,2) > 1, it is compressed
%                       to a single column with AND condition.
% events:               The actual events, [nof_events, 1]
% nof_hits              Number of hits 
% Output:
% hit_filter:           The filter that can be applied to the hits [nof_hits, 1]
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% If there are different events approved by different filter columns, we
% only approve the events that are approved by all columns:
if size(event_filter,2) > 1
    event_filter = all(event_filter,2);
end

if nof_hits == 0 % if there is not a single event with hits:
	hit_filter = logical.empty(nof_hits, 0);
else
	% If an event is approved by the filter (event_filter), but no hits are 
	% registered by a certain detector (NaN in `events(:,det_nr)'), the event filter needs 
	% to be changed to false in that index:
	event_filter = ~isnan(events) & event_filter;
	% In words: the event filter is different for every detector, because some
	% detector might not have a hit registered for that event. This does not
	% mean that that event should be disproved, simply that no hit should be
	% taken from that event and detector. Thus, it only involves the filter of
	% that detector.

	% replace the NaN's with the value from the index below, so that we can index them:
	events_and_nof_hits = general.matrix.downfill_array([events; nof_hits], 'NaN', 1);
	events = events_and_nof_hits(1:end-1,:);

	% initiate the hit filter array:
	hit_filter = NaN*ones(nof_hits, 1);
	% fill in the disproved events:
	hit_filter(events(~event_filter)) = false;
	% and the approved events:
	hit_filter(events(event_filter)) = true;
	% upfill the remaining NaN's (the hits that are not the first of the
	% event, but still part of the same event):
	hit_filter = general.matrix.upfill_array(hit_filter, 'NaN', 1);
	% make the array into a logical array:
	hit_filter = logical(hit_filter);
end

end