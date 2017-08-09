function [ field_out ] = getsubfield(struct, fieldname)
%Getfield recursively from a nested field.
% Input:
% struct:       the name of the struct where the field is stored
% fieldname:    the name of the field, which can contain multiple 'subfields',
%               delimited by a dot ('.') .
switch iscell(fieldname)
	case false
			try
				field_out					= eval(['struct.' fieldname ';']);
			catch
				error 'Something''s wrong.';
			end
	case true
		for i = 1:length(fieldname)
			cur_fieldname = fieldname{i};
			try
				field_out.(cur_fieldname)	= eval(['struct.' cur_fieldname ';']);
			catch
				error 'Something''s wrong.';
			end
		end
end

