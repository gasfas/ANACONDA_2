function [ filter, filtered_data, full_filter ] = filter_range(data, min, max)
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
% Input:
% data		[n, m] The input matrix
% min		scalar, The minimum allowed value in the matrix elements
% max		scalar, The maximum allowed value in the matrix elements
% Output:
% filter	[n, 1] logical array, with indeces where the matrix rows are
%			all within the min and max specified
% filter	[n, m] logical matrix, with indeces where the matrix rows are
%			within the min and max specified
% full_filter [n,m] matrix where only the approved values are given, all
%			the rest is NaN.
% Example:
% data =    [0 1 3
%            1 5 2
%            6 1 9]
% 
% min =     [1 3 2];
% max =     [4 5 9];
% 
% filter =  general.matrix.filter_range(data, min, max)
%        =  [0
%            1
%            0]
% filtered_data = [0 0 1
%                  1 1 1
%                  0 0 1]
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

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
