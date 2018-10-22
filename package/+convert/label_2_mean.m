function [ label_mean ] = label_2_mean(labeled_s, signal, labels)
% Calculate the mean value of a signal, separate for each label.
% Input:
% labeled_s:        The labeled signal, [n, 1]
% signal            The signal that needs to be averaged based on labels, [n, 1]
% labels:           The labels which should be included in the histogram.
%                   [m,1]
% Output:
% label_mean:       The mean value of the specified 'labels' (in terms of number of
%                   counts), [m, 1]
%  SEE ALSO: convert.label_2_hist
% Note: repmat commands require lots of CPU time, therefore the signal and
% labeled_s are shrunk to the smallest size possible before manipulation.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

%% filtering the hits to the bare necessary:
% Giving the index of The participating hits (the ones that are labeled):
part_label_filt = filter.hits.labeled_hits(labeled_s, labels);
% the participating label hits:
part_labeled_s = labeled_s(part_label_filt);
% the participating hits:
part_signal = signal(part_label_filt);

%% averaging as a function of label:

% We construct a matrix that indicates which hits belong to which label.
labeled_s_mat           = repmat(part_labeled_s, [1,length(labels)]) - repmat(labels', [length(part_labeled_s), 1]);
% labeled_s_mat2           = part_labeled_s(:, ones(1,size(labels, 1))) - labels(:, ones(size(part_labeled_s, 1), 1))';
% we fetch the linear indices that should be fetched from the signal:
lin_ind                 = find(labeled_s_mat == 0);

% We also construct a matrix from the signal, each for a separate label:
rep_sign_mat            = repmat(part_signal, [1, length(labels)]);
% start with an empty NaN matrix:
signal_mat              = NaN*zeros(size(part_signal, 1), length(labels));
% and fill it up:
signal_mat(lin_ind)     = rep_sign_mat(lin_ind);

% Then we find the average value of every column:
label_mean = nanmean(signal_mat, 1)';
end

