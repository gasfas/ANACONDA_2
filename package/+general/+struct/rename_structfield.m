function [ a ] = rename_structfield(a, old_fieldname, new_fieldname)
% Convenience function to rename a struct field.
% Inputs:
% a				The input struct
% old_fieldname	char, the name of one of the fields in a that needs to be
%				renamed
% new_fieldname	char, the name of that field to rename it to.
% Outputs:
% a				The output struct, with a renamed fieldname.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if ~iscell(old_fieldname)
	old_fieldname = {old_fieldname};
end

for i = 1:length(old_fieldname)
[a.(new_fieldname{i})] = a.(old_fieldname{i});
a = rmfield(a,old_fieldname{i});
end

