function [ S ] = fetch_struct_element(S, n)
% This function enables the user to take the n-th elements from all fields
% in the struct S (works recursively).
% Inputs:
% S		The struct with the to-be-cut fields
% n		the index numbers, which need to be fetched
% Outputs:
% S		The output struct with the requested field elements
% So far, only works for one-dimensional arrays
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

fn = fieldnames(S);

for i = 1:length(fn)
	cur_fn = fn{i};
	% Fetch the field value:
	field_n = S.(cur_fn);
	if isstruct(field_n) % If that field is a struct in itself:
		cut_field = general.struct.fetch_struct_element(field_n, n);
	else % if it is indeed an array:
		try
			cut_field = field_n(n);
		catch
			cut_field = field_n;
		end
	end
	S.(cur_fn) = cut_field;
end

