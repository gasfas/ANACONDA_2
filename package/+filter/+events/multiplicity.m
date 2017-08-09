function [is_mult] = multiplicity(events, min, max, nof_hits)
%Filter out the events with the correct number of hits arriving in one event 
% (called multiplicity) coincidence number (single, double, triple,
% etcetera)
% Input:
% events:       the events that will be under investigation [nof_events, 1]
% min:          scalar, the minimum multiplicity
% max:          scalar, the maximum multiplicity
% nof_hits:     number of hits of the current detector, scalar
% Output:
% is_mult:      Boolean matrix [nof_events, 1], true for events within min
% and max multiplicity

% calculate the multiplicity of the event(number of hits in an event):
multiplicity = convert.event_multiplicity(events, nof_hits);

% Compare it with the minimum and maximum to create the filter:
is_mult =     (multiplicity >= min & multiplicity <= max);
end