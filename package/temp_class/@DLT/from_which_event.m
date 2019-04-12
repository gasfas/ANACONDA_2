%FROM_WHICH_EVENT Reverse mapping from hit index to event index.
% For a given event index e, the loaded hit data is in
%   XYT{d}(:,hit_indices)
% where
%   hit_indices = dlt.start_index(e):dlt.start_index(e+1)-1 .
% This method returns an array for the reverse mapping, such that
%  all(e == from_which_event(hit_indices))
% Note that empty events have no entry in the from_which_event-array.
%
% PARAMETERS
%  detector_index    For which detector, 1-based indexing.
%  lookup_hit_index (optional, default: [])
%                    For which loaded hit(s), 1-based indexing up to size(dlt.XYT{detector_index),2) or logical array.
%                    If [], returns the array with event index for each hit.
%                    If scalar, returns the specific event index of one hit.
% RETURNS
%  from_which_event  (int32) 1-by-H array, where H is 1 or size(dlt.XYT{detector_index),2).
%
% SEE ALSO get_loaded XYT 
%
% AUTHOR
%  Erik Månsson, 2010--2015, erik.mansson@sljus.lu.se, erik.mansson@ifn.cnr.itfunction [from_which] = from_which_event(dlt, detector_index, lookup_hit_index)
if nargin < 3
  lookup_hit_index = [];
end

if length(dlt.from_which_event__cached) >= detector_index && dlt.is_loaded_data_current() ...
    && length(dlt.from_which_event__cached{detector_index}) == dlt.start_index(detector_index,end)-1
  % Return already computed array
  if isempty(lookup_hit_index)
    from_which = dlt.from_which_event__cached{detector_index};
  else
    from_which = dlt.from_which_event__cached{detector_index}(lookup_hit_index);
  end
  return;
end

if length(lookup_hit_index) == 1
  % Return for a single hit

  from_which = find(dlt.start_index(detector_index,:) <= lookup_hit_index, 1, 'last');
  if dlt.start_index(detector_index,from_which) <= lookup_hit_index ...
    && dlt.start_index(detector_index,from_which+1) > lookup_hit_index
    % OK, the hit is within the found event
  else
    % Previous event found
    error('Programming error');
  end
  
else
  % Compute for all hits.
  
  % The simple version from_which = cumsum(is_start) would fail in the presence of empty events.

  H = size(dlt.XYT{detector_index},2);
  % Appending a meaningless index at end to make the matrix sizes match
  % regardless of whether last group was empty/discarded or not.
  from_which = zeros(1,H+1);
  % Assign event index for the first hit 
  from_which(dlt.start_index(detector_index,1:end-1)) = uint32(1):dlt.event_count;
  % Remove the extra entry again, to ensure it won't be read by mistake
  from_which(end) = [];

  % Propagate to the following hits
  last_event = 0;
  for e = 1:H
    if from_which(e) > 0
      last_event = from_which(e);
    else
      from_which(e) = last_event;
    end
  end

  % Cache in a private property to not recompute this array again.
  dlt.from_which_event__cached{detector_index} = from_which;
  
  if ~isempty(lookup_hit_index)
    % Return only selected indices
    from_which = from_which(lookup_hit_index);
  else
    % Return for all hits.
  end
end