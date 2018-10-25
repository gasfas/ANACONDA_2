function struct_out = rmsubfield(struct_in, fieldnames)
% Removes a subfield from a structure
% Input:
% struct_in             the name of the struct where the field should be stored into
% fieldnames            the name of the field, which can contain multiple 'subfields',
%                       delimited by a dot ('.') .
% Output:
% struct_out               The struct with the field filled in.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% The to be removed field are the characters after the last dot:
dot_pos         = findstr(fieldnames, '.');
subfields       = fieldnames(1:dot_pos(end)-1);
last_field      = fieldnames(dot_pos(end)+1:end);

struct_out = struct_in;

try
eval(['dummy = rmfield(struct_in.' subfields ', ''' last_field ''');']);
eval(['struct_out.' subfields ' = dummy;']);
catch
 error(['Removing subfield(s) ' subfields ' did not succeed']);
end
