function [hit_var] = events_2_hits_det(event_var, events, nof_hits)
% This function translates an event value into a hit value for all hits 
% in the event, for one detector only. 
% Input:
% event_var:			Array, the original event values [nof_events, w].
% events:               The event indices, [nof_events, 1]
% nof_hits              Number of hits 
% Output:
% hit_var:				The values that apply to the hits [nof_hits, w]

% replace the NaN's with the value from the index below, so that we can index them:
events_and_nof_hits = general.matrix.downfill_array([events; nof_hits], 'NaN', 1);
events = events_and_nof_hits(1:end-1,:);
% the width of the matrix:
w = size(event_var, 2);
% We have to fill the initial array with a value not existing in var:
init_var = max(unique(event_var), [],'omitnan') + 1;
% initiate the hit variable array:
hit_var = init_var*ones(nof_hits, w);
% fill in the event values:
hit_var(events) = event_var;
% upfill the remaining values (the hits that are not the first of the
% event, but still part of the same event):
hit_var = general.matrix.upfill_array(hit_var, init_var, 1);

end

