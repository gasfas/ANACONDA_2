function [f, exp_data] = conditions_2_filter( exp_data, conditions )
% [event_filter] = conditions_2_filter(exp_data, conditions)
% This general event filtering function returns an event filter that follows
% all user-specified conditions.
%	Example:
% conditions is a struct with the fields with their condition names:
% conditions.labeled_hits
% This field contains information on this condition:
% conditions.labeled_hits.type			type of condition. can be
%										'discrete' or 'continuous'
% conditions.labeled_hits.data_pointer	which data the condition should apply to
%										For example: 'h.det1.m2q_l' to
%										apply to the mass-to-charge labels
% conditions.labeled_hits.value			The value the conditions apply to.
%										If conditions.labeled_hits.type is
%										'discrete', the data should exactly
%										equal this value. 
%										If conditions.labeled_hits.type is
%										'continuous', two values should be
%										given, interpreted as min and max.
% conditions.labeled_hits.translate_condition Only relevant for hit
%										conditions: the constructed hit filter
%										will be translated to an event
%										filter, and if all hits in an event
%										must be approved, 'AND' must be
%										given for this field. If only one of all hits
%										should be approved for the event to
%										be approved, 'OR' should be given.
% conditions.labeled_hits.invert_filter (optional) logical: if 'true', the
%										event filter will be inverted 
%										(true becomes false, false becomes true)

% Check first whether the filter from this condition is already calculated:
if isempty(conditions)
	conditions = struct();
end
cond_sim = false;
if general.struct.issubfield(exp_data, 'e.filt.cond_struct') && general.struct.issubfield(exp_data, 'e.filt.from_recent_cond')
	cond_sim = general.struct.structcmp(conditions,general.struct.probe_field(exp_data, 'e.filt.cond_struct'));
end
if cond_sim % If the conditions are similar, we can just copy it from the experiment file:
	f = exp_data.e.filt.from_recent_cond;
else
	% Save the conditions to the experimental data, for later use:
	exp_data.e.filt.cond_struct			= conditions;
	[f, exp_data] = C2F(exp_data, conditions);
end
end

%% Local subfunctions:
function [f, exp_data] = C2F(exp_data, conditions)
	events          = exp_data.e.raw;
	f				= true(size(events,1),1);
	% Do the conditions have any fields?
	if isempty(conditions)
		% No conditions defined, Done
	else
		% There is a (meta-)condition defined:
		% Find the metaconditions, if defined:
		[idx_substr cond_fn] = general.struct.issubstruct(conditions);
	%% Metaconditions
		if any(idx_substr) % there is at least one meta(sub)-condition defined:
			metaconds = cond_fn(idx_substr);
			% Deal with the operator between subconditions:
			if any(strcmpi('operator', cond_fn)) % We allow the name 'operator' as well:
				conditions.operators = conditions.operator;
				conditions	= rmfield(conditions, 'operator');
			end
			% Default value if the operators are not defined: 
			if ~any(strcmpi('operators', fieldnames(conditions)))
				conditions.operators = repmat({'AND'}, 1, length(metaconds)-1);
			elseif length(general.struct.probe_field(conditions, 'operators')) < (length(metaconds)-1)
				% If there are not enough operators defined, we fill it up with the first given operator to
				% the required size:
				operators_ori			= conditions.operators;
				conditions.operators	= repmat(operators_ori(1), 1, length(metaconds)-1);
			end
			for metacond_nr = 1:length(metaconds) % loop over all subconditions:
				metacond_cur = metaconds{metacond_nr};
				f_cur = C2F(exp_data, conditions.(metacond_cur));
				switch metacond_nr
					case 1; operator = 'AND';
					otherwise operator = conditions.operators{metacond_nr-1};
				end
				% Combine the current filter with the final filter:
				f = combine(f, f_cur, operator);
			end
		end
	%% Conditions
		if isfield(conditions, 'data_pointer')% Now we treat the conditions (not the subconditions)
			conditions.data_pointer;
			f_cur = condition_2_filter(exp_data, conditions);
			% Now combine the filters:
			f					= combine(f, f_cur, 'AND');
		end
	end

	% Save the filter in the experimental data:
	exp_data.e.filt.from_recent_cond	= f;
end


function f = condition_2_filter(exp_data, condition)
% This function calculates the filter from a single condition.
% Read the data from the pointer:
[condition_data, data_form] = IO.read_data_pointer(condition.data_pointer, exp_data);
% And read the value of the actual condition:
condition_value = condition.value;
% In case the value is depending on another variable, we send it out:
switch general.struct.probe_field(condition, 'value_type')
	case 'var' % variable value type
		condition.(condition_fn) =  condition;
		f = C2F(exp_data, condition);
	otherwise
	% Check whether the conditions are discrete or continuous:
	switch condition.type
		case 'discrete' % A discrete condition. Write the filter:
			f = filter.hits.labeled_hits(condition_data, condition_value);
		case 'continuous'
			f = filter.hits.range(condition_data, condition_value(1), condition_value(2));
	end
	% We have calculated the filter from the given conditions.
	% Check whether the conditions are event or hit properties:
	switch data_form
		case 'hits'% Hits. We have to translate the hit filter to an event filter
			if ~isfield(condition, 'translate_condition')
				disp(['Warning: no translate condition given at data pointer ' condition.data_pointer ' ''OR'' is used'])
				condition.translate_condition = 'OR';
			end
			translate_condition = condition.translate_condition;
			nof_hits            = size(f,1);
			detnr               = IO.det_nr_from_fieldname(condition.data_pointer);
			events				= exp_data.e.raw;
			f					= filter.hits_2_events(f, events(:,detnr), nof_hits, translate_condition);
	end
	% Lastly, check whether the filter should be inverted:
	if general.struct.probe_field(condition, 'invert_filter')
		f = ~f;
	end
end
end

function f = combine(f, f_cur, operator)
% This sub-function merges the current filter (f_cur) with the main one (f)
% by applying the operation between the two filters.
switch operator
		case 'OR'
			f = or(f,f_cur);
		case 'AND'
			f = and(f, f_cur);
		case 'NAND'
			f = ~and(f, f_cur);
end
end