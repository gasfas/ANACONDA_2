function [ X_filled ] = upfill_array(X_unfilled, fill_value, DIM, enumerate)
% This function upfills an array that contains 'fill_value', by values
% that are found one index up (either one row or column, depending on
% 'DIM')
% Input: 
% X_unfilled:   The array to be filled [n, m]
% fill_value:   The value in X_unfilled that needs to be replaced by the
%               values found one index up (index nr one lower)
% DIM:          The dimension along which the filling should be done. 1 means:
% replace the fill_value by the value up the row.
% Output:
% X_filled:     The filled matrix.
%
% Example:
% X_unfilled =  NaN     4     0     0     1   NaN
%                 5     6     3   NaN   NaN     2
%               NaN   NaN     1     3   NaN     1
% fill_value =  3
% DIM =         2
% 
% Results in:
% X_filled = upfill_array(X_unfilled, fill_value, DIM)
% X_filled =  NaN      4      0     0     1   NaN
%               5      6      6   NaN   NaN     2
%             NaN    NaN      1     1   NaN     1

if ischar(fill_value) && strcmpi(fill_value, 'NaN')
    % the routine cannot handle NaN's, so we give it another (unique) value:
    fill_value = max(X_unfilled(:))+1;
    X_unfilled(isnan(X_unfilled)) = fill_value;
elseif any(isnan(X_unfilled(:)))
    % If there are any NaN's in the array, but they are not the fill_value,
    % we also need to replace them with a unique value:
    replacement_value = max(X_unfilled(:))+2;
    X_unfilled(isnan(X_unfilled)) = replacement_value;
end

% Check the dimension along which the filling is desired:
if      DIM == 2
    % nothing to do
elseif  DIM == 1
    X_unfilled = X_unfilled';
end

X_filled = (X_unfilled-fill_value)'; %'
% Find the indices that contain the not-to-be-replaced values (bool tf):
tf = (X_filled ~= 0);
% The First row will definitely not be replaced (no value to downfill with):
tf(1,:) = true;
% go to index format:
idx = find(tf);
%Y(idx) is a list of values that should not be replaced.
X_filled(idx(2:end)) = diff(X_filled(idx));
X_filled = reshape(cumsum(X_filled(:)),fliplr(size(X_unfilled)))';

X_filled = X_filled + fill_value;

% If the user wants to add/subtract 'enumerate' each row/column:
if exist('enumerate', 'var')
	[nof] = general.logical.nof_conseq_trues(~tf);
	X_filled = X_filled + nof';
% 	j = 0;
% 	while any(~tf)
% 		j = j+1;
% 		first_upfill = [false; diff(~tf) == 1];
% 		X_filled(first_upfill) = X_filled(first_upfill) + j*enumerate;
% 		tf(first_upfill) = true;
% 	end
end


if exist('replacement_value', 'var')
    % Changing back to the NaN's:
    X_filled(X_filled == replacement_value) = NaN;
end

if DIM == 1
    X_filled = X_filled';
end

end

