function [ exists ] = issubfield(struct, fieldname)
% Check nested field existence.
% Input:
% struct:       the name of the struct where the field is stored
% fieldname:    the name of the field, which can contain multiple 'subfields',
%               delimited by a dot ('.') .

idx_namesep = strfind(fieldname, '.');
    
if isempty(idx_namesep)
    exists = eval(['isfield(struct, ''' fieldname ''') ;']);
else 
    firstfield   = fieldname(1:idx_namesep(end)-1);
    exists = general.struct.issubfield(struct, firstfield);
    if exists
        res_fields = fieldname(idx_namesep(end)+1:end);
        exists = general.struct.issubfield(general.struct.getsubfield(struct, firstfield), res_fields);
    end
end


