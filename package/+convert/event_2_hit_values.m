function [hit_values] = event_2_hit_values(event_values, events, nof_hits)
% This function moves an event value into hit array format, 
% with the event value the same for all hit values. For one detector only 
% Input:
% event_value:         Double array, the original event filter [nof_events, 1].
%                       Note: if size(event_filter,2) > 1, it is compressed
%                       to a single column with AND condition.
% events:               The actual events, [nof_events, nof_det]
% nof_hits              Number of hits 
% Output:
% hit_filter:           The filter that can be applied to the hits (struct 
%                       with fields 'det1', 'det2' etc)
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% If there are different events approved by different filter columns, we
% only approve the events that are approved by all columns:
if size(event_values,2) > 1
    event_values = all(event_values,2);
end

% If an event is approved by the filter (event_filter), but no hits are 
% registered by a certain detector (NaN in `events(:,det_nr)'), the event filter needs 
% to be changed to false in that index:
event_values(isnan(events)) = NaN;
% In words: the event filter is different for every detector, because some
% detector might not have a hit registered for that event. This does not
% mean that that event should be disproved, simply that no hit should be
% taken from that event and detector. Thus, it only involves the filter of
% that detector.

% replace the NaN's with the value from the index below, so that we can index them:
events_and_nof_hits = general.matrix.downfill_array([events; nof_hits], 'NaN', 1);
events = events_and_nof_hits(1:end-1,:);

% initiate the hit filter array:
hit_values = NaN*ones(nof_hits, 1);
% fill in the disproved events:
hit_values(events) = event_values;
% upfill the remaining NaN's (the hits that are not the first of the
% event, but still part of the same event):
hit_values = general.matrix.upfill_array(hit_values, 'NaN', 1);
end

