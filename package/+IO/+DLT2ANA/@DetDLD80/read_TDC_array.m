% NOTE: This version is used by DLT.read_slow, which is much slower than DLT.read.
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
%  XYT   (double) 3-by-hit_count, must match result from has_XY().
%            If has_XY() is true, the first row contains x-position [m]
%            and the second row contains y-position [m].
%            The last row, i.e. XYT(end,:), is always time-of-flight [s].
%            Depending on has_XY() the last row is either row 1 or row 3.
%            Detector that only give position are not implemented yet, they
%            could either return two rows or put NaN at the third row.
%
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
function [XYT, discarded, rescued] = read_TDC_array(det, channels, values, counts_selected)
rescued = uint32(0); % initialize to zero (nothing rescued)
discarded = rescued; % initialize to zero (no error)

% (Prepared in caller, under condition that det.channels_onebased is not empty: counts_selected = counts(det.channels_onebased);)
chs = det.channels_onebased; % cache

if all(counts_selected == counts_selected(1))
  % Equal number of triggings on each channel.
  
  
%   if counts_selected(1) == 0
%     % Empty event for this detector.
%     XYT = [];
%     % NOTE: An event without trigging on the DLD detector is valid, though not
%     % always useful, and can easily be discovered by checking the size of XYT.
%     % So bitand(discarded | DLT.GROUP_STATUS_BIT.lone_start_trigging) will remain false,
%     % and handling of empty events (empty on all detectors) is controlled by
%     % the readoption__keep_empty property in the DLT class.
%     return;
%   end
  % Note: DLT.read optimizes away the call to read_TDC_array
  % if the detector has provided a nonempty list of channels.
  % If the implementation of DLT.read is changed to call DetDLD80.read_TDC_array
  % this handling must be uncommented, because the treatment below gives error
  % (Index exceeds matrix dimensions) in case of empty data.
    
  % IMPROVEMENT: test various implementations for performance, e.g. caching separate x and y arrays rather than XYT, and possibly skip the values_selected cache
  % * Converting values_selected to double dirctly, and having all other variables as double didn't change performance significantly (less than 1% improvement)
  
%   values_selected = int32([values(channels==chs(1))'
%   values_selected = [values(channels==chs(1))'
%                      values(channels==chs(2))'
%                      values(channels==chs(3))'
%                      values(channels==chs(4))'];
%   values = values'; values_selected = [values(channels==chs(1)); values(channels==chs(2)); values(channels==chs(3)); values(channels==chs(4))]; % good
  values_selected = [values(channels==chs(1)), values(channels==chs(2)), values(channels==chs(3)), values(channels==chs(4))]'; % good (insignificantly faster than the above)
%   values_selected = zeros(4,counts_selected(1),'int32'); % slightly slower:
%   values_selected(1,:) = values(channels==chs(1));
%   values_selected(2,:) = values(channels==chs(2));
%   values_selected(3,:) = values(channels==chs(3));
%   values_selected(4,:) = values(channels==chs(4));


%   % Convert from signed to unsigned value, I24 instead of U24.
%   % If first bit is set, signed value is negative.
%   values_selected(values_selected >= int32(2^23)) ...
%     = values_selected(values_selected >= int32(2^23)) - int32(2^24);              

  % NOTE: for dlt.readoption__keep_discarded to have an effect,
  % the XYT matrices need to be computed also for anomalous events.
  % That is not the case now.
  % I don't think readoption__keep_discarded seems very useful. Rescue_mode 'make empty'
  % gives more fined-grained control (per detector) and DLT_log_invalid can be used
  % to investigate the invalid events' triggings, more genereally (also incomplete events).
  
  % Check TOF anomaly, to possibly invalidate hits
  TOF_anomaly_times2 = values_selected(4,:) + values_selected(3,:) - values_selected(2,:) - values_selected(1,:); % (y1+y2)-(x1+x2), in 0.5*hardware bin units [det.time_unit/2]
  
  % DEBUG: log TOF anomaly
  %global logged_TOF_anomaly_times2; logged_TOF_anomaly_times2(end+(1:length(TOF_anomaly_times2)),1)=TOF_anomaly_times2'; %DEBUG
  % DEBUG: log to TOF anomaly histogram
%   anomaly_histogram_bin_index = TOF_anomaly_times2 / det.TOF_anomaly_histogram_bin_with_TU2 + det.TOF_anomaly_histogram_index_of_zero;
%   % Clamp values outside histogram range:
%   anomaly_histogram_bin_index(anomaly_histogram_bin_index < int32(1)) = int32(1);
%   anomaly_histogram_bin_index(anomaly_histogram_bin_index >= det.TOF_anomaly_histogram_index_of_zero*2) = TOF_anomaly_histogram_index_of_zero*2-int32(1);
  % DEBUG implementation with non-adjustable binning:
%   anomaly_histogram_bin_index = TOF_anomaly_times2 / int32(8) + int32(300);
%   % Clamp values outside histogram range:
%   anomaly_histogram_bin_index(anomaly_histogram_bin_index < int32(1)) = int32(1);
%   anomaly_histogram_bin_index(anomaly_histogram_bin_index >= uint32(600)) = int32(599);
%   det.TOF_anomaly_histogram(anomaly_histogram_bin_index) = det.TOF_anomaly_histogram(anomaly_histogram_bin_index) + uint32(1);
  
  
  if all(TOF_anomaly_times2 >= det.min_TOF_anomaly_TU2 & TOF_anomaly_times2 <= det.max_TOF_anomaly_TU2)

    time_unit = det.time_unit; % cache
%     XYT = NaN(3, counts_selected(1)); % allocate, datatype 'double': slower than just concatenating rows by [;;]

    % For x and y, perform the detector-dependent scaling from [ns] to [m] units
    % directly when the conversion to double and time is done
    XYT = [
      double(values_selected(1,:) - values_selected(2,:)) * (det.signal_speed_x * time_unit);  % x = t_x1 - t_x2 [m]
      double(values_selected(3,:) - values_selected(4,:)) * (det.signal_speed_y * time_unit);  % y = t_y1 - t_y2 [m]
      ... % For TOF, convert to double, average the channels and convert to time units
      double(sum(values_selected,1)) * (0.25 * time_unit) % (x1+x2+y1+y2)/4 = TOF (uncalibrated) [ns]
    ];

    % Check radial limit
    if all(XYT(1,:).*XYT(1,:) + XYT(2,:).*XYT(2,:) <= det.max_radius_squared)
      % Fully valid event for this detector
      return;
    %else
      % Invalid event for this detector: Some hit is outside allowed radius
    end
  %else
    % Invalid event for this detector: Some hit is outside allowed TOF anomaly
  end
  discarded = uint32(1); % TODO: test performance vs. named static constant (rumoured to be slow): DLT.GROUP_STATUS_BIT.discarded_but_complete;
else
  % Varying number of triggings on the channels
  discarded = uint32(2); % TODO: test performance vs. named static constant (rumoured to be slow): DLT.GROUP_STATUS_BIT.incomplete_group;
end

% Invalid event for this detector (but can try rescuing)
% NOTE: This part is only reached if discarded ~= 0

switch det.rescue_mode
  case 2 %'make empty'
    XYT = [];
    rescued = discarded; % Store the problem type, but now in the bitmask of "rescued" problems
    discarded = uint32(0); % Clear the discarded bitmask

  % TODO: implement real rescue modes

  otherwise % including case 1 %'abort'
    % If the data for this detector is not OK or rescued, it signals that the
    % entire event must be aborted (not using other detector data either).
    XYT = [];
    % rescued remains zero, discarded remains nonzero.
end

% Copied from old DLD class:
%     if group_length == uint32_zero
%       % Do nothing, group is empty
%     else
%       % Parse the triggings (hits) in the group
%       i_end = position+group_length; i = position;
%       while i < i_end
%         word = buffer(i);
%         i = i + uint32_one;
%         
%         value = rem(word, bin_power_24); % the final U24 of the word
%         channel = (word - value) / bin_power_24 + uint32_one; % the first U8 from the word, 1-based for Matlab indexing
%         if channel <= number_of_channels
%           % Convert from signed to unsigned value, I24 instead of U24
%           % TODO: investigate if faster to buffer I32 instead of U32 to avoid conversion at end, but
%           % the splitting of a word into U16 or U8 will be more complicated
%           % then.
%           if value >= bin_power_23 % if first bit is set, signed value is negative
%             if readoption__values_in_nanoseconds
%               value_signed = time_unit * (double(value) - bin_power_24_signed_double);
%             else
%               value_signed = int32(value) - bin_power_24_signed;
%             end
%           else
%             if readoption__values_in_nanoseconds
%               value_signed = time_unit * double(value);
%             else
%               value_signed = int32(value);
%             end
%           end
%           
%           if readoption__cell_per_group
%             %Old idea, a cell per group: group_data{channel}(end+1) = value_signed;
%             %New idea, a cell per chanel in file, then inner cell per group. The benefit is if some intermediate/low channel index is never used it uses no space.
%             %old: %if channel > length(channel_group_values) % first time this channel appears
%             if isempty(channel_group_values{channel}) % first time this channel appears
%               %channel_group_values{channel} = {};
%               channel_group_values{channel} = cell(max(event_count,expected_event_count),1); % pre-allocate
%             end
%             if event_count > length(channel_group_values{channel}) % need to grow array, got more groups than pre-allocated for
%               channel_group_values{channel}{event_count,1} = value_signed;
%             else % append
%               channel_group_values{channel}{event_count,1}(1,end+1) = value_signed;
%             end
%           end
%           
%           if readoption__padded_matrix
%             % Alternative idea. Zero-padded matrix per channel.
%             %old, seemed slow?: if isempty(channel_values{channel})
%             if ~channel_values_allocated(channel)
%             
%               % First time for the channel: grow the matrix.
%               channel_hits(max(event_count,expected_event_count), max(channel,number_of_channels)) = uint16(0); % put a zero at large index to make Matlab reallocate to expected size already at first group
%               channel_hits(event_count,channel) = uint16_one; % Matlab pads other with zeros for unassigned elements.
%               
%               % Pre-allocate also the channel_values matrix
%               if readoption__values_in_nanoseconds
%                 % When using double as data type the padding can be NaN
%                 channel_values{channel} = NaN( max(event_count,expected_event_count), preallocated_hit_count, 'double');
%               else
%                 channel_values{channel} = zeros( max(event_count,expected_event_count), preallocated_hit_count, 'int32');
%               end
%               channel_values_allocated(channel) = true;
%               
%             elseif event_count > size(channel_hits,1)
%               % First time for the group: grow the matrix. Matlab pads other with zeros for unassigned elements.
%               channel_hits(event_count,channel) = uint16_one;
%               % IMPROVEMENT: consider reallocating in larger blocks (put a zero further down before putting the 1 at desired index) if it speeds up. (Matlab might to do it anyway?)
%             else % Increment existing (possibly zero-valued) element
%               channel_hits(event_count,channel) = channel_hits(event_count,channel) + uint16_one;
%             end
%             channel_values{channel}(event_count,channel_hits(event_count,channel)) = value_signed;
%           end
%           % TODO: test memory performance and speed for these two variants
%           % with different types of data (3D or MBES with IR photodiode).
%         end
%       end
%     end