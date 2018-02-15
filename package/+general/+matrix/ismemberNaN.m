function [LIA, LOCB] = ismemberNaN(A, B)
% Input
% A, B  two arrays of comparable size [n,1],[m,1] respectively
% Output: 
% LIA [n,1]  array containing 1 at overleps between A and B and 0 at missing
%            overlaps, including 
%This function is a slight adaptation to ismember.
%It also acknowledges NaN values as members, and displays them in the
%output logical array.

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

