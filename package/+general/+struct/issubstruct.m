function [logical, fn] = issubstruct(struct)
% This function checks whether a given struct has substructs as fields.
fn = fieldnames(struct); i = 0;
for i = 1:length(fn)
	fn_cur = fn{i};
	logical(i) = isstruct(struct.(fn_cur));
end
end
