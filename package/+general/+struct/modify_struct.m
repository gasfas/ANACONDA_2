function [ struct ] = modify_struct (struct, mutation)
%This function modifies a struct, by overwriting the overlapping
%fieldnames from the struct 'mutation'.

names_ori = fieldnames(struct);
names_mut = fieldnames(mutation);
for i = 1:length(names_ori)
    name = names_ori{i};
    if any(strncmp(name, names_mut, length(name)))
        if isstruct(mutation.(name))
            % This means the mutation has a subfield here:
            structfield = general.struct.modify_struct(struct.(name), mutation.(name));
            struct.(name) = structfield;
        else
            struct.(name) = mutation.(name);
        end
    end
end

