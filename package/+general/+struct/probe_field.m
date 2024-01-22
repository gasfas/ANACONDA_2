function [ field ] = probe_field(struct, fieldname, returntype)
%This function probes whether the field exists in the given struct, and if
%so, returns that field. If the field does not exist, 'false' is returned.
% Works recursively
% Input:
% struct        the struct under investigation
% returntype    (optional) The type of variable to return. If 'fieldnames'
%               is chosen, a cell of fieldnames is returned. 'default' will 
%               return the fieldnames if found, and '0' if none are found.
% fieldname     string with the fieldname
% Output:
% field         The returned field content.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if ~exist('returntype', 'var')
    returntype = 'default';
end

% First check whether the field exists:
if general.struct.issubfield(struct, fieldname)
    % The field exists, so we fetch the field:
	try
    field = general.struct.getsubfield(struct, fieldname);
    catch
        switch returntype
            case 'fieldnames'
                field = {};
            otherwise
                field = false;
        end
	end
else
    switch returntype
    case 'fieldnames'
        field = {};
    otherwise
        field = false;
end

end

