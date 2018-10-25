function [LIA, LOCB] = ismemberNaN(A, B)
%This function is a slight adaptation to ismember.
%It also acknowledges NaN values as members, and displays them in the
%output logical array.
% Inputs:
% A		array, the elements searched for
% B		array, the array under study
% Outputs:
% LIA	logical vector, containing true where the rows of A are also rows
% of B and false otherwise
% LOCB	logical vector, containing the lowest absolute index in B for each 
% element in A which is a member of B and 0 if there is no such index.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

[LIA, LOCB]     = ismember(A,B);

% Find out if the NaNs are requested, and where the first one is:
NaN_B_loc       = find(isnan(B),1);
% Find the NaN in A
isNaN_A         = (isnan(A) & any(isnan(B)));
% add the NaN's to the array;
LIA(isNaN_A)    = true;
% add them in the locations:
LOCB(isNaN_A)   = NaN_B_loc;

end

