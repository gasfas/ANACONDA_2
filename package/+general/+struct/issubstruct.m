function [logical, fn] = issubstruct(struct)
% This function checks whether a given struct has substructs as fields.
% Inputs:
% struct	The structure under investigation
% Outputs:
% logical	The logical array with length the number of fields struct has.
%			Each element says if that field has a substructure.
% fn		Cell with fieldnames of the struct.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

fn = fieldnames(struct); i = 0;
if ~isempty(fn)
	for i = 1:length(fn)
		fn_cur = fn{i};
		logical(i) = isstruct(struct.(fn_cur));
	end
else
	logical = false;
	fn		= {};
end
end

