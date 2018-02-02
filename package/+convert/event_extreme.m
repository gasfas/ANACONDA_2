function [ var_extr1, var_extr2 ] = event_extreme(hit_var, events, type, direction)
%This function fetches the extreme value of a variable of an event.
% Inputs:
% - hit_var         The hit variable
% - events          The event numbers
% - type			(char) The type of extrem: 'max' or 'min' or 'min&max'
%					or 'sorted'
% - direction			(optional, only used in combination with 'sorted'); the
%					method to sort: 'ascend' or 'descend'
% Outputs:
% - var_extr1          The variable minimum, maximum, or sorted hits.
% - var_extr1          The variable minimum or maximum

%% Extreme value (min/max)
% The method is as follows:
% We transform the hit matrix into one row-one event.
% we calculate the maximum/minimum from that row

% First remove the NaN events:
e_NaN_f             = isnan(events);
% removing the NaNs from the events:
events_noNaN = events(~e_NaN_f);

nof_hits	= size(hit_var, 1);
% fetch the mulitplicity of the events:
e_mult		= convert.event_multiplicity(events_noNaN, nof_hits);

% In order to re-shuffle the hits into the right rows, we label each hit
% with an event number:
[h_event_nrs] = convert.event_2_hit_values((1:size(events_noNaN,1))', events_noNaN, nof_hits);
fill_value = NaN;

% Start with a NaN-matrix:
h_hit_nr_in_event = fill_value*ones(size(hit_var));
% Mark the first hit in the event:
h_hit_nr_in_event(events_noNaN, :) = ones(size(events_noNaN,1),size(h_hit_nr_in_event,2));
% Then upfill, so that each event has its own numbering:
h_hit_nr_in_event = general.matrix.upfill_array(h_hit_nr_in_event, 'NaN', 1, 1);
% We create a new matrix where the new values will be placed into:
hit_var_event_rows = NaN*ones(size(events_noNaN, 1), max(e_mult));
% 
indices = sub2ind(size(hit_var_event_rows), repmat(h_event_nrs, 1,size(h_hit_nr_in_event,2)) , h_hit_nr_in_event);
% fill in the hit values into the new matrix:
hit_var_event_rows(indices) = hit_var;

% Find the minimum/maximum value of the row:
switch type 
	case 'min'
		var_extr1_noNaN = min(hit_var_event_rows, [], 2);
	case 'max'
		var_extr1_noNaN = max(hit_var_event_rows, [], 2);
	case 'min&max'
		var_extr1_noNaN = min(hit_var_event_rows, [], 2);
		var_extr2_noNaN = max(hit_var_event_rows, [], 2);
	case 'sorted'
		if strcmp(direction, 'descend')
			hit_var_event_rows(isnan(hit_var_event_rows)) = -Inf;
		end
		tmp = sort(hit_var_event_rows, 2, direction);
		var_extr1 = tmp(indices);
end

% Fill back in the NaN events:
if any(strcmp(type, {'min', 'max', 'min&max'}))
	var_extr1			= NaN*size(events);
	var_extr1(events_noNaN)	= var_extr1_noNaN;
	if exist('var_extr2_noNaN', 'var')
	var_extr2			= NaN*size(events);
	var_extr1(events_noNaN)	= var_extr2_noNaN;
	end
end
end