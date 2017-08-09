function [ exp_f ] = exp(exp, filt_events, nof_hits)
% Filter out the specified events of interest from a data file.
% Inputs:
% exp               The experimental data (must contain at least hits and events
% filt_events       The event filter that specifies which events will be
%                   transmitted to the new file
% nof_hits			The number of hits of each detector in the experiment.
% Output:
% exp_f             The event-filtered experiment

%% Initiate exp_f
exp_f = rmfield(exp, {'e', 'h'});

%% Filter event indeces
% The event indeces have to be filtered, but the values have to be adjusted
% as well:

for detnr = 1:size(exp.e.raw, 2)
    detname = ['det' num2str(detnr)];
    
    events = exp.e.raw(:,detnr);
    % We calculate the number of hits per event (named 'C'):
    C_det = convert.event_multiplicity(events, nof_hits(detnr));
    % Filter this out to the ones of interest:
    C_det_f = C_det(filt_events);
    % Now we can build up the new event index array:
    events_f = 1+[0; cumsum(C_det_f(1:end-1))];
    % Change the array structure to double:
    events_f = double(events_f);
    % rewrite the location of 'NaN' event indeces with 'NaN':
    events_f(isnan(events(filt_events))) = NaN;
    % write it into the output struct:
    exp_f.e.raw(:,detnr) = events_f;
end

%% Filter event data
% copy the event data that are not related to specific detectors:
% All fields will be copied, except for the raw indeces:
exp_to_copy = general.struct.rmsubfield(exp, 'e.raw');
% write the new event data (filtered):
e_f = filter.structfields(exp_to_copy.e, filt_events);
% write it in the new struct:
exp_f.e = setfield(e_f, 'raw', exp_f.e.raw);

%% Filter hit data.

% Loop over all detectors:
for detnr = 1:size(exp.e.raw, 2)
    detname = ['det' num2str(detnr)];

    % Translate the event filter to the hit filter of this detector:
    [h_filt_det] = filter.events_2_hits_det(filt_events, exp.e.raw(:,detnr), nof_hits(detnr));
    % copy the structs into the new (filtered) struct:
    h_f = filter.structfields(exp_to_copy.h.(detname), logical(h_filt_det));
    % Write it in the new struct:
    exp_f.h.(detname) = h_f;
end

end
