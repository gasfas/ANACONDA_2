% DEPRECATED: This version is used by DLT.read_slow, which is much slower than DLT.read.
%
% Interpret triggings of the TDC (time-to-digigal) converter, within a group,
% into device-independent TOF, X, Y coordinates (or only TOF).
%
% The raw words from the TDC-card (DLT-file) can be reconstructed
% as (2^24*(chanels-1) + value_unsigned).
% where value_unsigned = value if value >= 0, or value + 2^24 otherwise.
%
% Note: DLT.read optimizes away the call to this method if the detector's
% public list of channels (.channels_onebased) is empty. If any special
% detector subclass should be called also for empty events it needs to have
% an empty channels_onebased (and handle possible channel-filtering
% using another internal property).
%
% A detector that needs access to the full event data, including all channels,
% should use an empty channel list (.channels_onebased).
%
% PARAMETERS
%  channels  (uint32) T-by-1 array with the one-based channel index of each trigging.
%            The conversion from zero-based index in the DLT file format
%            to one-based index is done to fit the convention in Matlab.
%            Values from 1 to 253 are defined as valid channel
%            indices for the DLT file format while 253 and 255 are reserved for possible
%            future extensions (e.g. status/error codes or non-TDC data)
%            and 256 is not allowed (interferes with the group-start marker
%            used for a simple constraint that allows recovering a corrupted
%            file where data from head/middle is missing).
%            Example: triggings on the fifth channel have channel==5,
%            and the time-values in values(channel==5).
%
%  values    (int32) T-by-1 array with the time value of each trigging.
%            24 bits, in units of det.time_unit.
%
%  counts_selected  (double) C-by-1 array of the number of triggings for relevant channels.
%            If .channels_onebased is non-empty, only counts for those channels are returned.
%            Example: counts_selected(1) is for the fifth channel if .channels_onebased=[5].
%            If .channels_onebased is empty, counts for "all" channels
%            (as determined by dlt.hardware_info.number_of_channels) are returned.
%            Example: counts_selected(1) is for the first channel if .channels_onebased=[].
%            (A Matlab error occurs if the file contains triggings at larger than expected channel ids.)
%            NOTE: even when .channels_onebased is non-empty, channels and values contains
%            the unfiltered array of triggings (possibly also other channels).
% RETURN
%  XYT   (double) 1-by-hit_count, must match result from has_XY().
%            If an empty matrix is returned and discarded==0 then the empty event
%            is OK to use (has been rescued if rescued~=0).
%            If an empty matrix is returned and discarded~=0 then rescuing failed
%            (or the 'abort' mode of rescuing is used), so that the entire event
%            must be aborted (data on other detectors will not be used).
%
%  discarded (uint32) bitmask with the following meanings
%    1 'discarded_but_complete': discarded due to additional validity check,
%            e.g. DLD timing anomaly or (x,y)-radius.
%    2 'incomplete_group': different number of hits on DLD channels
%    If extensions to other bits are made, they should preferrably be consistent
%    with DLT.GROUP_STATUS_BIT (not that not all flags defined there may be returned by this function).
%
%  rescued   (uint32) bitmask with the same meanings as in discarded.
%    If rescued~=0 then the problems marked by the nonzero bits existed but
%    a re-analysis (dependent on rescue_mode) could produce a useable set of hits,
%    and at least one bit in discarded has been cleared.
%
%    If there were multiple problems, a rescue_mode algorithm can in principle
%    rescue a serious problem ('incomplete_group') while leaving a mild problem
%    e.g. hit outside allowed (x,y)-radius, thus returning discarded=1, rescued=2
%
%    The condition bitand(discarded, rescued) == 0 always holds.
% 
% SEE ALSO
%  has_XY
%  rescue_mode_names
%  read_TDC_vectorized_i1
%
% AUTHOR
%  Erik Månsson, 2010--2015, erik.mansson@sljus.lu.se, erik.mansson@ifn.cnr.it
function [XYT, discarded, rescued] = read_TDC_array(det, channels, values, counts_selected)
rescued = uint32(0); % initialize to zero (nothing rescued)
discarded = rescued; % initialize to zero (no error)

% (Prepared in caller, under condition that det.channels_onebased is not empty: counts_selected = counts(det.channels_onebased);)
ch = det.channels_onebased; % cache

% NOTE: skipping the check for empty array since DLT.read already optimizes away
% the call to read_TDC_array, and the handling below is applicable also for empty arrays.
%if counts_selected(1) == 0
%  % Empty event for this detector
%  XYT = [];
%else
  
  values_selected = values(channels==ch(1))';
%   values_selected = int32(values(channels==ch(1))');
%   % Convert from signed to unsigned value, I24 instead of U24.
%   % If first bit is set, signed value is negative.
%   values_selected(values_selected >= int32(2^23)) ...
%     = values_selected(values_selected >= int32(2^23)) - int32(2^24); 
%   % Note: class or local variable BIN_POWER_23_INT32 =  int32(2^23); was slightly slower than in-place constants. Skipping int32 possibly improves marginally, but not to make values_selected initially double so I keep int32 until double needed.
  
  XYT = double(values_selected) * det.time_unit; % conver to double, and time [s].
  % Fully valid event for this detector
%end

% NOTE: the DetTOF detector cannot give invalid events.
% TOF-filtering (or filtering on whether a "probe photodiode" was triggered)
% is not implemented in the detector layer, but in the treatment layer
% (e.g. via the list of particle/feature definitions and requiring a coincidence with
% a "particle"/feature that could be named "probe photodiode trigging").

