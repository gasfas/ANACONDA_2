function [A, BR] = fragment_pairs(events, label_signal,  label_list, C_nrs, C_filt, e_prefilt, min_BR)
%Make a histogram of the label combinations observed in single events.
% Inputs: 
% events		[nof_events, 1] The hit indices of the detector of importance
% label_signal	[nof_hits, 1] The labels assigned to the hits.
% label_list	[nof_labels, 1], All labels that are taken into count.
% C_nrs			[n, 1] The coincidence numbers of interest.
% C_filt		(optional) struct of coincidence filters. Should contain
%				the fields 'Ci' with i the coincidence numbers.
% e_prefilt		[nof_events, 1] (optional) logical pre-filter of events.
% min_BR		(optional) scalar, the minimum number of hits a channel
%				must have to be approved.
% Outputs:
% A		[nof_comb, nof_labels], matrix containing the number of instances
% of a certain label in a fragment pair.
% BR	[nof_comb, 1], The branching ratio [nof counts] of the fragment pair defined in A.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

BR_Ci = zeros(size(C_nrs));

% If an event filter is given:
try f_e_c = e_prefilt;
catch f_e_c = true(size(events));
end

% Convert the label signal values to label numbers:
idx_signal = convert.label_2_label(label_signal, label_list, (1:length(label_list))', 0);
%(if we don't recognize the label, we label it '0')

%% Construct a label matrix: each row an event with all labels:
% Initialize:
e_label_signal = NaN*ones(size(events, 1), max(C_nrs));

i = 0;
for C_nr = C_nrs
		i = i+1;
		% Fetch the multiplicity filter (if it does not already exist):
		try 
			f_e = f_e_c & C_filt.(['C' num2str(C_nr)]);
		catch
			f_e = f_e_c & filter.events.multiplicity(events, C_nr, C_nr, size(label_signal, 1));
		end
		
		% Construct a matrix containing the label number of each C_nr event:
		idx_mat = repmat(events(f_e), 1, C_nr) + repmat(0:C_nr-1, length(events(f_e)), 1);
		
		% Fill this into the label signal matrix:
		e_label_signal(f_e, 1:C_nr) = idx_signal(idx_mat);
 
end

%% Count the label occurences in every row:
% Construct an empty array for each hit: 
hit_pair_type = zeros(size(events, 1), length(label_list));
% Fill in how many times a label has been recorded in the event:
for label_nr = 1:length(label_list)
	hit_pair_type(:, label_nr) = hit_pair_type(:, label_nr) + sum(e_label_signal == label_nr, 2);
end

%% Histogram the label pair occurences:
% The label pairs that occur in this dataset:
A	= unique(hit_pair_type, 'rows');
% remove the hit pair that has no recognized labels:
A(sum(A,2) == 0, :)		= [];
% Calculate the branching ratio of each label pair:
BR					= hist.H_1D_row(hit_pair_type, A);
% Sort them in decreasing Ci and BR order:
[Ci_BR_sort, idx]	= sortrows([sum(A,2) BR], [1, -2]);
BR = Ci_BR_sort(:,2);
A = A(idx, :);
% Filter out the branching ratio's with too few hits:
if exist('min_BR', 'var')
	log_minBR = BR >= min_BR;
	BR = BR(log_minBR);
	A = A(log_minBR,:);
end
end