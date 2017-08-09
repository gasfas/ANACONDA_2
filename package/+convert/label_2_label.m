function [ labeled_s2, l_hit_location ] = label_2_label(labeled_s1, labels1, labels2, rest_label)
% Creates a new converted signal from an existing labeled signal, but with 
% a different label value.
% Input:
% labeled_s1:   The labeled signal 1 [n,1]
% labels1:      The labels in the signal that should be converted. [m, 1]
% labels2:      The corresponding new labels that those label values should
%               be converted to.
% rest_label	scalar, the label given to the unrecognized value.
% Output:
% labeled_s2:   The labeled signal 2. NaN's where no label was found. [n,1]
% l_hit_loc:     (logical) The location of the labeled locations. [n,1]

%Initialize the array:
labeled_s2              = rest_label*ones(size(labeled_s1, 1), size(labels2,2));
% Find the locations that are labeled in the input array:
[ filt, locs ]          = filter.hits.labeled_hits(labeled_s1, labels1);
% Fill in the labels:
labeled_s2(filt, :)        = labels2(locs(filt), :);

end


