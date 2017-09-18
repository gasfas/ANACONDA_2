% Return one or more hits from a specific event and detector,
% using data in the loaded (untreated) layer.
%
% Or, when called with event_index=[], returned all hits loaded for the detector,
% without grouping by event or considering the dlt.discarded.
%
% Since the hit count varies between events, there is no simple and efficient
% data structure that for each event index would hold a list of the hit data.
% Can instead perform filtering on hit indices, and at the end via
% dlt.from_which_event find their event indices.
%
% EXAMPLES
%  [T_first, X_Y_first] = dlt.get_loaded(det_index, e, 1); % a specific hit in the event
%  [T, XY] = dlt.get_loaded(det_index, e); % all hits in the event
%
% PARAMETERS
%  detector_index
%               Which detector, 1-based indexing, scalar (a single detector).
%  event_index  (optional, default: [])
%               Which events, 1-based indexing.
%               If event_index=[] then hits are returned from all events
%               that contain at least max(hit_index) hits.
%               If event_index is non-empty, hits from precisely those events
%               are returned, except that nothing at all is returned if any
%               event with too few hits (less than max(hit_index)) was selected.
%  hit_index    (optional, default: [])
%               Which hit(s) within each event, 1-based indexing.
%               If an empty array is given, returns all hits in the event.
%  strict       (optional, default: true)
%               The strict setting determines what to do when a non-empty
%               event_index-array refers to some event that is discarded
%               or has too few hits.
%               True : return empty arrays and issue a warning.
%               False: ignore the bad events and return shorter arrays
%                     (this should not be used if one value per event is needed)
%               NaN  : put NaN in place of missing entries in arrays
%
% RETURNS
%  T            (double) Time of flight [s].
%               1-by-H if hit_index == [], where H is the number of hits.
%               M-by-E if M=length(hit_index)>0, where E is the number of returned events.
%
%  XY           (double) Position [m] or empty in case of detector without XY-information.
%               2-by-H if hit_index == [], where H is the number of hits.
%               (M*2)-by-E if M=length(hit_index)>0, where E is the number of returned events.
%               In the latter case, odd-index rows contain X-coordinates and even-index rows contain Y-coordinates.
%
%  event_index  Event indices from which data was returned.
%               1-by-E (double)
%               NOTE that if hit_index==[] is used, the returned info does
%               not tell which events belonged to each event.
%               (IMPROVEMENT: could make it be of size 1-by-H and work as
%               from_which_group in DetTOF.read_TDC_vectorized_i1)
%
% EXAMPLE
%  dlt.get_loaded(1, 7)         % Return all hit on detector 1 in loaded event #7.
%  dlt.get_loaded(1, 7, 2)      % Return the second hit on detector 1 in loaded event #7.
%                               % If this event has fewer (or no) hits, [] is returned.
%  dlt.get_loaded(1, 7, [1 3])  % Return the first and third hit on detector 1 in loaded event #7.
%                               % If this event has fewer than three hits, [] is returned.
%  dlt.get_loaded(1, [], 2)     % Return the second hit on detector 1, from all events where it has at least two hits.
%  dlt.get_loaded(1, [], [1 3]) % Return the first and third hits on detector 1, from all events where it has at least three hits.
%
% SEE ALSO
%  get_hit_count is_loaded_data_current discarded_kept XYT from_which_event
function [T, XY, event_index] = get_loaded(dlt, detector_index, event_index, hit_index, strict)

if nargin < 1
  error('No detector index given.')
end
if detector_index > length(dlt.detectors)
  error('Detector index out of range. Note that event_index is the second argument to dlt.get_loaded().')
end
if length(detector_index) ~= 1
  error('A single detector must currently be selected. Use multiple calls to read out data from multiple detectors.')
end
if nargin < 3
  event_index = [];
end
if nargin < 4
  hit_index = [];
end

OK = uint32(0);
events_to_return_NaN_for = [];

if isempty(event_index) && isempty(hit_index)
  % Return all hits for the detector, from all non-discarded events
  if dlt.discarded_kept
    % Need to work a bit to avoid returning hit data from discarded groups.
    
    % (old, fails e.g. when not precisely one hit per kept event): XYT = dlt.XYT{detector_index}(:, dlt.discarded(detector_index,:)==OK);
    event_index = find(dlt.discarded(detector_index,:) == OK);
    % Concatenate all hits on the same row
    u = false(1,size(dlt.XYT{detector_index},2)); % here using u for logical instead of numeric indexing
    s = dlt.start_index(detector_index,event_index);
    e = dlt.start_index(detector_index,event_index+1);
    which = s < e;
    while any(which) % first mark all "hit 1" positions (each event) in u, then all "hit 2" positions, until max occurring hit count reached
      u(s(which)) = true;
      s = s + 1;
      which = s < e;
    end
    
    XYT = dlt.XYT{detector_index}(:, u);

  else
    XYT = dlt.XYT{detector_index};
    if nargout >= 2
      event_index = 1:dlt.event_count;
    end
  end

  if size(XYT, 1) == 1
    if nargout >= 2
      XY = [];
    end
    T = XYT;
  else
    if nargout >= 2
      XY = XYT(1:2,:);
    end
    % Using (3,:) rather than (end,:) to get error if a two-row matrix has been returned. 
    T = XYT(3,:);
  end

else
  % Need to consider hits as grouped into events.
  
  if ~isempty(hit_index)
    % Return a particular hit index (or several),
    use_NaN = false;
    bad = [];
        
    % BEGIN event selection
    if isempty(event_index)
      % from all non-discarded events with enough hits.
      if dlt.discarded_kept
        event_index = find((dlt.start_index(detector_index,2:end) - dlt.start_index(detector_index,1:end-1)) >= max(hit_index) && dlt.discarded(detector_index,:)==OK);
      else
        event_index = find((dlt.start_index(detector_index,2:end) - dlt.start_index(detector_index,1:end-1)) >= max(hit_index));
      end

    else
      % from the given list of events.
      event_index = event_index(:)'; % ensure that it is a row vector

      if nargin < 5
        strict = true;
      end
      if isnan(strict)
        use_NaN = true;
        strict = true; % for easier checking, ensure strict is always a logical. use_NaN==true is a subcase within strict=true.
      end
      bad = dlt.start_index(detector_index,event_index+1) - dlt.start_index(detector_index,event_index) < max(hit_index); % too short
      if any(bad)
        if strict
          if use_NaN
            events_to_return_NaN_for = find(bad);
            event_index(bad) = 1; % pick an arbitrary low index (data will be NaN:ed later) so that the hit array will hopefully be long enough to give som data for the event (DEBUG IMPROVEMENT: this is a heuristic that will faile if arrays are nearly empty)
          else
            warning('DLT:too_few_hits', 'Some of the selected events (%d of %d) have too few hits (<%d). Since get_loaded was used in strict mode, nothing is returned.', sum(bad), length(event_index), max(hit_index));
            event_index = []; % empty output instead of indexing error when too large hit_index given
          end
        else
          event_index(bad) = []; % just skip the bad events
        end
      end
      if dlt.discarded_kept
        bad = dlt.discarded(detector_index,event_index) ~= OK;
        if any(bad)
          if strict
            if use_NaN
              events_to_return_NaN_for = find(bad);
              event_index(bad) = 1; % pick an arbitrary low index (data will be NaN:ed later) so that the hit array will hopefully be long enough to give som data for the event (DEBUG IMPROVEMENT: this is a heuristic that will faile if arrays are nearly empty)
            else
              warning('DLT:discarded', 'Some of the selected events (%d of %d) are marked as discarded. Since get_loaded was used in strict mode, nothing is returned.', sum(bad), length(event_index));
              event_index = []; % empty output instead of indexing error when too large hit_index given
            end
          else
            event_index(bad) = []; % just skip the bad events
          end
        end
      end

    end % END event selection
    
    % Get the global hit indices for desired hits from those events
    if length(hit_index) == 1
      % Get one hit per event
      u = dlt.start_index(detector_index,event_index) + (hit_index-1); % Global hit indices
    else
      % Concatenate multiple hits: one column per event, one row per hit index within event
      u = repmat(dlt.start_index(detector_index,event_index) - 1, length(hit_index), 1) ...
        + repmat(uint32(hit_index(:)), 1, length(event_index)); % Global hit indices
    end
    %hit_index = []; % to not make additional filtering below
    if ~isempty(events_to_return_NaN_for)
      u(:,events_to_return_NaN_for) = 1; % use lowest index for the events that don't have enough hits, to hopefully not end up outside array (DEBUG IMPROVEMENT this is a heuristic that may fail)
      event_index(events_to_return_NaN_for) = NaN;
    end
    
  else % implies: isempty(hit_index) && ~isempty(event_index)
    % Return all hits, from specific event(s)
    % Concatenate all hits on the same row

    u = false(1,size(dlt.XYT{detector_index},2)); % here using u for logical instead of numeric indexing
    s = dlt.start_index(detector_index,event_index);
    e = dlt.start_index(detector_index,event_index+1);
    which = s < e;
    while any(which) % first mark all "hit 1" positions (each event) in u, then all "hit 2" positions, until max occurring hit count reached
      u(s(which)) = true;
      s = s + 1;
      which = s < e;
    end
  end

  if isempty(u)
    % Nothing to return
    % (empty result without error is returned even when a hit_index was specified)
    if nargout >= 2
      XY = [];
    end
    T = [];
    return;
  else
    if size(dlt.XYT{detector_index}, 1) == 1 || nargout <= 1 % only TOF
      T = dlt.XYT{detector_index}(end,u); % size(T,2) == min(1, length(hit_index))
      if length(hit_index) > 1
        % Simplify use for coincidence analysis (e.g. hit_index==[1 2]) by
        % concatenating hits vertically and events horizontally.
        T = reshape(T,length(hit_index),length(event_index)); % size(T,2) == min(1, length(hit_index))
      end
      if ~isempty(events_to_return_NaN_for)
        T(:,events_to_return_NaN_for) = NaN; % put NaN instead of bogus data for events that had too few hits (if the argument strict==NaN was given)
      end
      if nargout >= 2
        XY = [];
      end
      
    else
      XYT = dlt.XYT{detector_index}(:,u(:)); % old style: concatenates horizontally, also within event when length(hit_index)>1
      if length(hit_index) > 1
        % Simplify use for coincidence analysis (e.g. hit_index==[1 2]) by
        % concatenating hits vertically and events horizontally.
        T = reshape(XYT(3,:),length(hit_index),length(event_index)); % size(T,2) == min(1, length(hit_index))
      % For XY, the rows are [x1;y1; x2;y2; ...]
        XY = reshape(XYT(1:2,:),2*length(hit_index),length(event_index)); % size(T,2) == 2 * min(1, length(hit_index)); 
      else
        T = XYT(3,:);
        XY = XYT(1:2,:);
      end
      if ~isempty(events_to_return_NaN_for)
        % put NaN instead of bogus data for events that had too few hits (if the argument strict==NaN was given)
        T(:,events_to_return_NaN_for) = NaN;
        XY(:,events_to_return_NaN_for) = NaN;
      end

    end

  end
end
