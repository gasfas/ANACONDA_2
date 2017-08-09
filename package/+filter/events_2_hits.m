function [hit_filter] = events_2_hits(event_filter, events, nof_hits)
% This function translates an event filter into a hit filter. 
% Input:
% event_filter:         Boolean array, the original event filter [nof_events, 1].
%                       Note: if size(event_filter,2) > 1, it is compressed
%                       to a single column with AND condition.
% events:               The actual events, [nof_events, nof_det]
% nof_hits              Number of hits for every detector [1, nof_det]
% Output:
% hit_filter:           The filter that can be applied to the hits (struct 
%                       with fields 'det1', 'det2' etc)
[nof_events, nof_det] = size(events);

% If there are different events approved by different filter columns, we
% only approve the events that are approved by all columns:
if size(event_filter,2) > 1
    event_filter = all(event_filter,2);
end

% replace the NaN's with the value from the index below, so that we can index them:
events_and_nof_hits = general.matrix.downfill_array([events; nof_hits], 'NaN', 1);
events = events_and_nof_hits(1:end-1,:);

for det_nr = 1:nof_det
    det_nr_char = ['det' num2str(det_nr)]; % string with current detector number.
    
    % Make the filter for this detector:
    [hit_filter_det] = filter.events_2_hits_det(event_filter, events(:,det_nr), nof_hits(det_nr));

    % Store it in the right place:
    hit_filter.(det_nr_char).filt = logical(hit_filter_det);
end

end

