function [ filter, filtered_data, full_filter ] = range(data, min, max)
% This function filters out the elements of an array, 
% based on their values. The maximum and minimum are supplied 
% by 'min' and 'max'
% if the unfiltered matrix is n*m in size, a logical array (n*m) will be
% returned with the indeces true where the element values are between min
% and max.
% if the unfiltered matrix is n*m in size, a column of values meeting the
% condition is returned under the name filtered_data
% if size(min) and size(max) == [1, n], the minima and maxima are applied
% column-wise, and the filter only returns true when the entire row is approved. 
% Example:
% data =    [0 1 3
%            1 5 2
%            6 1 9]
% 
% min =     [1 3 2];
% max =     [4 5 9];
% 
% filter =  filter.hits.range(data, min, max)
%        =  [0
%            1
%            0]
% filtered_data = [0 0 1
%                  1 1 1
%                  0 0 1]

if size(min,2) == size(data,2)
    % We will execute the comparing column-wise:
    min = repmat(min, size(data,1), 1);
    max = repmat(max, size(data,1), 1);
end
% Only approve when all elements in the row are approved:
full_filter     = data >= min & data <= max;
filter          = (sum(full_filter, 2) == size(data,2));
filtered_data   = NaN*ones(size(data));
filtered_data(full_filter)   = data(full_filter);

end
