function [ field ] = probe_field(struct, fieldname)
%This function probes whether the field exists in the given struct, and if
%so, returns that field. If the field does not exist, 'false' is returned.
% Input:
% struct        the struct under investigation
% fieldname     string with the fieldname
% Output:
% field         The returned field content.

% First check whether the field exists:
if general.struct.issubfield(struct, fieldname)
    % The field exists, so we get the field:
	try
    field = general.struct.getsubfield(struct, fieldname);
	catch
	field = false;
	end
else
    field = false;
end

end

