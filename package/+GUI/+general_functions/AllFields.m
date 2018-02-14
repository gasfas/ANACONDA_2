%% Allfields comparer function
% Compares fieldnames of the substructures, and returns all fieldnames.
% Input: Struct with substructures to be compared.
% Output: Common fields found.
function all_fields = AllFields(struct_in)
exps = fieldnames(struct_in);
all_fields = struct_in.([char(exps(1))]);
% Start comparison.
for lx = 2:length(exps)
    all_exp_fields = struct_in.([char(exps(lx))]);
    for ly = 1:length(all_exp_fields)
        name_of_field = char(all_exp_fields(ly));
        % check if all_fields does not have the field:
        if sum(contains(all_fields, name_of_field)) == 0
            all_fields(length(all_fields)+1) = cellstr([char(exps(lx)), '.', name_of_field]);
        end
    end
end
end