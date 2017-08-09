function [events] = zero_mult_to_NaN (events, nof_hits)
% This function makes sure that events with zero hits on a detector
% really does get the index 'NaN'
% Input:
% events:       The events under investigation [nof_events, nof_det]
% nof_hits:     The number of hits for every detector. [1, nof_det]
% Output:
% events:       the events with NaN's filled in where needed.

% We will perform a diff() operation, so we append an extra line, 
% giving the maximum index in events possible:
diff_array = [events; nof_hits];

is_nocount                  = [(diff(diff_array,1,1) == 0)];
events(is_nocount)          = NaN;
end

