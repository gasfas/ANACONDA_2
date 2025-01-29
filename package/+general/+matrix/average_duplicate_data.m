function [X_unique, Y_unique] =  average_duplicate_data(X, Y, nof_decimals)
% Average of data arrays that are duplicate.
% Inputs:
% X     array of X-data input, containing the duplicates
% Y     array of associated intensity data
% nof_decimals  precision, number of decimals, to round the X-data with to
% define a duplicate.
% 

[X_unique, ~, idx_dupl]   = unique(round(X,nof_decimals)) ;
Y_unique                  = accumarray(idx_dupl, Y, [], @mean )' ;
end