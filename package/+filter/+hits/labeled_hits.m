function [ filter, locs ] = labeled_hits(labeled_s, labels)
% Filter so that only the labeled hits with the user-specified labels go
% through.
% Inputs: 
% labeled_s:        The labeled signal, [n, 1]
% labels:           The labels which should go through the filter 
% labels
% Output:
% filter            The produced filter.
% locs:             The locations of the labels in labeled_s;
% SEE ALSO: convert.signal_2_label, convert.label_2_hist
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

[filter, locs] =    general.matrix.ismemberNaN(labeled_s, labels);

end

