function [nof] = nof_conseq_trues(logic_array)
% This function calculates the number of consequtive 'trues' after one
% another in a logical array. The number is reset to zero for every 'false' value.
% input:
% logic_array	(n, 1) The logical array that is under study
% Output:
% nof			(n, 1) the number of consequtive trues in logic_array
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% Initialize empty array:
subtract_array = zeros(size(logic_array));

% First version of the number of false/trues:
nof_v1 = cumsum(logic_array);

% find the places where the first trues are:
first_trues = [diff([false(1, size(logic_array,2)); logic_array], 1, 1) == 1];
% fill it into a 'subtract array':
subtract_array(first_trues) = nof_v1(first_trues);
% downfill this array:
subtract_array = general.matrix.upfill_array(subtract_array, 0, 1);
nof = nof_v1 - subtract_array + 1;
nof(~logic_array) = 0;
end