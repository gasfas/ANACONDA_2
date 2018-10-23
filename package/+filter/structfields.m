function [filtered_struct] = structfields(struct_in, filter)
% This function generates a copy from a given struct, with the
% difference that a filter is applied to the new structfields. note that all the
% fields in the struct need to store a similar-sized matrices (the first
% dimension of the matrices), otherwise the field is copied without filtering. Works recursively.
% Input:
% struct_in     The input struct storing arrays of size [n, x]
% filter           [n,1] logical filter that specifies which elements should be transmitted (true), or not (false)
% Output:
% filtered_struct   The struct storing filtered arrays.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% Check the names of the event fields:
fields_r = general.struct.fieldnamesr(struct_in);
filtered_struct = struct;

for fieldnr = 1:length(fields_r)
    
    % filling in the new filtered event values:
    current_read_struct = struct_in;
    fieldname_fetch = fields_r{fieldnr};
    
    current_array = general.struct.getsubfield(struct_in, fieldname_fetch);
    
    % we check the size:
    switch size(current_array,1) 
        case size(filter,1)
            % we apply the filter:
            current_array_f = current_array(filter,:);
        otherwise
            % not the right size, copied but no filter applied:
            current_array_f = current_array;
    end
    
    fieldname_fetch;
    % we write into the subfield:
    filtered_struct = general.struct.setsubfield(filtered_struct, fieldname_fetch, current_array_f);
    general.struct.fieldnamesr(filtered_struct);

end


end

