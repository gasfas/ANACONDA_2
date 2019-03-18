% Old and slow way to read all groups from the DLT file
%
% The read() method populates the "untreated" data layer, where a hit
% consists of TOF [s], X [m] and Y [m].% 
% TOF-only detectors are also supported and may omit the X and Y rows
% of XYT or give NaN for them.
% NOTE: this is a difference from the LabVIEW CAT-program, where
% units of [ns] were used for all dimensions, thus leaving the T_X to X scaling
% to the higher layers, which seems incorrect since it is detector dependent.
%
% Whether empty groups (no hit on any channel) are kept in arrays is
% determined by the boolean .readoption__keep_empty field.
%
% PARAMETERS
%  continue_if_footer_is_missing (default: false)
%      If true, then an attempt to read is made even if the reading of
%      footer fails. The footer error message is printed but not returned.
%
% RETURN
%  event_count (double) number of groups read
%
% SEE ALSO set_rescue_mode
%
% AUTHOR
%  Erik Månsson, 2010--2015, erik.mansson@sljus.lu.se, erik.mansson@ifn.cnr.it
function event_count = read_slow(dlt, continue_if_footer_is_missing)

if nargin < 2
  continue_if_footer_is_missing = false;
end
dlt.has_read_with_current_settings = false; % invalidate possible previously read data
% TODO: consider emptying dlt.XYT and other large arrays for memory reuse

if isempty(dlt.has_read_foot)
  % The footer's counters may allow pre-allocation of arrays for the body
  if continue_if_footer_is_missing
    try
      dlt.read_foot()
    catch e
      if strcmp(e.identifier, 'DLT:foot')
        warning('DLT:foot', e.message);
        % dlt.has_read_foot will be false in this case
      else
        rethrow(e);
      end
    end
  else % don't catch error
    dlt.read_foot()
  end
end

% Constants and some values cached to local variables in hope of slight
% speedup (not tested).
little_endian_machine = DLT.LITTLE_ENDIAN_MACHINE;
bin_power_16 = uint32(2^16);
bin_power_24 = uint32(2^24);
bin_power_24_signed = int32(2^24);
bin_power_23_signed = int32(2^23);
int32_one = int32(1);
uint32_one = uint32(1);
uint32_two = uint32(2);
uint32_three = uint32(3);
uint32_zero = uint32(0);
GROUP_MARKER = uint32(65280*bin_power_16); % 0xFF00 (though the second byte is not required but reserved for possible later use)
FOOTER_MARKER_as_U32 = typecast(DLT.FOOTER_MARKER, 'uint32');
if little_endian_machine % the typecast works according to the machine, but the big-endian (network byte order) should be used (altough the current marker is actually insensitive to order)
  FOOTER_MARKER_as_U32 = swapbytes(FOOTER_MARKER_as_U32);
end
assert(dlt.hardware_settings.number_of_channels >= 0, 'Must have a known number of channels');
number_of_channels = uint32(dlt.hardware_settings.number_of_channels);

detectors = dlt.detectors;
number_of_detectors = uint32(length(detectors));

if dlt.version < 2
  error('TODO: integrate version 1 or make it separately');
end

% Go to start of data
fseek(dlt.f, dlt.body_position, 'bof');

% buffer_size = uint32(1024); % number of U32-words to buffer. (Must be at least 4.)
buffer_size = uint32(1024*1024/4); % number of U32-words to buffer. (Must be at least 4.). This is 1 MB and was sufficient (larger is only marginally better).
% On Erwin, [2048 and 4096]*1024/4 seem slightly faster, on the small file with 'make empty'.
% global DEBUG_buf; buffer_size = round(DEBUG_buf) % DEBUG

file_position_of_buffer_start = ftell(dlt.f);
buffer = fread(dlt.f, buffer_size, '*uint32');
position = uint32(1); % the index to read from within the buffer


% To pre-allocate arrays (for performance) an estimate of the count is necessary.
% Reading cannot give more groups than there are in the file
preallocated_event_count = dlt.counters_foot.number_of_groups;
% (if empty were saved this is probably equal to dlt.counters_foot.number_of_start_triggings, otherwise less)
if ~dlt.readoption__keep_empty
  classes_saved = uint32(dlt.get(dlt, 'Classes saved'));
  if ~isempty(classes_saved)
    if bitand(DLT.GROUP_STATUS_BIT.lone_start_trigging, classes_saved) ~= 0
      % If empty groups should not be read, but were saved, the array length
      % estimate can be reduced (keeping an 1% margin to avoid reallocation in case of some deviation)
      preallocated_event_count = dlt.counters_foot.number_of_groups - 0.99*double(dlt.counters_foot.lone_start_triggings);
    % else: they were not saved, no reduction necessary
    end
  else
    if dlt.version >= 2 && dlt.counters_foot.lone_start_triggings < dlt.counters_foot.number_of_groups
      % Not clear whether empty groups were saved or not.
      % Not sure if this case will occur, but make an intermediate estimate.
      preallocated_event_count = dlt.counters_foot.number_of_groups - 0.5*double(dlt.counters_foot.lone_start_triggings);
      % May implement array growing or better estimate here if this case does occur.
      warning('DLT:body_length_estimate', 'Heuristic pre-allocation for DLT reading, because footer does not tell wether empty groups were saved in "%s"', dlt.filename);
    %elseif dlt.version >= 2: the counter values mean empty cannot have been saved.
    %else: In version 1 empty were probably never saved. Don't reduce.
    end
  end
end
if ~isnan(dlt.footer_position)
  file_size_estimate = dlt.footer_position;
else
  file_info = dir([dlt.directory filesep dlt.filename]);
  file_size_estimate = file_info.bytes;
end
if isnan(preallocated_event_count)
  % preallocated_event_count may be NaN if footer reading failed.
  % Make a guess based on file size
  % The denominator was between 25 and 81 in some example files.
  % A too small denominator wastes memory (but may be freeed after
  % reading finished). A too large denominator means reallocation will occur.
  preallocated_event_count = file_size_estimate / 40;
end
% A wild guess
preallocated_hit_count = 500 + preallocated_event_count * mean([1.75 0.5*dlt.hardware_settings.max_hits_per_channel]);
if dlt.counters_foot.number_of_accepted_DLD_hits > 0
   % Adjust towards the accepted count (for DLD detector) when file was saved
  preallocated_hit_count = ceil(mean([preallocated_hit_count dlt.counters_foot.number_of_accepted_DLD_hits]));
end

if uint32(preallocated_event_count) ~= preallocated_event_count
  error('Expected number of events (%g) is too large for current implemementation (32-bit indexing).', preallocated_event_count)
end
preallocated_event_count = uint32(preallocated_event_count);
if uint32(preallocated_hit_count) ~= preallocated_hit_count
  error('Expected number of hits (%g) is too large for current implemementation (32-bit indexing).', preallocated_hit_count)
end
preallocated_hit_count = uint32(preallocated_hit_count);
disp(sprintf('Info: Initial allocation for %d events and %d hits/detector', preallocated_event_count, preallocated_hit_count));

% Cache all dlt.-fields read as local variables --
% at least for arrays being modified it did speed up a lot.
f = dlt.f;
%time_unit = dlt.hardware_settings.time_unit*1E-9; %[s]
readoption__keep_empty = dlt.readoption__keep_empty;
readoption__keep_discarded = dlt.readoption__keep_discarded;
readoption__skip_contents = dlt.readoption__skip_contents;

if readoption__skip_contents
  preallocated_event_count = 0;
  preallocated_hit_count = 0;
  number_of_detectors = 0; %?
end
  

% Pre-allocate the big matrices for the "Untreated" data layer
discarded = zeros(number_of_detectors, preallocated_event_count, 'uint32'); % bitmask, SEE ALSO Detector.read_TDC_array (IMPROVEMENT: consider shrinking to U16 or U8, and/or merging with rescued if memory size/throughput becomes a concern)
rescued = zeros(number_of_detectors, preallocated_event_count, 'uint32'); % bitmask, SEE ALSO Detector.read_TDC_array
% Array index for the untreated hit arrays. Event e occupies XYT{d}(:,start_index(d,e):start_index(d,e+1)).
start_index = zeros(number_of_detectors, preallocated_event_count+1, 'uint32'); 
start_index(:,1) = 1; % initiate to start from array indices 1
XYT = cell(number_of_detectors,1); % One matrix of time data [s] per detector, SEE ALSO Detector.read_TDC_array
% The absolute_group_trigger_time is the time from hardware clock reset (acquisition start)
% to the group trigger [s]. For improved read performance the double floating point
% data is first stored as 2*unit32 values, then the cast is made at the end.
% This saves almost a millisecond of processing time per event.
absolute_group_trigger_time = zeros(2,preallocated_event_count,'uint32'); 

preallocated_event_count = uint32(preallocated_event_count); % IMPROVEMENT: use for smart array growth if needed
any_group_count = uint32(0); % number of groups read from file
event_count = uint32(0); % number of groups kept in arrays in memory



log_invalid = dlt.log_invalid; % DEBUG
global DLT_logged_invalid;
DLT_logged_invalid = struct('event',{}, 'detector',{}, 'channel',{}, 'value',{}, 'counts',{}, 'discarded',{}, 'rescued',{});
if log_invalid % preallocate a small array
  DLT_logged_invalid(1:16,1) = struct('event',0, 'detector',0, 'channel',[], 'value',[], 'counts',[], 'discarded',0, 'rescued',0);
end
DLT_logged_invalid_next_index = 1;

all_detectors_have_predefined_channels = true;
detector_channels_onebased = cell(size(detectors));
detector_without_predefined_channels = false(size(detectors));
detectors_as_structs = cell(size(detectors)); % Access to properties is faster in struct than in object!
detector_reader_functions = cell(size(detectors)); % Calling function handle is faster than calling method on object!
% Let each detector access info from the file header (e.g. hardware_info.time_unit)
% and cache it before the reading begins.
% For use below, the channel index array for each detector is cached.
for d = 1:number_of_detectors
  % Mark detector settings as current (will become false if detector is modified)
  % SEE ALSO dlt.is_untreated_layer_current()
  detectors{d}.clean_changes();
  
  if detectors{d}.has_XY()
    XYT{d} = NaN(3, preallocated_hit_count); % for 3D time data in units of [s]. Row-order: X;Y;TOF
  else
    XYT{d} = NaN(1, preallocated_hit_count); % for 1D time data in units of [s]
  end
  detectors{d}.initialize_reading(dlt); 
  detector_channels_onebased{d} = detectors{d}.channels_onebased;
  if isempty(detector_channels_onebased{d})
    % Unusual detector type, no pre-defined list of channels
    % (or wants to be called even for empty events)
    detector_without_predefined_channels(d) = true;
    all_detectors_have_predefined_channels = false;
  end
  
  warning off
  detectors_as_structs{d} = struct(detectors{d});
  warning on
%   detector_reader_functions{d} = eval(['@read_TDC_array__' class(detectors{d})]);
%   det = detectors{d}; detector_reader_functions{d} = @det.read_TDC_array; % DEBUG
end
accumarray_size_argument = [double(number_of_channels) 1];

while ~isempty(buffer)
  
  % The group shall begin with 0xFF, a reserved byte and U16 with number of
  % words in group.
  % Then least significant byte pair in the U32 (has been read as big-endian) are the group size
  group_length = rem(buffer(position), bin_power_16);
  group_marker = buffer(position) - group_length; %=idivide(buffer(position), bin_power_16, 'floor')*bin_power_16;
  % The reserved byte is currently always 0x00, so I require that for now.
  % Though it could become the first byte of a U24 to allow larger sizes in
  % some later program version, then this reader should be updated.

  if group_marker ~= GROUP_MARKER
    if all(buffer(position:(position+uint32_one)) == FOOTER_MARKER_as_U32)
      % Footer is reached. Successfully converted the entire file.
      %(no need to clear, not used after loop): buffer = [];
      if not(any(~isnan(dlt.footer_position)) && dlt.footer_position > 0)
        % Save the position where footer can be read later, to avoid need
        % to search (mainly useful for file format version 0 & 1).
        dlt.footer_position = file_position_of_buffer_start + 4*(position-uint32_one);
        % DEBUG: verify that this position becomes correct
      end
      break; % break the buffer loop
    else
      dlt.close(); % close the DLT file
      % IMPROVEMENT: if corrupt files become a problem, could implement
      % searching for the next GROUP_MARKER that gives a valid group.
      error('DLT:corrupt', 'Aborting reading due to invalid group after %d groups in "%s".', read_group_count, dlt.filename);
      return;
    end
  end

  % position is still the index of the start word, not incrementing until
  % reading also absolute group trigger time,
  % i.e. length(buffer) - position + 1 words remain from position to end of buffer.
  % However, there is no need to keep the start word (which has already been interpreted)
  % if a buffer-append has to be made. Thus the +1 is skipped and
  % position=0 will be used if an append is made.
  remaining_length = length(buffer) - position; % = length(buffer)-(position+1) + 1
  
  if uint32_three + group_length > remaining_length
    % This event extends to, or further than, the end of the buffer.
    % (Minimum group is three words long (2 remaining), but want to know following word too.)
    
%     disp([any_group_count, event_count, start_index(:,event_count)'])%DEBUG
    
    % Calculate where in file the appended buffer would start
    file_position_of_buffer_start = file_position_of_buffer_start + 4*(buffer_size - remaining_length);
    % Read more and append to buffer.
    % The kept buffer(position+1:end) is remaining_length long (except at end of file)
    buffer = [buffer(position+uint32_one:end); fread(f, buffer_size, '*uint32')];
    position = uint32_zero; % virtual position of the alrady interpreted start word, before start of buffer
    if length(buffer) < buffer_size
      if uint32_three + group_length > length(buffer) - position
        if ~dlt.has_read_foot
          warning('DLT:end_of_file', '%d groups (keeping %d) could be read before reaching the end DLT file %s that was not saved completely (missing footer).', any_group_count, event_count, dlt.filename);
        else
          warning('DLT:end_of_file', 'Unexpected end of file reached. %d groups (keeping %d) could be read before reaching the end DLT file %s. This is normal for incompletely written files (missing footer) but here the footer appears to have been read.', any_group_count, event_count, dlt.filename);
        end
        break; % abort the reading
      end
    end
  end
  
  if little_endian_machine
    %abs_t = typecast(buffer([position+uint32_two position+uint32_one]), 'double');
    abs_t_words = buffer([position+uint32_two position+uint32_one]);
    % This swapping is sufficient, the words being merged
    % have already been read with the correct byte order from file.
  else
    %abs_t = typecast(buffer([position+uint32_one position+uint32_two]), 'double');
    abs_t_words = buffer([position+uint32_one position+uint32_two]);
  end
  position = position + uint32_three; % step past marker and trigger time
  
  % IMPROVEMENT: prepare to handle special codes (error/message) from
  % abs_t_words (though not used by Labview yet).

  
  % TODO: ensure some pre-allocation for start_index and the per-detector data.
  % Can extrapolate for each array based on fraction of file size read thus far
  % new_length = ceil(current_length * 1.2 * max(1.2,file_size_estimate/(file_position_of_buffer_start+position)));
  
  any_group_count = any_group_count + uint32_one;
  if readoption__skip_contents
    % Ignore values within group!
    event_count = event_count + uint32_one;
    absolute_group_trigger_time(:,event_count) = abs_t_words;
    position = position + group_length;

  elseif group_length == uint32_zero && all_detectors_have_predefined_channels
    % No triggings in the group, and no special detector that wants to be given the empty hit list.
    if readoption__keep_empty
      % Update the start_index arrays only, with zero hits for each detector
      previous_start_index = start_index(:,event_count);
      event_count = event_count + uint32_one;
      start_index(:,event_count) = previous_start_index; % +0 hits on each
      
      absolute_group_trigger_time(:,event_count) = abs_t_words;
    % else: don't store in memory
    end
    
  else % Process the group

    possible_event_count = event_count + uint32_one; % writing to this position before deciding if event accepted or not, will be overwritten by other events (or TODO: clear at end otherwise)
    event_count_thereafter = possible_event_count + uint32_one; % the size is the increment to the index entry after possible_event_count

    accept = true;

    % Currently implementing direct writing to big XYT-array per detector,
    % before knowing if a later detectors discards the event.
    % Could check if IMPROVEMENT to first keep in a small array of the detectors
    % in current event, or even a special non-loop implementation when only one detector.
    
    % TODO test which is faster of these two options ("find my channels by detector" or "channel-expansion once for all")

    % BEGIN "find my channels by detector"
    % NOTE: assuming it is most efficient to split the words in array form, not once within eacah detector's .read_TDC_array()-call.
    buffer_part = buffer(position:(position+group_length-1));
%     value = rem(buffer_part, bin_power_24); % the final U24 of the word
%     channel = ((buffer_part - value) / bin_power_24) + uint32_one; % the first U8 from the word, 1-based channel index (unlike the 0-based used in LabView CAT program)
%     channel = ((buffer_part - rem(buffer_part, bin_power_24)) / bin_power_24) + uint32_one; % the first U8 from the word, 1-based channel index (unlike the 0-based used in LabView CAT program). Seems fastes, combined with bitshift(bitshift(,8),-8) for value below
    channel = bitshift(buffer_part, -24) + uint32_one; % the first U8 from the word, 1-based channel index (unlike the 0-based used in LabView CAT program). Though a single C-operation, not clearly faster than the rem()/ in Matlab.
      % channel = bitshift(buffer, -24) + int32_one; % if buffer is int32, 1-based ch>128 appear as int32(ch)-256 in the channel-array, which may be OK for now when those channels aren't used.

    % Convert from signed to unsigned value, I24 instead of U24.
    % If first bit is set, signed value is negative.
%     value = int32(value);
%     neg = value >= bin_power_23_signed;
%     value(neg) = value(neg) - bin_power_24_signed;
    % Alternative, but not clearly faster:
%     channel = bitshift(buffer_part, -24) + uint32_one; % the first U8 from the word, 1-based channel index (unlike the 0-based used in LabView CAT program)
    %value = bitshift(bitshift(int32(buffer_part),8),-8); % this (on int32) propagates the sign bit to get the desired effect. Fails if channel>=128
    %value = bitshift(int32(bitshift(buffer_part,8)),-8); % this (on int32) propagates the sign bit to get the desired effect. 15x faster than the logically indexed subtraction. Fails when buffer is uint32 rather than int32!
    value = bitshift(typecast(bitshift(buffer_part,8),'int32'),-8); % simple fix using typecast (probably slower, but should not use read_slow for performance anymore!)

    counts = accumarray(channel, 1, accumarray_size_argument); %(double) probably an efficient way to count how many triggings each channel has 

    for d = uint32_one:number_of_detectors
      if detector_without_predefined_channels(d) %if isempty(detector_channels_onebased{d})
        % Unusual detector type, no pre-defined list of channels
        % (or wants to be called even for empty events)
        error('Not supported while optimizing for normal detectors.');%[XYT_here, discarded_here, rescued_here] = detectors{d}.read_TDC_array(channel, value, counts);
      else
        % Normal detector type, for a pre-selected list of channels
        counts_selected = counts(detector_channels_onebased{d});
        if sum(counts_selected) == 0
          % Empty event for this detector. Optimize away the call, since
          % the detector will obviously return a valid but empty event.
          XYT_here = [];
          discarded_here = uint32_zero;
          rescued_here = uint32_zero;
        else
          % Non-empty event
          [XYT_here, discarded_here, rescued_here] = detectors{d}.read_TDC_array(channel, value, counts_selected); % normal
%           [XYT_here, discarded_here, rescued_here] = read_TDC_array(detectors{d}, channel, value, counts_selected); % uses same .m-file and gives same performance as normal method call, overloading by argument class.
          %DEBUG skip object orientation, this is faster: (a static function call gives same speed as function handle.)
%           [XYT_here, discarded_here, rescued_here] = detector_reader_functions{d}(detectors_as_structs{d}, channel, value, counts_selected);
%           [XYT_here, discarded_here, rescued_here] = detector_reader_functions{d}(channel, value, counts_selected); % using method handle, not needing first argument
%           [XYT_here, discarded_here, rescued_here] = read_TDC_array__DetDLD80(detectors_as_structs{d}, channel, value, counts_selected);
%           [XYT_here, discarded_here, rescued_here] = read_TDC_array__DetDLD80_static( channel, value, counts_selected); % Hardcoded local constants barely any improvement beyond read_TDC_array__DetDLD80 with parameters in struct.
        %DEBUG skip data loading, just use constant hit! Doubles the read rate.
%         XYT_here = [0.1;0.1;100E-9]; discarded_here = uint32_zero; rescued_here = uint32_zero;
          %DEBUG skip object orientation, 
        end
      end
      hit_count = size(XYT_here,2); % XYT_here should have three rows (TOF,T_X,T_Y) or one row (TOF). Not verified here.
      
      if log_invalid && (discarded_here ~= uint32_zero || rescued_here ~= uint32_zero) % DEBUG
        if length(DLT_logged_invalid) < DLT_logged_invalid_next_index
          % Grow array by doubling its size (not one element at a time)
          DLT_logged_invalid(end+1:(2*(DLT_logged_invalid_next_index-1))) = struct('event',0, 'detector',0, 'channel',[], 'value',[], 'counts',[], 'discarded',0, 'rescued',0);
        end
        % Note that possible_event_count may occur multiple times, if no accepted event occurs between two discarded events
        DLT_logged_invalid(DLT_logged_invalid_next_index,1) = struct('event',possible_event_count, 'detector',d, 'channel',channel, 'value',value, 'counts',counts, 'discarded',discarded_here, 'rescued',rescued_here);
        DLT_logged_invalid_next_index = DLT_logged_invalid_next_index + 1;
      end


      % Use the event if
      %  a) there was no problem,
      % or
      %  b) readoption__keep_discarded==true and the problem was only in exceeding
      %     a value limit (e.g. in x,y-radius or TOF anomaly). This means that at
      %     least one of the hits is considered having "unphysical" values.
      if discarded_here == uint32_zero || (readoption__keep_discarded && hit_count ~= 0)
        
        discarded(d,possible_event_count) = discarded_here;
        rescued(d,possible_event_count) = rescued_here;
        from = start_index(d,possible_event_count);
        next = from + uint32(hit_count);
        start_index(d,event_count_thereafter) = next;
        if next ~= from % If nonempty for this detector: copy hit data
          XYT{d}(:,from:(next - uint32_one)) = XYT_here;
        end
        % The indexing here auto-grows arrays by just the necessary amount if
        % preallocated_event_count or preallocated_hit_count were too small.
        % IMPROVEMENT: check if growing is necessary and grow by large amount
        % (assuming each reallocation is slow, as in most languages).
        
      else
        % This detector gave invalid data (and had the rescue_mode 'abort'
        % rather than 'make empty'). Then the entire event must be skipped.
        accept = false;
        break; % Break the loop without calling other detectors.
      end
    end
    % END "find my channels by detector"
    
%     % BEGIN "channel-expansion once for all"
%     while d <= number_of_detectors
%       [XYT_here(d), discarded_here(d), rescued_here(d)] = read_TDC_matrix(det, time_matrix, count_per_channel, little_endian_machine);
%       if 
%       end
%     end
%     % END "channel-expansion once for all"
%OLD, would need some of it for "channel-expansion once for all" 
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
%               value_signed = time_unit * (double(value) - bin_power_24_double);
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
%               channel_group_values{channel} = cell(max(event_count,preallocated_event_count),1); % pre-allocate
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
%               channel_hits(max(event_count,preallocated_event_count), max(channel,number_of_channels)) = uint16(0); % put a zero at large index to make Matlab reallocate to expected size already at first group
%               channel_hits(event_count,channel) = uint16_one; % Matlab pads other with zeros for unassigned elements.
%               
%               % Pre-allocate also the channel_values matrix
%               if readoption__values_in_nanoseconds
%                 % When using double as data type the padding can be NaN
%                 channel_values{channel} = NaN( max(event_count,preallocated_event_count), preallocated_hit_count, 'double');
%               else
%                 channel_values{channel} = zeros( max(event_count,preallocated_event_count), preallocated_hit_count, 'int32');
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
    
    % Should the event be kept?
    if accept
      event_count = possible_event_count;
      absolute_group_trigger_time(:,event_count) = abs_t_words;
    end
    position = position + group_length;
  end
  
end
dlt.f = f; % if a file handle is mutable it should be put back from cache, but probably it is not necessary

event_count = double(event_count); % return a double, since the counters_foot.number_of_groups (and other) counters have datatype double (due to initially holding NaN values)
dlt.event_count = event_count; % make easily accessible, instead of as length(dlt.absolute_group_trigger_time)

% Compare group count to expectation based on footer
% Shrink arrays/matrices to actual size
if size(start_index,2) > event_count+1
  if any(start_index(:,(event_count+2):end) ~= 0)
    error('(programming error) Would have truncated used start_index entries.'); % DEBUG
  end
  start_index(:,(event_count+2):end) = [];
end
if size(discarded,2) > event_count
  absolute_group_trigger_time(:,event_count+1:end) = [];
  rescued(:,event_count+1:end) = [];
  discarded(:,event_count+1:end) = [];
end
for d = 1:number_of_detectors
  if size(XYT{d},2) >= start_index(d,end)
    % The start_index(d,end) should be 1 greater than the used matrix size (where next event would start, if there was any)
    XYT{d}(:,start_index(d,end):end) = [];
  end
end
% if event_count < expected_event_count__initially && readoption__keep_empty && dlt.has_read_foot % didn't expect to get fewer than footer says
%   warning('DLT:event_count','Read & kept %d groups while %d expected in "%s"', event_count, expected_event_count__initially, dlt.filename)
% end
% elseif event_count > preallocated_event_count
%   disp(sprintf('Notice: read & kept %d groups while %d expected in "%s"', event_count, preallocated_event_count, dlt.filename))
% end
if dlt.readoption__skip_contents
  disp(sprintf('Info: Read %d groups. No events loaded, due to readoption__skip_contents.', any_group_count))
else
  disp(sprintf('Info: Read %d groups. Loaded %d events, containing %s hits.', any_group_count, event_count, mat2str(start_index(:,event_count+1)'-1)));
end

if log_invalid && length(DLT_logged_invalid) >= DLT_logged_invalid_next_index
  % Shrink array
  DLT_logged_invalid(DLT_logged_invalid_next_index:end) = [];
end

% Transfer from local variables to fields in the DLT instance
dlt.start_index = start_index; clear start_index
dlt.XYT = XYT; clear XYT
dlt.rescued = rescued; clear rescued
dlt.discarded = discarded; clear discarded
% Note: the cast was delayed to be performed as a batch operation, saves about 1ms per event
dlt.absolute_group_trigger_time = typecast(absolute_group_trigger_time(:),'double'); clear absolute_group_trigger_time

if isnan(dlt.counters_foot.number_of_groups)
  % In case the file was ended (broken) before footer,
  % let one counter tell the number of groups that could be read.
  dlt.counters_foot.number_of_groups = double(any_group_count);
end
if isnan(dlt.acquisition_duration) && ~dlt.has_read_foot
  % In case the file was ended (broken) before footer,
  % use last absolute group trigger time as substitute for duration.
  %dlt.acquisition_duration = abs_t;
  dlt.acquisition_duration = typecast(abs_t_words,'double');
  % Note, abs_t can be later than dlt.absolute_group_trigger_time(end)
  % if last group was empty and only non-empty werer kept when reading.
end

% Mark the loaded data as current
dlt.has_read_with_current_settings = true;
