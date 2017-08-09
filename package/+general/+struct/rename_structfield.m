function [ a ] = rename_structfield(a, old_fieldname, new_fieldname)
% Convenience function to rename a struct field.

if ~iscell(old_fieldname)
	old_fieldname = {old_fieldname};
end

for i = 1:length(old_fieldname)
[a.(new_fieldname{i})] = a.(old_fieldname{i});
a = rmfield(a,old_fieldname{i});
end

