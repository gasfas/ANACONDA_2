function [f_e] = var_conditions_2_filter( exp_data, condition )
% [event_filter] = var_conditions_2_filter(exp_data, condition)
% This event filtering function returns an event filter that follows a 
% variable-dependent condition.

events          = exp_data.e.raw;
f_e             = false(size(events,1),1);
condition_name  = fieldnames(condition);
condition_name  = condition_name{:};

condition.(condition_name) = rmfield(condition.(condition_name), 'value_type');
            
switch condition.(condition_name).var.type
    case 'discrete'
        % Fetch variable information:
        variable_data        = eval(['exp_data.' condition.(condition_name).var.data_pointer]);
        variable_values      = condition.(condition_name).var.value;
        % Fetch condition information:
        condition_data       = eval(['exp_data.' condition.(condition_name).data_pointer]);
        condition_values      = condition.(condition_name).value;
        % We filter each variable value at a time:
        for var_nr = 1:length(variable_values)
            % We create a first event filter, which filters out only the
            % specified value of the variable:
            f_var = filter.hits.labeled_hits(variable_data, variable_values(var_nr));
            % This filter should fit with the var-dependent condition:
            condition.(condition_name).value = condition_values(:,var_nr);
            f_cond = macro.filter.conditions_2_filter(exp_data, condition);
            % These two filter should both approve the event;
            f_e = f_e | (f_var & f_cond);
        end
    case 'continuous'
        error('TODO')
end

end