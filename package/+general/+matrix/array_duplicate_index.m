function [idx_sorted] = array_duplicate_index(array_in)
% Generate matrix by dividing all elements or array with its own values:
B = array_in'./array_in;
% Take out those index values of the lower diagonal that are equal to one:
B = B-diag(diag(B));
[idx_unsorted, ~]    = find(B==1);
% Sort the indeces:
idx_sorted      = sort(idx_unsorted);
end