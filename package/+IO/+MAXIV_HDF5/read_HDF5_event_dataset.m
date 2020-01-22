function exp = read_HDF5_event_dataset(exp, filename, events_dataset_names, MAX_detnrs)
% This function reads a single dataset from a HDF5 file, which are either
% hits or events.

% We start counting at one:
ANA_detnrs = MAX_detnrs + 1;

%% Event timestamps
% The events dataset has 3 columns: 1. event number, 2. timestamp, 3. index into hits of first hit for this event.

% Load event info for all detectors:
i = 0; all_event_nrs = [];
for MAX_detnr = MAX_detnrs'
    i = i + 1;
    % read in the data for this detector:
    event_data = h5read(filename, events_dataset_names{i})';
    % Write it to a temporary structure:
    enrs_MAX.(['MAXdet' num2str(MAX_detnrs(i))]) = event_data(:,1);
    hitnrs_MAX.(['MAXdet' num2str(MAX_detnrs(i))]) = event_data(:,3);
    % Store all event nrs in one long array:
    all_event_nrs = [all_event_nrs; event_data(:,1)];
    % Store the timestamps in the correct place:
    exp.e.(['det' num2str(MAX_detnr+1)]).(['timestamps_det' num2str(MAX_detnr+1)]) = event_data(:,2);
end

% MAX HDF5 format does not list events that did not lead to a hit in a
% certain detector, but ANACONDA does. Furthermore, some events are
% initiated, but never lead to any hits, and they still count (but are not
% listed).

%% Event indices
% the number of unique event numbers dictates the list of the ANACONDA event matrix:
unique_event_nrs    = unique(all_event_nrs);
nof_events          = length(unique_event_nrs);
% Initiate the data indices matrix:
exp.e.raw = NaN * ones(nof_events, length(MAX_detnrs));
i = 0; all_event_nrs = [];
for MAX_detnr = MAX_detnrs'
    i = i + 1;
    % get the indices of every event, per detector:
    [~, A_ind] = ismember(enrs_MAX.(['MAXdet' num2str(MAX_detnrs(i))]), unique_event_nrs);
    exp.e.raw(A_ind,i) = hitnrs_MAX.(['MAXdet' num2str(MAX_detnrs(i))]) + 1;
end



end