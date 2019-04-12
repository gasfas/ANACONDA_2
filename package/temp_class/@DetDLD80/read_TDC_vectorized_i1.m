% Interpret triggings of the TDC (time-to-digigal) converter,
% within each group group in a buffered block,
% into device-independent TOF, X, Y coordinates (or only TOF).
%
% The number of groups given in the buffer block is
%   G = sum(is_last) = sum(is_start).
% This method parses all groups and determines which are discarded. Depending
% on Detector.rescue_mode, initially invalid groups may sometimes be rescued
% and thus not marked as discarded.
%
% The hit coordinates in 3D (or 1D for such detectors) are produced and 
% concatenated to the XYT output. This is done at least for accepted groups,
% but possibly also for for groups that were discarded due to a value-anomaly
% rather than trigging-incompleteness (i.e. where hit data could be produced).
% The part of the XYT matrix that belongs to the group at index g is
%   XYT(:, event_start(g):event_start(g+1)-1),
% i.e. the number of hits returned for the group is given by
%   event_start(g+1)-event_start(g).
%
% For multi-detector configurations, DLT.read will consider the status returned
% by each detector. If no detector discards a group, it will be accepted as an event.
% One exception is that empty groups (with no hit from any detector) are rejected
% and hidden from the group count if dlt.readoption__keep_empty==false.
% The setting dlt.readoption__keep_discarded determines whether discarded groups
% are kept in memory (with any invalid XYT-data returned) marked as discarded 
% or completely rejected and hidden from the group count.
% 
%
% PARAMETERS
%  channel_token(int32) B-by-1 array with (approximatively) the zero-based
%                       channel index of each trigging, interleaved by group start markers.
%  value    (int32)     B-by-1 array with the raw (time) value of each trigging,
%                       interleaved by group start markers.
%  is_last  (logical)   B-by-1 array marking the last trigging in each group,
%                       or the group start marker for empty groups.
%  is_start (logical)   B-by-1 array marking each group start marker.
%  indices_to_ignore (int32) I-by-1 array with the indices of the above arrays
%                       that contain data for absolute_group_trigger_time instead of TDC-triggings.
%                       For DLT version 2 these are currently the two indices following each group start marker,
%                       while for version 0 and 1 no indices need to be ignored.
%
% PARAMETER DETAILS
%  channel_token
%    channel_onebased = channels_token + 1, when channels_token > 0.
%    channel_onebased = channels_token + 257, when channels_token < 0.
%
%    channel_onebased from 1 to 253 are defined as valid channel
%    indices for the DLT file format while 253 and 255 are reserved for possible
%    future extensions (e.g. status/error codes or non-TDC data)
%    and 256 is not allowed (interferes with the group-start marker
%    used for a simple constraint that allows recovering a corrupted
%    file where data from head/middle is missing).
%
%    Example: triggings on the fifth channel have channel_tokens==4,
%    and all their time-values are found by value(channel_tokens==4).
%
%  values   
%    The time value of each trigging from a RoentDek TDC8HP
%    is a 24 bit signed integer in units of det.time_unit.
%    Here it has been converted into a 32 bit signed integer,
%    so the high byte is either 0xFF (negative) or 0x00 (non-negative).
%
%    The raw words from the TDC-card (DLT-file) can be reconstructed
%    as (2^24*(chanels-1) + value_unsigned).
%    where value_unsigned = value if value >= 0, or value + 2^24 otherwise.
%
% RETURN
%  XYT (double) 3-by-hit_count or 1-by-hit_count, matching has_XY().
%      If has_XY() is true, the first row contains x-position [m]
%      and the second row contains y-position [m].
%      The last row, i.e. XYT(end,:), is always time-of-flight [s].
%      Depending on has_XY() the last row is either row 1 or row 3.
%      (Detectors that only give position are not implemented yet, they
%      could either return two rows or put NaN at the third row.)
%
%  event_start      (double) 1-by-(G+1) array
%      The part of the XYT matrix that belongs to the group at index g is
%        XYT(:, event_start(g):event_start(g+1)-1),
%      i.e. the number of hits returned for the group is given by
%        event_start(g+1)-event_start(g).
%      Note that this array has an entry at index G+1, to mark the end of the last group.
%
%  discarded        (uint32) 1-by-G 
%      Bitmask with the following meanings
%      1 'discarded_but_complete': discarded due to additional validity check,
%              e.g. DLD timing anomaly or (x,y)-radius.
%      2 'incomplete_group': different number of hits on DLD channels
%      If extensions to other bits are made, they should be consistent
%      with DLT.GROUP_STATUS_BIT (but not all flags defined there may be returned by this method).
%
%  rescued          (uint32) 1-by-G
%      Bitmask with the same meanings as in discarded.
%      If rescued~=0 then the problems marked by the nonzero bits existed but
%      a re-analysis (dependent on rescue_mode) could produce a useable set of hits,
%      and at least one bit in discarded has been cleared.
% 
%      If there were multiple problems, a rescue_mode algorithm can in principle
%      rescue a serious problem ('incomplete_group') while leaving a mild problem
%      e.g. hit outside allowed (x,y)-radius, thus returning discarded=1, rescued=2
% 
%      The condition bitand(discarded, rescued) == 0 always holds.
%
%  from_which_group (double) 1-by-hit_count, or 1-by-(hit_count+1) where last entry is ignored
%      The reverse mapping of event_start, such that 
%        all(from_which_group(event_start(g):event_start(g+1)-1) == g).
%      Note that from_which_group is missing the info about empty groups,
%      which is present in event_start.
% 
% SEE ALSO
%  has_XY
%  rescue_mode_name
%  TDC.read
%  read_TDC_vectorized_i5 -- an alternative implementation (requiring minor adjustment in TDC.read) where the first filtering step is done before Detector-methods are called.
%
% AUTHOR
%  Erik Månsson, 2010--2015, erik.mansson@sljus.lu.se, erik.mansson@ifn.cnr.it

function [XYT, event_start, discarded, rescued, from_which_group] = read_TDC_vectorized_i1(det, channel_token, value, is_last, is_start, indices_to_ignore)

chs = det.channels_token; % cache
% Count triggings on the channels, but delay readout into values_chN arrays until incomplete groups have been rejected (or running rescue algorithm)
ch = [channel_token' == chs(1); channel_token' == chs(2); channel_token' == chs(3); channel_token' == chs(4)];
ch(:,indices_to_ignore) = false; % for read_TDC_vectorized_i1 but not for ..._i5 version

tmp = cumsum(ch,2); % (speed did not improve (4% worse) by converting sum from default double to int32))
channel_group_start = [[1;1;1;1], 1+tmp(:,is_last)]; % start index for each group, among triggings on the selected channel

% Note that size(channel_group_start,2) is 1 + number of groups, since it uses an extra "start" marker to tell length of last group.
rescued = zeros(1,size(channel_group_start,2)-1,'uint32'); % initialize to zero (nothing rescued)
discarded = rescued; % initialize to zero (no error)

% Cache frequently accessed properties
time_unit = det.time_unit;

if det.rescue_mode <= 2
  % No advanced rescuing or skipping/choice of triggings ==>
  % * can directly skip any group where the number of trigging varies between channels
  % * can batch-convert remaining triggings to 3D data.

  channel_triggings = diff(channel_group_start,1,2); % number of triggings in each (channel,group)
  incomplete = any(diff(channel_triggings) ~= 0);
  discarded(incomplete) = DLT.GROUP_STATUS_BIT.incomplete_group;
  %is_start = [true; is_last(1:end-1)];
  from_which_group = cumsum(is_start);% Reverse mapping from index in values-array to one-based group index

  % Exclude values from incomplete groups, to have equally long values_chN-arrays
  ch(:,incomplete(from_which_group)) = false; % hide each trigging that belongs to an incomplete group
  values_ch1 = value(ch(1,:))';
  values_ch2 = value(ch(2,:))';
  values_ch3 = value(ch(3,:))';
  values_ch4 = value(ch(4,:))';
  % Update channel_group_start so it applies to the shorter values_chN arrays
  % NOTE: now all rows channel_group_start should be identical, since groups with incomplete DLD-data were skipped.
  tmp = cumsum(ch(1,:),2); channel_group_start = [1, 1+tmp(:,is_last)]; % a single row shared by all channels
  % The reverse mapping, from index in values_chN to group index (e.g. in channel_group_start and discarded):
  from_which_group = from_which_group(ch(1,:))'; % since same counts on all channels, it suffices to read out updated from_which_group at channel 1.


  % Check TOF anomaly, to possibly invalidate more hits & groups
  TOF_anomaly_times2 = values_ch4 + values_ch3 - values_ch2 - values_ch1; % (y1+y2)-(x1+x2), i.e. TOFy-TOFx in 0.5*hardware bin units [det.time_unit/2]
  discarded(from_which_group( ...
    TOF_anomaly_times2 < det.min_TOF_anomaly_TU2 | TOF_anomaly_times2 > det.max_TOF_anomaly_TU2 ...
    )) = DLT.GROUP_STATUS_BIT.discarded_but_complete;
  % Keeping the anomalous hits in arrays, to not reallocate many times.
  % After returning to DLT:read a reallocation that skips them will be done,
  % after considering results for all detectors (and possibly settings to keep discarded event data)
  % IMPROVEMENT: test if the conversion to XYT is slow enough that first skipping the TOF-anomalous hits would be meaningful (considering also that a new cumsum() update of channel_group_start would be required)
  % (NOTE: If dlt.readoption__keep_discarded should have an effect anamlous hits and groups should be kept here,
  %  but this is not an important reason. DLT_log_invalid may serve the purpose of more generally accessing rejected groups.)
  
  if det.TOF_anomaly_histogram_bin_with_TU2 ~= 0
    % Log to TOF anomaly histogram  
    TOFa_hist_i0 = det.TOF_anomaly_histogram_index_of_zero; % cache
    % Which bin
    anomaly_histogram_bin_index = TOF_anomaly_times2 / det.TOF_anomaly_histogram_bin_with_TU2 + TOFa_hist_i0;
    % Clamp values outside histogram range:
    anomaly_histogram_bin_index(anomaly_histogram_bin_index < int32(1)) = int32(1);
    anomaly_histogram_bin_index(anomaly_histogram_bin_index >= TOFa_hist_i0*2) = TOFa_hist_i0*2-int32(1);
    %(for non-overlapping increments, i.e. single hit:) det.TOF_anomaly_histogram(anomaly_histogram_bin_index) = det.TOF_anomaly_histogram(anomaly_histogram_bin_index) + uint32(1);
    % General histogram
    det.TOF_anomaly_histogram = det.TOF_anomaly_histogram + accumarray(anomaly_histogram_bin_index', 1, size(det.TOF_anomaly_histogram)); %(double) probably an efficient way to build histogram
    
  end

  % For x and y, perform the detector-dependent scaling from [ns] to [m] units
  % directly when the conversion to double and time is done
  XYT = [
    double(values_ch1 - values_ch2) * (det.signal_speed_x * time_unit);  % x = t_x1 - t_x2 [m]
    double(values_ch3 - values_ch4) * (det.signal_speed_y * time_unit);  % y = t_y1 - t_y2 [m]
    ... % For TOF, convert to double, average the channels and convert to time units
    double(values_ch1+values_ch2+values_ch3+values_ch4) * (0.25 * time_unit) % (x1+x2+y1+y2)/4 = TOF (uncalibrated) [ns]
  ];
  
  % Check radial limit. Just as for TOF-anomaly, hit data is not removed from array here but the group is marked for removal when DLT:read pools results from all detectors.
  discarded(from_which_group( ...
    XYT(1,:).*XYT(1,:) + XYT(2,:).*XYT(2,:) > det.max_radius_squared ...
    )) = DLT.GROUP_STATUS_BIT.discarded_but_complete;
  
  if det.rescue_mode == 2
    % The simple rescue mode 'make empty':
    % Set number of hits in any discarded group to zero, and mark it as rescued.

    % Swap the rescued and discarded array contents
    swap_temporary = rescued;
    rescued = discarded; % everything is rescued
    discarded = swap_temporary; % discarded is 0 for all groups
    
    % Since there is no separate event_length output (only event_start of next event),
    % the output matrix must be shortened by actually removing the hits from the rescued events.
    skip = rescued(from_which_group) ~= 0;
    XYT(:,skip) = [];
    from_which_group(skip) = []; % needed when also from_which_group is a return value

    % Update the channel_groups_start accordingly
    channel_group_start(2:end) = channel_group_start(2:end) - cumsum(diff(channel_group_start) .* (rescued~=0));

    % Example:              while discarded ==> "rescued"(emptied) output
    % discarded|rescued   : 0 1     0       ==>  0 1  0
    % channel_group_start : 1 2     4    7  ==>  1 2  2    5
    % XYT(c,:)            : a, b c, d e f   ==>  a, , d e f
    % from_which_group    : 1, 2 2, 3 3 3
  end
  % The non-rescue mode (1, 'abort') simply keeps the discarded-status of the group
  % and lets DLT:read handle the skipping (it has to consider the accept/discard decision of all detectors).
  event_start = channel_group_start;
  
else
  
  % TODO: implement treatment with rescuing, 
  % which will probably have to be based on a for loop with one iteration per group.
  error('Rescue modes >= 2 not implemented here yet...')
  % See ../tests/test_event_rescue.m and ../tests/rescue_algorithm0_standalone.m

end
