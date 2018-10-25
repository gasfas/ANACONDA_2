function [ X_filled ] = downfill_array(X_unfilled, fill_value, DIM)
% This function downfills an array that contains 'fill_value', by values
% that are found one index down (either one row or column, depending on
% 'DIM')
% Input: 
% X_unfilled:   The array to be filled [n, m]
% fill_value:   The value in X_unfilled that needs to be replaced by the
%               values found one index down (index nr one higher)
% DIM:          The dimension along the filling should be done. 1 means:
% replace the fill_value by the value down the row.
% Output:
% X_filled:     The filled matrix.
%
% Example:
% X_unfilled =  NaN     4     0     0     1   NaN
%                 5     6     3   NaN   NaN     2
%               NaN   NaN     1     1   NaN     1
% fill_value =  3
% DIM =         2
% 
% Results in:
% X_filled =    downfill_array(X_unfilled, fill_value, DIM)
% X_filled =    1      4      4     4     1   NaN
%               5      6      6   NaN   NaN     2
%               1    NaN    NaN    14   NaN    16
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

X_filled = general.matrix.upfill_array(flip(X_unfilled,1), fill_value, DIM);
X_filled = flip(X_filled,1);
end

