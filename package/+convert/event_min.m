function var_min = event_min(hit_var, events)
%This function calculates the minimum value of a variable of an event, of for 
% example the momentum or energy (hit variable).
% This function returns the minimum value of the hits that are non-NaN's. If
% there are NaN hits in an event, it will not be considered.
% Inputs:
% - hit_var         The hit variable
% - events          The event numbers
% Outputs:
% var_mean          The variable average.

% call the function that fetches the extreme value in one-event hits:
var_min = convert.event_extreme(hit_var, events, 'min');

end

