function [ multiplicity ] = event_multiplicity(events, nof_hits)
% Returns the multiplicity of every event.
% Input:
% events:       all startindex of events [nof_events, 1]
% nof_hits:     The number of hits on the corresponding detectors
% Output:
% multiplicity: The multiplicity of every event [nof_events, 1]

multiplicity =                  int32(zeros(size(events)));

% Now fill in the multiplicities of the non-NaN entries:
multiplicity(~isnan(events)) =    diff([events(~isnan(events)); nof_hits+1],1,1);

end

