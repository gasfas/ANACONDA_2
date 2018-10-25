function struct = setsubfield(struct, fieldnames, structvalue)
% function [ struct_out ] = setsubfield(struct_in, structname, structvalue)
%Setfield into a nested field.
% Input:
% struct:               the name of the struct where the field should be stored into
% fieldname:            the name of the field, which can contain multiple 'subfields',
%                       delimited by a dot ('.') .
% structvalue:          the value that should be filled into the structname place
% Output:
% struct:               The struct with the field filled in.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if iscell(fieldnames)
    nof_fields = length(fieldnames);
else
    nof_fields = 1;
end

if nof_fields == 1
    if iscell(fieldnames)
        fieldnames  = fieldnames{:};
        structvalue = structvalue{:};
    end
    try
     eval(['struct.' fieldnames ' = structvalue;']);
    catch
     error 'Something''s wrong.';
    end
else
    for i = 1:nof_fields
        struct = general.setsubfield(struct, fieldnames{i}, structvalue{i});
    end
end

    