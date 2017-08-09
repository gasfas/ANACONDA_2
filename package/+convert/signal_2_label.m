function [ labeled_s, l_hit_location ] = signal_2_label(unlabeled_s, labels, search_radii)
% Groups the unlabeled signal into groups corresponding to label
% values, using the condition that they are inbetween certain 'search radius' values.
% Input:
% unlabeled_s:   The unlabeled signal [n,1]
% labels:        The labels the signal is expected to have.
% search_radius: The search radius determining how far the hits can be 
% removed from the label to still be assigned the right label. 
% Output:
% labeled_s:     The labeled signal. NaN's where no label was found. [n,1]
% l_hit_loc:     (logical) The location of the labeled locations. [n,1]

% We sort all the mass2charge hits onto its nearest recognized value:
if length(unique(labels)) == 1
    % Only one label, so all will be given the same initial label:
    labeled_s = unique(labels)*ones(size(unlabeled_s));
    search_radius_s = search_radii;
else
    % Filter out the duplicate labels (if present)
    [labels_unique, idx_uni]                = unique(labels);
    % Then sort them in size:
    [sorted_labels, idx_sort]               = sort(labels_unique);
    
    labeled_s                           = interp1(sorted_labels, sorted_labels, unlabeled_s, 'nearest', 'extrap');
    if all(size(search_radii) == size(labels))
        unique_search_radii             = search_radii(idx_uni);
        sorted_search_radii             = unique_search_radii(idx_sort);
        search_radius_s                 = interp1(sorted_labels, sorted_search_radii, labeled_s, 'nearest', 'extrap');
    else
        search_radius_s                 = search_radii * ones(size(labeled_s));
    end
end

% and then see which hits do not belong to the mass2charge value they have
% just been assigned to, because they are too far off (outside search radius):

unlabeled_hit_location              = (abs(unlabeled_s - labeled_s) > search_radius_s);
l_hit_location                      = ~unlabeled_hit_location;
% If they are outside search radius, those hits are not recognized, so undefined:
labeled_s(unlabeled_hit_location)   = NaN;

if ~any(l_hit_location)
    warning('no hit was identified by the given labels')
end
end

