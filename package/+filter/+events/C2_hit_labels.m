function [e_f, hit1, hit2, hit_sum] = C2_hit_labels( events, labels, labels_of_interest_hit1, labels_of_interest_hit2, labels_of_interest_sum)
%This function filters out the events that contain all specified hit labels of
%interest (coinc_label). 
% Input:
% events        the hit indeces of the relevant hits [nofevents, 1]
% labels        the labels of each hit [nofhits, 1]
% labels_of_interest the labels that have to be in the output
%               filtered events [n, 1]
% Output:
% e_f           event filter: logical array specifying which events fulfill the
%               requirement [nofevents, labels_in_event, labels_in_event]
%               event_filter(:, 1, 2) filters out the events that contain
%               the events with multiplicity two and labels_in_event(1) and
%               labels_in_event(2).

mult = 2; %The multiplicity (number of hits in event) (smaller or
%         equal to length(labels_in_event))
nof_l_of_int = length(labels_of_interest_hit1);
nof_hits = length(labels);

%% multiplicity filter
% find the events that have the right multiplicity:
e_f_m = filter.events.multiplicity(events, mult, mult, nof_hits);

%% label filter
% find the hits that contain the requested labels:
hit_1   = labels(events(e_f_m)); % the label of the first hit of the event
hit_2   = labels(events(e_f_m)+1); % the label of the second hit of the event
hit_sum = hit_1 + hit_2; % the sum of labels.

% Prepare the arrays:
hits_correct_label1     = true(size(hit_1));
hits_correct_label2     = true(size(hit_2));
hits_correct_sum        = true(size(hit_sum));
 
% Check the conditions and test them:
if exist('labels_of_interest_hit1')
    if ~isempty(labels_of_interest_hit1)
        hits_correct_label1 = filter.hits.labeled_hits(hit_1, labels_of_interest_hit1);
    end
end
if exist('labels_of_interest_hit2')
    if ~isempty(labels_of_interest_hit2)
        hits_correct_label2 = filter.hits.labeled_hits(hit_2, labels_of_interest_hit2);
    end      
end
if exist('labels_of_interest_sum')
    if ~isempty(labels_of_interest_sum)
        hits_correct_sum = filter.hits.labeled_hits(hit_sum, labels_of_interest_sum);
    end  
end

% If all hits in the event have an approved label, the event is label-approved:
e_f_l = e_f_m;
e_f_l(e_f_m) = hits_correct_label1 & hits_correct_label2 & hits_correct_sum;

%% combine multiplicity and label:
% Only approve the events that are approved by the multiplicity filter and
% label filter:
e_f = e_f_m & e_f_l;
end
