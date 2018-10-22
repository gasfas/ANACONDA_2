function [ label_hist ] = label_2_hist(labeled_s, labels)
% makes a histogram for every user-specified expected hit label.
% Input:
% labeled_s:        The labeled signal, [n, 1]
% labels:           The labels which should be included in the histogram.
%                   [m,1]
% Output:
% label_hist:       A histogram of the labels (in terms of number of
%                   counts), [m, 1]
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% we count the number of appearances for every label:
label_hist =               general.matrix.countmember(labels, labeled_s);
end

