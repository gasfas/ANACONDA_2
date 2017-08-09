function [hit_var_sorted] = sorted_hits(hit_var, events, direction)
%This function re-shuffles a hit signal, such that their values are stored 
% in a sorted manner for each event. So for example, the first value is the
% smallest, and the value increases to the last value of the event.
% Inputs:
% - hit_var         The hit variable
% - events          The event numbers
% - type			(char) The type of extrem: 'max' or 'min' or 'min&max'
% Outputs:
% - hit_var_sorted  The hit variable, but event sorted.
if ~exist('direction', 'var')
	direction = 'ascend';
end

[ hit_var_sorted ] = convert.event_extreme(hit_var, events, 'sorted', direction);