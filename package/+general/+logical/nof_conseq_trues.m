function [nof] = nof_conseq_trues(logic_array)
% This function calculates the number of consequtive 'trues' after one
% another. The number is reset to zero for every 'false' value.
% input:
% logic_array	(n, 1) The logical array that is under study
% Output:
% nof			(n, 1) the number of consequtive trues in logic_array
subtract_array = zeros(size(logic_array));

nof_v1 = cumsum(logic_array);

% find the places where the first trues are:
first_trues = [diff([false; logic_array]) == 1];
% fill it into a 'subtract array':
subtract_array(first_trues) = nof_v1(first_trues);
% downfill this array:
subtract_array = general.matrix.upfill_array(subtract_array, 0, 1);
nof = nof_v1 - subtract_array + 1;
nof(~logic_array) = 0;
end