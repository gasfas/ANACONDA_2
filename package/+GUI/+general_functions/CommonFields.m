%% CommonFields comparer function
% Compares fieldnames of the substructures, and returns fieldnames 
% common between the substructures.
% Input: Struct with substructures to be compared.
% Output: Common fields found.
function common_fields_out = CommonFields(struct_in)
exps = fieldnames(struct_in);
common_fields_out = '';
l1 = 1;
fields1 = struct_in.([char(exps(l1))]);
for l2 = 2:length(exps)
    fields2 = struct_in.([char(exps(l2))]);
    % Find the common fields:
    memberindex.([char(exps(l2))]) = ismember(fields1, fields2);
end
% combine memberindices:
if length(fieldnames(memberindex)) == 1
    memberindices = memberindex.(char(fieldnames(memberindex(1))));
else
    memberindices = horzcat(memberindex.([char(exps(2))]), memberindex.([char(exps(3))]));
end
if length(exps) > 3
    for l3 = 3:length(exps)
        memberindices = horzcat(memberindices, memberindex.([char(exps(l3))]));
    end
end
[memb_dim_y, memb_dim_x] = size(memberindices);
for l4 = 1:memb_dim_y
    l4_val = 0;
    for l5 = 1:memb_dim_x
        l4_val = l4_val + memberindices(l4, l5);
    end
    if l4_val == memb_dim_x
        if iscell(common_fields_out)
            common_fields_out(length(common_fields_out)+1) = fields1(l4);
        else
            common_fields_out = cellstr('');
            common_fields_out(1) = fields1(l4);
        end
    end
end
end