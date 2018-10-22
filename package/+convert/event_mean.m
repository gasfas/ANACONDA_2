function [ var_mean, var_std ] = event_mean(hit_var, events)
%This function calculates the mean value of a variable of an event, of for 
% example the momentum or energy. First the mean is calculated, and 
% afterwards the standard deviation (if requested).
% This function returns the mean value of the hits that are non-NaN's. If
% there are NaN hits in an event, it will not be considered in the calculation.
% Inputs:
% - hit_var         The hit variable
% - events          The event numbers
% Outputs:
% var_mean          The variable average.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

%% Average value (mean)
% The method is as follows:
% We define the number of approved hits in an event, serving as the
% normalization (nhits)
% We sum up all the approved values in the event.
% We divide the sum by the normalization to get the average value.

% Calculate the number of valid hits in each event:
C_i_valid = convert.event_sum(~isnan(hit_var), events, true);
% Calculate the event sum:
e_sum = convert.event_sum(hit_var, events, true);
% Divide to calculate the mean value:
var_mean = e_sum./C_i_valid;
% Replace Inf to NaN:
var_mean(isnan(var_mean)) = NaN;

%% Standard deviation
% The standard deviation is defined as:
%     /               2 \
%     | SUM((avg - x))  |
% sqrt| -------------   |
%     \    n - 1        /
% The method is as follows:
% We translate the event mean value to the hit mean value. 
% We calculate the squared difference (hit_var - mean).^2
% We sum it over the events, normalized by the number of hits in the event
% We square the event value.
if nargout > 1
	% User wants to know the standard deviation as well.
	% Translate event mean to hit mean:
	hit_mean	= convert.events_2_hits_det(var_mean, events, length(hit_var));
	% We calculate the squared difference (hit_var - mean).^2:
	hit_sq_diff	= (hit_var - hit_mean).^2;
	% We sum it over the events, normalized by the number of hits in the
	% event:
	event_sum_sq_diff = convert.event_sum(hit_sq_diff, events, true);
	var_std = sqrt(event_sum_sq_diff./(C_i_valid-1));
	var_std(C_i_valid == 0) = NaN;
end

