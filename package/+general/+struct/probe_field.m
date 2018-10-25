function [ field ] = probe_field(struct, fieldname)
%This function probes whether the field exists in the given struct, and if
%so, returns that field. If the field does not exist, 'false' is returned.
% Works recursively
% Input:
% struct        the struct under investigation
% fieldname     string with the fieldname
% Output:
% field         The returned field content.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% First check whether the field exists:
if general.struct.issubfield(struct, fieldname)
    % The field exists, so we fetch the field:
	try
    field = general.struct.getsubfield(struct, fieldname);
	catch
	field = false;
	end
else
    field = false;
end

end

