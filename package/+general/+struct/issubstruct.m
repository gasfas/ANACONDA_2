function [logical, fn] = issubstruct(struct)
% This function checks whether a given struct has substructs as fields.
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

