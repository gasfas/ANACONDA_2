function [ struct ] = modify_struct (struct, mutation)
%This function modifies a struct, by overwriting the overlapping
%fieldnames from the struct 'mutation'. Works recursively
% Inputs:
% struct	The struct that might be partly overwritten.
% mutation	The struct that will overwrite the overlapping fieldnames of
%			struct
% Outputs:
% struct	The struct that might be partly overwritten.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% read the fieldnames:
names_ori = fieldnames(struct);
names_mut = fieldnames(mutation);

% Check at each name if there is a corresponding name in the other struct:
for i = 1:length(names_ori)
    name = names_ori{i};
    if any(strncmp(name, names_mut, length(name)))
        if isstruct(mutation.(name)) % overlapping fieldnames:
            % This means the mutation has a subfield here:
            structfield = general.struct.modify_struct(struct.(name), mutation.(name));
            struct.(name) = structfield;
		else % no overlapping fieldnames:
            struct.(name) = mutation.(name);
        end
    end
end

