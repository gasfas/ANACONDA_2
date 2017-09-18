% Interpret triggings of the TDC (time-to-digigal) converter,
% within each group group in a buffered block,
% into device-independent TOF coordinates (or TOF, X, and Y).
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
%                       These are the two indices following each group start marker. 
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
%  value
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
function [XYT, event_start, discarded, rescued, from_which_group] = read_TDC_vectorized_i1(det, channel_token, value, is_last, is_start, indices_to_ignore)

ch = channel_token==det.channels_token(1);
ch(indices_to_ignore) = false; % for read_TDC_vectorized_i1 but not for ..._i5 version

tmp = cumsum(ch);
event_start = [1, 1+tmp(is_last)'];

XYT = double(value(ch)') * det.time_unit; % convert to double, and time [s].

% Events cannot be discarded or rescued for a sinle-channel TOF detector.
% Note that size(channel_group_start,2) is 1 + number of groups, since it uses an extra "start" marker to tell length of last group.
rescued = zeros(1,length(event_start)-1,'uint32'); % initialize to zero (nothing rescued)
discarded = rescued; % initialize to zero (no error)


% Reverse mapping from index in values-array to one-based group index
% Simpler version: from_which_group = cumsum(is_start); from_which_group = from_which_group(ch); 
% Now using safer version from read_TDC_vectorized_iv (thought to be slower, but actually same or faster)
from_which_group = zeros(1,size(XYT,2)+1); % appending a meaningless index at end to make the matrix sizes match regardless of whether last group was empty/discarded or not.
from_which_group(event_start) = 1:length(event_start);
last_group = 0;
for g = 1:length(from_which_group)-1
  if from_which_group(g) > 0
    last_group = from_which_group(g);
  else
    from_which_group(g) = last_group;
  end
end
