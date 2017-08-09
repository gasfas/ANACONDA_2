function [ var_sum ] = event_sum(hit_var, events, remove_NaN)
%This function calculates the sum of a variable of an event, of for 
% example the momentum or energy. This can later be used in a conservation
% criterium.
% Inputs:
% - hit_var         The hit variable
% - events          The event numbers
% remove_NaN        (optional) logical value whether the hit NaN's should be treated as
%                   zero. Default=0.
% Outputs:
% var_sum           The variable sum.

[nof_events]        = size(events, 1);
e_NaN_f             = isnan(events);
h_NaN_f             = isnan(hit_var);
% removing the NaNs from the events:
events_noNaN = events(~e_NaN_f);

% changing the NaNs from the hits to zero (so they do not disturb the sum):
hit_var_noNaN           = hit_var;
hit_var_noNaN(h_NaN_f)  = 0;
% events_noNan(1) must be 1, from principle of data format.

% The method is as follows: a cumulative sum is calculated, over all hits. 
% From that array, the values at the event starts are fetched.
% The difference between consecutive event starts is the sum value of the event.

% cumulative sum:
var_CS            = cumsum(hit_var_noNaN, 1);

% The variable sum at the eventstart:
var_sum_at_hit0       = [zeros(1,size(hit_var_noNaN, 2)); var_CS(events_noNaN(2:end)-1,:)];

% The difference between neighbouring events:
var_sum_noNaN = diff([var_sum_at_hit0; sum(hit_var_noNaN,1)],1);

% Placing it in the total nof event size filter:
var_sum = NaN * zeros(nof_events, size(hit_var,2));
var_sum(~e_NaN_f,:) = var_sum_noNaN;

% replacing all event sums with NaN's if the hits contained one or more:
if ~exist ('remove_NaN', 'var')
    remove_NaN = false;
end

if ~remove_NaN % The NaN's have to be translated into the events
    % Translate the NaN hit filter to the event filter:
    h_NaN_f_e = filter.hits_2_events(h_NaN_f, events, length(h_NaN_f), 'OR');
    % place the NaN's:
    var_sum(h_NaN_f_e) = NaN;
end

end

