function found_value_idxs = find_idx_within_range(value_nominal, value_search_radius, input_array)
% Function to find the index (or indeces) in a given input array, around a
% certain centre (value_nominal) with widths value_search_radius.
% If multiple nominal values are given, the function iterates through them.

if length(value_nominal) > 1 && length(value_search_radius) == 1
    % make the array length of value_search_radius just as long as value_nominal, 
    % if only one is given:
    value_search_radius = ones(size(value_nominal))*value_search_radius;
end
found_value_idxs = NaN*ones(size(value_nominal));

for i = 1:length(value_nominal)
    % Find out which value in the input array falls within the search radius:
    found_value_bool = (input_array > (value_nominal(i)-value_search_radius(i)) & input_array < (value_nominal(i)+value_search_radius(i)));% & peak_centres < value_limits(2))
    if sum(found_value_bool) < 1
        % warning('peak not found within specified limits')
    elseif sum(found_value_bool) > 1
        % warning('multiple fragments found within specified limits. Closest value chosen')
        all_found_value_idxs_cur = find(found_value_bool); % We select the closest match:
        [distance, idx] = min(abs(input_array(all_found_value_idxs_cur)-value_nominal(i)));
        found_value_idxs(i) = all_found_value_idxs_cur(idx);
    else
        found_value_idxs(i) = find(found_value_bool);
    end
end
end