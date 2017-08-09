function struct_out = rmsubfield(struct_in, fieldnames)
% Removes a subfield from a structure
%Setfield into a nested field.
% Input:
% struct:               the name of the struct where the field should be stored into
% fieldname:            the name of the field, which can contain multiple 'subfields',
%                       delimited by a dot ('.') .
% Output:
% struct:               The struct with the field filled in.
% struct_current = [];

% The to be removed field are the characters after the last dot:
dot_pos         = findstr(fieldnames, '.');
subfields       = fieldnames(1:dot_pos(end)-1);
last_field      = fieldnames(dot_pos(end)+1:end);

struct_out = struct_in;

try
eval(['dummy = rmfield(struct_in.' subfields ', ''' last_field ''');']);
eval(['struct_out.' subfields ' = dummy;']);
catch
 error 'Something''s wrong.';
end
