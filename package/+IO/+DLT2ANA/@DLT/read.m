% Read all groups from the DLT file, to populate the "untreated" data layer.
%
% Each virtual Detector's basic calibration settings and rescue algorithm
% are used to convert raw data into events for the standardized
% "untreated" data layer in memory, where a hit consists of
% time-of-flight (TOF) [s], X [m] and Y [m] (or only TOF for some detector types).
%
% The hit coordinates in 3D (or 1D for such detectors) are produced and 
% concatenated to the propety XYT{d} of the DLT instance, where d is the
% index of the detector in DLT.detectors. This is done at least
% for accepted groups, but optionally (if Detectors support it) also for for
% groups that were discarded due to a value-anomaly rather than
% trigging-incompleteness (i.e. where hit data could be produced).
% 
% Whether discarded events (but complete/rescued enough to render some hit-like data)
% are kept in memory is determined by the .readoption__keep_discarded propety.
% Whether empty groups (no hit on any channel) are kept in memory is
% determined by the readoption__keep_empty propety in the DLT instance.
% Note that, an event is considered empty in this sense when no XYT hit was 
% produced by any detector, even if the group contained some trigging
% (e.g. on three of the four channels needed for a DetDLD80).
%
% The DLT propety arrays discarded, rescued, absolute_group_trigger_time and start_index
% have one entry (column) per event (group) kept in memory. The discarded and rescued
% furthermore have one row per Detector, so that any(discarded(:,e))==false
% tells whether the event at index e is accepted for use. For simplicity,
% the discarded_kept property tells whether any check needs to be made
% (false when no discarded event was kept in memory).
%
% The event at index e, 
% The part of the XYT matrix that belongs to the group at index g is
%
%   XYT(:, event_start(g):event_start(g+1)-1),
%
% i.e. the number of hits returned for the group is given by
%
%   event_start(g+1)-event_start(g).
%
% 
% This is variant with more vectorization and up to 100 times greater speed
% than DLT.read_slow. Arrays of all groups in a buffer block are prepared
% and given as a block to Detector instances, rather than one group at a time.
%
% PARAMETERS
%  continue_if_footer_is_missing (default: false)
%      If true, then an attempt to read is made even if the reading of
%      footer fails. The footer error message is printed but not returned.
%
% RETURN
%  event_count (double)   number of groups read
%
% SEE ALSO
%  set_rescue_mode
%  readoption__keep_empty
%  readoption__keep_discarded
%  Detector.read_TDC_vectorized_i1
%  DetDLD80
%  DetTOF
%  XYT
%  get_hit_count
%  get_loaded
%  is_loaded_data_current
function event_count = read(dlt, continue_if_footer_is_missing)
if nargin < 2
  continue_if_footer_is_missing = false;
end

dlt.has_read_with_current_settings = false; % invalidate possible previously read data

%% Check that required info is available

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
if ~isnan(dlt.footer_position)
  file_size_estimate = dlt.footer_position;
else
  file_info = dir([dlt.directory filesep dlt.filename]);
  file_size_estimate = file_info.bytes;
end

% Cache properties/fields as local variables, since access on objects is slow
number_of_channels = uint32(dlt.hardware_settings.number_of_channels);
detectors = dlt.detectors;
number_of_detectors = length(detectors);
readoption__keep_empty = dlt.readoption__keep_empty;
readoption__keep_discarded = dlt.readoption__keep_discarded;
readoption__skip_contents = dlt.readoption__skip_contents;
log_invalid = dlt.log_invalid;
f = dlt.f;

% Constants and some values cached to local variables in hope of slight speed-up (not tested).
little_endian_machine = DLT.LITTLE_ENDIAN_MACHINE;
int32_one = int32(1);
int32_two = int32(2);
uint32_zero = uint32(0);
uint32_one = uint32(1);
FOOTER_MARKER_as_I32 = typecast(DLT.FOOTER_MARKER, 'int32');
if little_endian_machine % the typecast works according to the machine, but the big-endian (network byte order) should be used (altough the current marker is actually insensitive to order)
  FOOTER_MARKER_as_I32 = swapbytes(FOOTER_MARKER_as_I32);
end
GROUP_START_BITMASK = int32(4294901760 - 2^32); % 0xFFFF0000
GROUP_START_VALUE   = int32(4278190080 - 2^32); % 0xFF000000

%% Pre-allocate arrays (for contingous memory and hopefully performance)

% Estimate of the number of groups
preallocated_event_count = dlt.counters_foot.number_of_groups; % Reading cannot give more groups than there are in the file
% NOTE: With the vectorized reader, it was found that Matlab's auto-growth on assignment
% of per-group matrices from a very small initial guess (10%) was as fast
% as allocating for max possible group count. (Suggests that the first part
% of the reading benefits from copying into smaller matrices.)
% On the web, this appears to be an optimization that works when columns but
% not rows are appended (due to matrix layout in memory), in Matlab2011 and later versions.
% Thus it is not really problematic if the guess here would be too small.
% Still, guides recommend preallocation and it gies a few percent better
% performance if the guess is exactly right so I'll keep the
% dlt.counters_foot.number_of_groups allocation except special treatment for empty events.
if ~readoption__keep_empty
  classes_saved = uint32(dlt.get('Classes saved'));
  if ~isempty(classes_saved)
    if bitand(DLT.GROUP_STATUS_BIT.lone_start_trigging, classes_saved) ~= 0
      % If empty groups should not be read, but were saved, the array length
      % estimate can be reduced (keeping an 1% margin to avoid reallocation in case of some deviation)
      preallocated_event_count = max(dlt.counters_foot.number_of_groups - 0.99*double(dlt.counters_foot.lone_start_triggings), 1E4);
    % else: they were not saved, no reduction necessary
    end
  else
    if dlt.version >= 2 && dlt.counters_foot.lone_start_triggings < dlt.counters_foot.number_of_groups
      % Not clear whether empty groups were saved or not.
      % Not sure if this case will occur, but make an intermediate estimate.
      preallocated_event_count = max(dlt.counters_foot.number_of_groups - 0.8*double(dlt.counters_foot.lone_start_triggings), 1E4);
      warning('DLT:body_length_estimate', 'Heuristic pre-allocation for DLT reading, because footer does not tell wether empty groups were saved in "%s"', dlt.filename);
    %elseif dlt.version >= 2: the counter values mean empty cannot have been saved.
    %else: In version 1 empty were probably never saved. Don't reduce.
    end
  end
end
if isnan(preallocated_event_count)
  % preallocated_event_count may be NaN if footer reading failed.
  % Make a guess based on file size
  % The denominator was between 25 and 81 in some example files.
  % A too small denominator wastes memory (but may be freeed after
  % reading finished).
  % A too large denominator means reallocation will occur, but Matlab's
  % auto-growth was found to be very quick in the vectorized reader so it is OK.  
  preallocated_event_count = max(file_size_estimate / 60, 1E4);
end

% Estimate the hit count (by a wild guess)
preallocated_hit_count = 500 + preallocated_event_count * mean([1 0.5*dlt.hardware_settings.max_hits_per_channel]);
preallocated_hit_count = repmat(preallocated_hit_count, 1, number_of_detectors);
detector_is_DLD_related = false(1, number_of_detectors);
for d = 1:number_of_detectors
  detector_is_DLD_related(d) = isa(detectors{d}, 'DetDLD80') || ~isempty(findstr(class(detectors{d}), 'DLD'));
end
if dlt.counters_foot.number_of_accepted_DLD_hits > 0
  % Was recording DLD-data.
  % Use 101% of the accepted count (for DLD detector) when file was saved
  preallocated_hit_count(detector_is_DLD_related) = max(1.01*dlt.counters_foot.number_of_accepted_DLD_hits, 1E4);
  % Lower guess for other detectors (auto-growth by Matlab is fast anyway if needed)  
  preallocated_hit_count(~detector_is_DLD_related) = max(0.05 * preallocated_hit_count(~detector_is_DLD_related), 1E4);
else
  % Zero accepted DLD hits suggests the non-DLD detectors have the main data.
  preallocated_hit_count(~detector_is_DLD_related) = max(1E4, mean([ ...
    preallocated_event_count * mean([1 0.5*dlt.hardware_settings.max_hits_per_channel]) ... % arbitrary guess
    (file_size_estimate/4-3*preallocated_event_count) / sum(~detector_is_DLD_related) % assume all words in file (minus group headers) are shared equally among the non-DLD detectors
    ]));
  % Lower guess for DLD-detectors
  preallocated_hit_count(detector_is_DLD_related) = max(0.05* preallocated_hit_count(detector_is_DLD_related), 1E4);
end

preallocated_event_count = round(preallocated_event_count);
if uint32(preallocated_event_count) ~= preallocated_event_count
  error('Expected number of events (%g) is too large for current implemementation (32-bit indexing).', preallocated_event_count)
end
preallocated_event_count = uint32(preallocated_event_count);
preallocated_hit_count = round(preallocated_hit_count);
if uint32(preallocated_hit_count) ~= preallocated_hit_count
  error('Expected number of hits (%s) is too large for current implemementation (32-bit indexing).', mat2str(preallocated_hit_count))
end
preallocated_hit_count = uint32(preallocated_hit_count);

if readoption__skip_contents
  % Don't make matrices for any detector-dependent data
  preallocated_hit_count = 0 * preallocated_hit_count;
  number_of_detectors = 0; %?
end
if isempty(number_of_channels) || not(number_of_channels >= 0)
  error('Must have a known number of channels.');
end

% Pre-allocate the big matrices for the "Untreated" data layer
disp(sprintf('Info: Initial allocation for %d events and %s hits/detector', preallocated_event_count, mat2str(preallocated_hit_count)));
discarded = zeros(number_of_detectors, preallocated_event_count, 'uint32'); % bitmask, SEE ALSO DLT.discarded
rescued = zeros(number_of_detectors, preallocated_event_count, 'uint32'); % bitmask, SEE ALSO DLT.rescued
% Array index for the untreated hit arrays. Event e occupies XYT{d}(:,start_index(d,e):start_index(d,e+1)-1).
start_index = zeros(number_of_detectors, preallocated_event_count+1, 'uint32'); 
start_index(:,1) = 1; % initiate to start from array indices 1
XYT = cell(number_of_detectors,1); % One matrix of time data [s] per detector, SEE ALSO DLT.XYT
absolute_group_trigger_time = NaN(1,preallocated_event_count); % if type cast to double is done for each buffer block
%absolute_group_trigger_time = zeros(2,preallocated_event_count,'uint32'); % if a single type cast to double after reading entire file

%% Prepare for reading


% TODO re-implement and DEBUG the discarded-logging capability
global DLT_logged_invalid;
DLT_logged_invalid = struct('event',{}, 'detector',{}, 'channel',{}, 'value',{}, 'counts',{}, 'discarded',{}, 'rescued',{});
if log_invalid % preallocate a small array
  DLT_logged_invalid(1:16,1) = struct('event',0, 'detector',0, 'channel',[], 'value',[], 'counts',[], 'discarded',0, 'rescued',0);
end
DLT_logged_invalid_next_index = 1;

% Let each detector access info from the file header (e.g. hardware_info.time_unit)
% and cache it before the reading begins.
for d = 1:number_of_detectors
  % Mark detector settings as current (will become false if detector is modified)
  % SEE ALSO DLT.is_untreated_layer_current()
  detectors{d}.clean_changes();
  
  if detectors{d}.has_XY()
    XYT{d} = NaN(3, preallocated_hit_count(d)); % for 3D position [m] and time [s] data. Row-order: X;Y;TOF
  else
    XYT{d} = NaN(1, preallocated_hit_count(d)); % for 1D time data in units of [s]
  end
  detectors{d}.initialize_reading(dlt); 
end

% Set the buffer size
% buffer_size = round(1024*1024/4); % number of U32-words to buffer. This is 1 MB and was sufficient before vectorization (larger is only marginally better).
buffer_size = round(400*1024/4); % this slightly smaller (near 2^16.5 words) buffer was slightly faster in the vectorized, regardless of settings, on Erik's windows-laptop (while non-vectorized reader preferred up to 10 times this size)
if buffer_size <= 2^16-1 + 3
 error('Buffer size should be at least 2^16 + 3 U32-words to ensure that a group of maximal length can be contained.')
end

% Go to start of data
fseek(f, dlt.body_position, 'bof');

any_group_count = uint32(0); % number of groups read from file
event_count = uint32(0); % number of groups kept in arrays in memory

if dlt.version < 2
  % disp(sprintf('Info: reading DLT version %d is not optimized for speed.');
  
  % Handle old version of file format, where only complete hite could be stored.
  % The group start marker is only two bytes, so groups are not 4-byte aligned.
  % a)   It would be possible to make a buffered reader with 2-byte words,
  %      then joining 2+2 bytes into 4-byte words for all the values (once per group).
  % b1)  Or simpler skip low-level buffering, read directly to different datatypes.
  % b2)  To benefit from possibility of calling Detector-instance with an array of groups,
  %      one could possibly buffer at this level (a fixed number of groups).
  % (Read-performance for this old file format version < 2 is not important.)
  
  GROUP_START_VALUE_v1   = uint16(255 * 2^8); % 0xFF00 = 65280
  
  % The first group is special: in DLTv.1 it is not preceeded by a GROUP_START_VALUE (0xFF).
  group_hitcount = uint16(fread(f, 1, '*uint8'));
  if group_hitcount == 0
    % (special case) There was no first group, the body is empty.
    if not(any(~isnan(dlt.footer_position)) && dlt.footer_position > 0)
      % Save the position where footer can be read later, to avoid need
      % to search (mainly useful for file format version 0 & 1).
      dlt.footer_position = ftell(f) - 1; % where the footer marker should start (not checking in this special case)
      disp(sprintf('Info: stopping at initially unknown footer marker %d bytes into "%s".', dlt.footer_position, dlt.filename));
    end
  end
  
  %% Read and process the file (old DLT version 0 or 1), a SINGLE group at a time
  max_groups_in_buffer = 1000; % anything above 100 seems OK
  while group_hitcount > 0
    
    index_here = 0;
    group_start = zeros(max_groups_in_buffer, 1, 'int32'); % preallocate
    value = []; % not preallocating value (unknown size)
    while group_hitcount > 0 && index_here < max_groups_in_buffer
      % Inner loop to buffer several groups before calling detectors
      % (as for version 2-reading, which the detector implementations are optimized for).
      index_here = index_here + 1; % iteration counter
      any_group_count = any_group_count + 1; % total group counter
      group_start(index_here) = length(value) + 1; % where this group starts in the concatenated value-array

      % The number of values to read within this group
      group_length = int32(group_hitcount * 4); 
      value = [value; fread(f, group_length, '*int32')];
      
      
      % Get header for of next group (or footer of this and header of next, to follow the DLTv.1 documentation's terminology)
      group_header = fread(f, 1, '*uint16'); 

      %%GROUP_START_BITMASK_v1 = uint16(255 * 2^8); % 0xFF00 -- the second byte is not reserved in DLTv.1, it holds the group size instead
      %%GROUP_START_VALUE_v1   = uint16(255 * 2^8); % 0xFF00
      % The check
      %   is_start = bitand(group_header,GROUP_START_BITMASK_v1) == GROUP_START_VALUE_v1;
      % can be simplified to
      %   is_start = group_header >= GROUP_START_VALUE_v1; % == group_header >= 0xFF00;

      group_hitcount = group_header - GROUP_START_VALUE_v1; % (unsigned datatype ==> 0 in case group_header < GROUP_START_VALUE_v1)
      if group_header > GROUP_START_VALUE_v1
        % There is a next group, with valid header.
        group_hitcount = group_header - GROUP_START_VALUE_v1;
        
      else
        % Invalid next group, because the last group has been read or because the file has a corruption.

        if group_header == GROUP_START_VALUE_v1
          % Valid group_header, next group_hitcount really is 0,
          % i.e. the last group has been read and the footer marker reached.
          footer_marker = [uint8(0); fread(f, 7, '*uint8')]; 
        else
          % When invalid group_header (first byte), don't even check whether the following bytes are a footer marker.
          footer_marker = uint8([]);
        end
        if length(footer_marker) == 8 && all(footer_marker == DLT.FOOTER_MARKER)
          % Footer is reached. Successfully converted the entire file.
          if not(any(~isnan(dlt.footer_position)) && dlt.footer_position > 0)
            % Save the position where footer can be read later, to avoid need
            % to search (mainly useful for file format version 0 & 1).
            dlt.footer_position = ftell(f) - 8; % where the footer marker started
            disp(sprintf('Info: stopping at initially unknown footer marker %d bytes into "%s".', dlt.footer_position, dlt.filename));
          end
          % Loop will stop since group_hitcount == 0
        else
          % Not valid end-marker for group, or "last" group not followed by valid footer marker.
          % There is something wrong with the file.
          dlt.close();
          % The events read up to previous block may be OK, but it is strange
          % that file is corrupted (bad data) rather than just truncated (missing footer),
          % thus currently raising error rather than using any of the file body contents.
          error('DLT:corrupt', 'Aborting reading due to invalid group after %d groups in file of DLT version %d, in block %d bytes into "%s". Is this a DLT file?', any_group_count, dlt.version, ftell(f), dlt.filename);
          % SEE ALSO comments after the next 'DLT:corrupt'-error.
        end
      end
    end
    group_start(index_here+1:end) = []; % trim the array to actual number of groups
    
    %% Now the values have been read for this block of buffered groups.

    if readoption__skip_contents
      % Ignore values within groups! Don't let Detector instances process the groups.
      event_count = any_group_count;% = event_count + length(group_start);
    else
      % Let detectors produce data for the untreated layer

      % The last three bytes in each 32-bit word should be interpreted
      % as a signed 24-bit integer (I24), and for useage in Matlab converted
      % to a 32-bit signed integer.
      value = bitshift(bitshift(value,8),-8); % correct for all I25 and channels if buffer is uint32  (?? since it is used, I guess the comment is flawed and that the algorithm is correct for int32 instead/too ??)
      % NOTE: in version 1 the first byte of each word was always zero.
      % The channel was deduced by the order instead (0,1,2,3, 0,1,2,3, 0,1,2,3 and so on ....).
      channel_token = repmat([0;1;2;3], length(value)/4, 1);

      is_start = false(length(value),1);
      is_start(group_start) = true;       % mark the indices where groups start
      is_last = [is_start(2:end); false]; % like is_start but marks last rather than first/start word in each group.
      is_last(end) = true; % since end of last group is not followed by an is_start
    
      % (Currently the rest of the processing is just like in the version-2 case, although there is only a single group here.)
      % TODO: Consider further simplifying here, using assumptions like only one detector
      
      % Prepare temporary variables for output from each detector in curent buffer block
      XYT_here = cell(1,number_of_detectors);
      event_start_here = zeros(number_of_detectors,length(group_start)+1);
      from_which_group = cell(1,number_of_detectors); % reverse-loopup (inverse) of event_start_here
      discarded_here = zeros(number_of_detectors,length(group_start),'uint32');
      rescued_here = zeros(number_of_detectors,length(group_start),'uint32');

      for d = 1:number_of_detectors
        [XYT_here{d}, event_start_here(d,:), discarded_here(d,:), rescued_here(d,:), from_which_group{d}] = detectors{d}.read_TDC_vectorized_i1(channel_token, value, is_last, is_start, []);
      end

      % Consider the discarded-status from all detectors, and check readoptions
      % to decide which groups to keep as loaded in the "untreated" data layer.
      if readoption__keep_discarded
        keep = true(1,length(group_start));
      else % don't keep the discarded events in memory
        keep = all(discarded_here == uint32_zero, 1);
      end
      if ~readoption__keep_empty
        keep = keep & any(diff(event_start_here,1,2) > 0,1);
      end
      % Since there is no separate event_length output (only event_start of next event),
      % the start indices must be updated to apply after non-kept groups of nonzero size have been removed.
      % The length of event_start_here is not reduced yet, but indices are
      % decremented by the accumulated number of non-kept hits before them.
      event_start_here(:,2:end) = event_start_here(:,2:end) - cumsum(diff(event_start_here,1,2) .* repmat(~keep, number_of_detectors,1),2);

      % Update the number of kept events, and indices for their per-hit data (XYT)
      event_count_here = sum(keep);
      start_event = event_count + uint32_one;
      event_count = event_count + event_count_here;
      start_index_here = start_index(:,start_event); % the index just after end of previously read XYT data, for each detector
      start_indices_thereafter = start_index_here; % for checking consistency with values based on event_start_here

      % Copy the per-hit data (XYT)
      for d = 1:number_of_detectors
        % Currently Detectors' read_TDC_vectorized_... may (but don't always)
        % return an extra (=0) element in from_which_group{d} so a 1:size(..) limitation is needed here.
        keep_hit = keep(from_which_group{d}(1:size(XYT_here{d},2)));

        % Empty events are not present in the XYT matrix or hit count
        hit_count_here = uint32(sum(keep_hit));
        start_indices_thereafter(d) = start_index_here(d) + hit_count_here;
        target = start_index_here(d):(start_indices_thereafter(d)-1);

        XYT_here{d}(:,~keep_hit) = []; XYT{d}(:,target) = XYT_here{d};
      end

      % Copy the per-event data
      target = start_event:event_count;
      discarded(:,target) = discarded_here(:,keep);
      rescued(:,target) = rescued_here(:,keep);
      for d = 1:number_of_detectors
        start_index(d,target) = (start_index_here(d)-1) + uint32(event_start_here(d,keep));
        start_index(d,event_count+1) = start_index_here(d)-1 + uint32(event_start_here(d,end));
      end

      % IMPROVEMENT (after doing it for version >= 2) implement some kind of storage of raw data for discarded (or all?) groups if dlt.log_invalid
    end


  end
  %% END reading for DLT-version < 2
  

else
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Main option: DLT version 2 (or higher).
  % Read and buffer data as 4-byte words (int32).

  remaining_words = floor((file_size_estimate - ftell(f)) / 4); %[4 bytes]
  % The reading is now limited so that it (if footer position is known)
  % won't actually read the FOOTER_MARKER, but terminates by getting an empty buffer.
  buffer = fread(f, min(buffer_size, remaining_words), '*int32');

  %% Read and process the file, one buffer block at a time
  while ~isempty(buffer)
    % All operations here are done vectorized, wasting some memory but probably speeding up:

    % Find where groups seem to start, by simply searching for group start
    % markers (0xFF, 0x00 in reserved byte, and two arbitrary bytes: 0xFF00????):
    is_start = bitand(buffer,GROUP_START_BITMASK) == GROUP_START_VALUE;
    % The reserved byte is currently always 0x00, so I require that for now.
    % Though it could become the first byte of a U24 to allow larger sizes in
    % some later file format version (then this reader should be updated).

    % The buffer should start with the start of a group (or footer marker),
    % so alignment is necessary when reading the next block.
    if ~is_start(1)
      % Not the start of a group
      buffer_position_in_file = ftell(f) - length(buffer)*4; %[bytes] 
      if length(buffer) < 2 || any(buffer(1:2) ~= FOOTER_MARKER_as_I32)
        % There is something wrong with the file.
        dlt.close();

        % The events read up to previous block may be OK, but it is strange
        % that file is corrupted (bad data) rather than just truncated (missing footer),
        % thus currently raising error rather than using any of the file body contents.
        error('DLT:corrupt', 'Aborting reading due to invalid group after %d groups, in block %d bytes into "%s". Is this a DLT file?', any_group_count, buffer_position_in_file, dlt.filename);
        % SEE ALSO comments after the next 'DLT:corrupt'-error.

      else % ==> buffer(1:2) == FOOTER_MARKER_as_U32
        % A valid footer marker was read into the buffer. This should only happen
        % if footer position wasn't known beforehand in file_size_estimate
        % (otherwise reading should stop before marker).
        % Footer is reached. Successfully converted the entire file.
        if not(any(~isnan(dlt.footer_position)) && dlt.footer_position > 0)
          % Save the position where footer can be read later, to avoid need
          % to search (mainly useful for file format version 0 & 1).
          disp(sprintf('Info: stopping at initially unknown footer marker %d bytes into "%s".', buffer_position_in_file, dlt.filename));
          dlt.footer_position = buffer_position_in_file; % DEBUG: verify that this position becomes correct for DLT.read_foot
        end
        break; % break the loop
      end
    end

    group_start = int32(find(is_start)); % Indices in buffer where groups possibly start
    % The two words just after a group start contain the double timestamp,
    % which may accidentally match the 0xFF00???? pattern of a group start.
    spacings = diff(group_start); % Between the possible group starts
    % Find certainly false starts (if two short groups in sequence, hide the
    % second false start until first fixed, as the next by disappear by consequence then)
    where = find(spacings <= 2 & [true; spacings(1:end-1)] > 2); 
    while ~isempty(where)
      % Fix these
      is_start(group_start(where+1)) = false;
      % Update and check again
      group_start = int32(find(is_start));
      spacings = diff(group_start);
      where = find(spacings <= 2 & [true; spacings(1:end-1)] > 2);
    end
    % Now the true group starts are known.

    % Do the splitting of 32-bit word into U8+I24 (channel+value) for entire buffer:
    % The first byte (U8) from the word is the 0-based channel (used directly in LabView CAT program).
    % here 1 is added to use Matlab-style 1-based channel indcices.
    % channel = bitshift(buffer, -24) + int32_one; % works if buffer is uint32
    % channel = bitshift(typecast(buffer,'uint32'), -24) + uint32_one; % works if buffer is int32, but typecast may slow down
    % channel = bitshift(buffer, -24) + int32_one; % if buffer is int32, 1-based ch>128 appear as int32(ch)-256 in the channel-array, which may be OK for now when those channels aren't used.
    channel_token = bitshift(buffer, -24); % No need to obtain human-readable channel, just need unique token to search for. 1-based ch<129 appears as ch-1 while 1-based ch>=129 appear as int32(ch)-257 in the channel-array

    % The following three bytes in each 32-bit word should be interpreted
    % as a signed 24-bit integer (I24), and for useage in Matlab converted
    % to a 32-bit signed integer. This conversion requires the sign-bit
    % to be propagated from bit 24 to bit 32, i.e. replace the channel-byte
    % by 0xFF for negative integers and 0x00 for non-negative.
    % After convertion to int32 the sign bit is propgated automatically upon negative shifts,
    % so shifting by +8 then -8 bits gives the desired effect (faster than other methods tested).
    %value = bitshift(int32(bitshift(buffer,8)),-8); % was used initially (works for channel>=0x80), but then found to turn all negative I24 into 0x007fffff
    % value = bitshift(bitshift(int32(buffer),8),-8); % correct for all I24, but fails for channel>=0x80 if buffer is uint32
    value = bitshift(bitshift(buffer,8),-8); % correct for all I25 and channels if buffer is uint32 (?? since it is used, I guess the comment is flawed and that the algorithm is correct for int32 instead/too ??)

    % The I24 value for group starts contains only the U16 group size since
    % 0x00 is currently required for the reserved byte after 0xFF in group start marker!
    group_length = value(group_start); 

    % Check that the found group sizes are consistent with group starts
    % (spacing in units of 32b words) should equal (group_length + 3)
    if any(spacings ~= (group_length(1:end-1) + 3))
      % If mismatch at index i: Could remove the "group" at index i+1 (and treat it as triggin on channel 255)
      % but DLT file format specification says channel=255 is not valid (as a
      % bit of redundancy check that only group_start words have 0xFF??????).
      error('DLT:corrupt', 'The DLT file appears to be correupted or using the invalid channel index 255. Group with channel=255 found around bytes %d to %d in file, after reading %d groups.', ftell(f)-length(buffer) + find(spacings ~= (group_length(1:end-1) + 3),2)', any_group_count);
      % IMPROVEMENT: could use continue_if_footer_is_missing or a second
      % option return_data_from_corrupt_file to break loop without error,
      % and return any data loaded prior to invalid part of file.
      % IMPROVEMENT: if mid-file corruption files become a problem, could
      % implement searching for the next GROUP_MARKER that gives a valid group
      % to resume with later parts of file.
    end

    % Check whether the last group start is completely buffered, or ends outside the buffered block.
    if group_start(end)+group_length(end)+2 > length(buffer)
      % It ends outside buffer. Discard that group from present block and re-read in next.
      is_start(group_start(end)) = false; % hide the incompletely buffered group (although buffer won't be shortened)
      group_start(end) = [];
      group_length(end) = [];
      if isempty(group_start)
        % The buffer wasn't even long enough to hold one group, thus the file ended unexpectedly.
        % (Note: If a buffer shorter than 3+2^16 bytes is used, this could also happen when a large group is reached.)
        if ~dlt.has_read_foot
          warning('DLT:end_of_file', '%d groups (keeping %d) at %d bytes could be read before reaching the end DLT file %s that was not saved completely (missing footer).', any_group_count, event_count, ftell(f)-length(buffer), dlt.filename);
        else
          warning('DLT:end_of_file', 'Unexpected end of file reached at %d bytes. %d groups (keeping %d) could be read before reaching the end DLT file %s. This is normal for incompletely written files (missing footer) but here the footer appears to have been read.', ftell(f)-length(buffer), any_group_count, event_count, dlt.filename);
        end
        break; % The events read up to previous block are still assumed to be OK, thus breaking loop rather than returning from function.
      end
    %else
      % Either the last group's end is pefectly aligned with the end of the buffer block
      % or the buffer contains non-group data at the end (i.e. FOOTER_MARKER or corruption).
      % Thus, it is safe to use group_start and group_length (not length(buffer))
      % in processing, and only need to check for FOOTER_MARKER at start of buffer blocks.
    end
    % Set file position to start next block just after the last complete group in present block
    % (if an incompletely read group was skipped above, it will be re-read in the next block).
    used_buffer_length = double(group_start(end)+group_length(end)+2);
    jump = used_buffer_length - length(buffer); %[words]
    if jump < 0
      % Make a negative jump if non-group words were read at end of block
      fseek(f, jump * 4, 0); % *4 to convert from U32-words to bytes
    elseif jump > 0
      error('Programming error, jump should never be positive.') %DEBUG
    end
    % Prepare for reading next block (though it won't be done until end of loop)
    remaining_words = remaining_words - used_buffer_length;

    % Groups are counted in any_group_count regardless of whether they will be kept in memory
    any_group_count = any_group_count + length(group_start);

    % Extract the two words that should be casted to a double, for absolute_group_trigger_time
    if little_endian_machine
      % This swapping is sufficient, the words being merged
      % have already been read with the correct byte order from file.
      abs_t = buffer([group_start'+int32_two; group_start'+int32_one]); abs_t = typecast(abs_t(:), 'double'); % using Matlab-builtin
      %abs_t = typecastx(buffer([group_start'+int32_two; group_start'+int32_one]), 'double'); % typecastx from Matlab File Exchange, MEX file compiled from C code
      % In the vectorized mode, typecastx is no longer faster than the built-in! (For average from 2^14 to 2^22 word buffer size, as well as for the best 2^16.5 words.)
    else
      abs_t = buffer([group_start'+int32_one; group_start'+int32_two]); abs_t = typecast(abs_t(:), 'double'); % using Matlab-builtin
      %abs_t = typecastx(buffer([group_start'+int32_one; group_start'+int32_two]), 'double'); % typecastx from Matlab File Exchange, MEX file compiled from C code
    end

    %% Now the groups, channels and values have been identified in this buffer block.

    if readoption__skip_contents
      % Ignore values within groups! Don't let Detector instances process the groups.
      % event_count is the last position used by previous blocks, any_group_count=event_count+length(group_start) will be the new end position
      absolute_group_trigger_time((event_count+1):any_group_count) = abs_t;
      event_count = any_group_count;% = event_count + length(group_start);
    else
      % Let detectors produce data for the untreated layer

      indices_to_ignore = [group_start+int32_one; group_start+int32_two; (used_buffer_length+1:length(buffer))'];
      is_last = [is_start(2:end); false]; % like is_start but marks last rather than first/start word in each group.
      is_last(used_buffer_length) = true; % since end of last group is not followed by an is_start
      % For i)alt5: value(indices_to_ignore) = []; channel(indices_to_ignore) = []; is_start(indices_to_ignore) = [];

      % Prepare temporary variables for output from each detector in current buffer block
      XYT_here = cell(1,number_of_detectors);
      event_start_here = zeros(number_of_detectors,length(group_start)+1);
      from_which_group = cell(1,number_of_detectors); % reverse-loopup (inverse) of event_start_here
      discarded_here = zeros(number_of_detectors,length(group_start),'uint32');
      rescued_here = zeros(number_of_detectors,length(group_start),'uint32');
      % IMPROVEMENT Could test performance of skipping the temporary variables (_here)
      % and writing per-group values directly to unfiltered global indices (target).
      % Then entries for all groups must be kept, so some memory will be wasted.

      for d = 1:number_of_detectors
        %  Implemented basics and testd performance of different organizations of TDC-readout (to event form). Good i) and iv) variants remain.
        % Vectorization "version i)"
        % Values kept in 1D array, to be extracted by channel-filter by Detector instance.
        % Benefit: avoids working on channels no Detector is using.
        % Disadvantage: if two Detectors use the same channels work is repeated, but this is not typical.
        % Test results: i)alt1 often fastest or near. i)alt5 is faster on files with many lone starts, but that is not typical.
        [XYT_here{d}, event_start_here(d,:), discarded_here(d,:), rescued_here(d,:), from_which_group{d}] = detectors{d}.read_TDC_vectorized_i1(channel_token, value, is_last, is_start, indices_to_ignore);
        %[XYT_here{d}, event_start_here(d,:), discarded_here(d,:), rescued_here(d,:), from_which_group{d}] = detectors{d}.read_TDC_vectorized_i5(channel_token, value, is_last); % for i)alt5
      end

      % Consider the discarded-status from all detectors, and check readoptions
      % to decide which groups to keep as loaded in the "untreated" data layer.

      if readoption__keep_discarded
        % NOTE: this option was once suggested for removal, but still implemented since it was easy.
        % Keep complete events and any XYT-hit returned by detectors in memory
        % even if marked as discarded due to coordinate-anomalies in some detector.
        % (A detector with rescue_mode 'make empty' will return zero hits
        %  rather than ever causing a group to be discarded.)
        keep = true(1,length(group_start));
      else % don't keep the discarded events in memory
        keep = all(discarded_here == uint32_zero, 1);
      end
      if ~readoption__keep_empty
        % The option readoption__keep_empty==false means that empty
        % events should not be counted as loaded and not be given entries
        % in the "untreated" layer.
        % Being empty is not a reason for marking as discarded (especially since
        % DLT.GROUP_STATUS_BIT.lone_start_trigging is defined as zero triggings
        % and "empty event" as zero XYT-hits produced by the configured detectors).
        keep = keep & any(diff(event_start_here,1,2) > 0,1);
      end

      % Since there is no separate event_length output (only event_start of next event),
      % the start indices must be updated to apply after non-kept groups of nonzero size have been removed.
      % The length of event_start_here is not reduced yet, but indices are
      % decremented by the accumulated number of non-kept hits before them.
      event_start_here(:,2:end) = event_start_here(:,2:end) - cumsum(diff(event_start_here,1,2) .* repmat(~keep, number_of_detectors,1),2);

      % Update the number of kept events, and indices for their per-hit data (XYT)
      event_count_here = sum(keep);
      start_event = event_count + uint32_one;
      event_count = event_count + event_count_here;
      start_index_here = start_index(:,start_event); % the index just after end of previously read XYT data, for each detector
      start_indices_thereafter = start_index_here; % for checking consistency with values based on event_start_here

      % Copy the per-hit data (XYT)
      for d = 1:number_of_detectors
        % Currently Detectors' read_TDC_vectorized_... may (but don't always)
        % return an extra (=0) element in from_which_group{d} so a 1:size(..) limitation is needed here.
        % IMPROVEMENT Could test performance of standardizing so detector should
        % or should not return array with an extra entry, then simplify the next
        % line to use either (1:end-1) or the full array.
        keep_hit = keep(from_which_group{d}(1:size(XYT_here{d},2)));

        % Empty events are not present in the XYT matrix or hit count
        hit_count_here = uint32(sum(keep_hit));
        start_indices_thereafter(d) = start_index_here(d) + hit_count_here;
        target = start_index_here(d):(start_indices_thereafter(d)-1);

        % if start_indices_thereafter(d)-1 > size(XYT{d},2)
          % A reallocation to extend the size of XYT will occur on the assignment
        % end
        XYT_here{d}(:,~keep_hit) = []; XYT{d}(:,target) = XYT_here{d};
      end

      % Copy the per-event data
      target = start_event:event_count;
      % if event_count > size(discarded,2)
        % A reallocation to extend the size of per-event matrices will occur on the assignment.
      % end
      discarded(:,target) = discarded_here(:,keep);
      rescued(:,target) = rescued_here(:,keep);
      absolute_group_trigger_time(target) = abs_t(keep);
      for d = 1:number_of_detectors
        start_index(d,target) = (start_index_here(d)-1) + uint32(event_start_here(d,keep));
        start_index(d,event_count+1) = start_index_here(d)-1 + uint32(event_start_here(d,end));
      end

      % Ensure that the first event_start_here was 1 from each detector (after update depending on which to keep), as assumed in the copying above
      if any(start_index(:,start_event) ~= start_index_here)
        error('Errorneous change of start_index for hit data when reading %d groups (keeping %d): \n%s'' has been changed from original %s''.\nThis indicates a programming error in Detector:read_TDC_vectorized, not returning 1 as first event_start.', ...
          any_group_count, event_count, mat2str(start_index(:,start_event)'), mat2str(start_index_here'));
      end
      % Verify consistency, i.e. that hit_count obtained via sum(keep(from_which_group{d})) agrees with event_start_here(d,end)-1.
      if any(start_index(:,event_count+1) ~= start_indices_thereafter)
        error('Inconsistent start_index for hit data after reading %d groups (keeping %d): \n%s'' differs from %s''.\nThis indicates a programming error in Detector:read_TDC_vectorized or DLT:read_vectorized.', ...
          any_group_count, event_count, mat2str(start_index(:,event_count+1)'), mat2str(start_indices_thereafter'));
      end

      % TODO: implement some kind of storage of raw data for discarded (or all?) groups if dlt.log_invalid
  %     From old for-loop per group, should try to vectorize into a local struct then append
  %       if log_invalid && (discarded_here ~= uint32_zero || rescued_here ~= uint32_zero) % DEBUG
  %         if length(DLT_logged_invalid) < DLT_logged_invalid_next_index
  %           % Grow array by doubling its size (not one element at a time)
  %           DLT_logged_invalid(end+1:(2*(DLT_logged_invalid_next_index-1))) = struct('event',0, 'detector',0, 'channel',[], 'value',[], 'counts',[], 'discarded',0, 'rescued',0);
  %         end
  %         % Note that possible_event_count may occur multiple times, if no accepted event occurs between two discarded events
  %         DLT_logged_invalid(DLT_logged_invalid_next_index,1) = struct('event',possible_event_count, 'detector',d, 'channel',channel, 'value',value, 'counts',counts, 'discarded',discarded_here, 'rescued',rescued_here);
  %         DLT_logged_invalid_next_index = DLT_logged_invalid_next_index + 1;
  %       end

    % NOTE: The DLT format has reseved some special cases to possibly contain
    % non-TDC data or error messages. None of this is implemented yet and thus only
    % mentioned here as interpretation of file format specification.
    % * The reserved byte between 0xFF-group start marker and two-byte group size:
    %   Allows any type of extension of the file format,
    %   most easily larger groups (i.e. including it in group size)
    %   but alternatively some (high) values could indicate that the 32bit-words
    %   in the group should not be handled in the usual channel-based (channel_U8,value_I24) way.
    %   With waveform digitizing detectors and single-shot-VMI-cameras in mind,
    %   treating this byte as part of the group size seems attractive
    %   (16 MB rather than 65 kB limit) but it also likely that such data would
    %   benefit from a different file format than DLT (e.g. with fixed group size).
    %
    % * abs_t: Negative values, NaN and -Inf are reserved for groups that were
    %   not initiated by the TDC-hardware, e.g. to contain only other info
    %   or error messages. For instance, automatic pressure or photon flux readout
    %   could be logged in such groups arbitrarily often throughout the file.
    %   The benefit of flagging by a special abs_t value (e.g. NaN if no time,
    %   or -time if availalbe from another clock) is that the data can be encoded
    %   in the full 32bit-words (if the readers are updated to disabled channel-based
    %   data handling when not(abs_t>0). A backwards-compatible variant is to
    %   use a non-TDC channel (e.g. 253 or 254) and encode the arbitrary data
    %   within the low 24-bits of each word.
    %
    %   abs_t=+Inf is not allowed in files, but it may be used in software to signal
    %   the end of a data stream (e.g. LabView FIFO buffers used to stream data to clients).
    %
    % * channel: 0-based 0 to 252 (1-based 1 to 253) are valid TDC-like channels,
    %   while 0-based 253 and 254 (1-based 254 to 255) are reserved to allow
    %   admixing other info (e.g. error messages) into a TDC-group.
    %
    %   Since those other types of info are not yet defined, there would be no
    %   problem to allow a 254-channel TDC-card. The file header should be given
    %   properties to tell what detector types are present, including the meaning
    %   of the highest channel-values. For the purposes of most programs,
    %   they can actually be seen as valid detector channels (also when abs_t>=0)
    %   and handled by Detector-subclasses that always return accepted event 
    %   but with zero XYT-hits handle/store the I24 data internally.
    %
    %   The 0-based channel 255 (1-based 256) is not allowed, to minimize the propability that
    %   other (properly aligned) 32b words than group start markers start with 0xFF.
    %   (Since version2, the two words for abs_t may also start with 0xFF, and even 0xFF00 occurs.)
    %   This is an old feature to allow "recovery" of a file where some storage medium
    %   error caused data in the middle to go missing (ignore inconsistent group and search for next consistent).
    %   Such recover searching was implemented in LabView and DLT_1and2_to_ANACONDA but
    %   although the type of file problem has probably never occurred. So it is not yet implemented in the Matlab reader.

    end

    % Read next buffer block.
    buffer = fread(f, min(buffer_size, remaining_words), '*int32');
  end
  
end %% END reading for DLT-version >= 2

dlt.f = f; % if a file handle is mutable it should be put back from cache, but probably it is not necessary
event_count = double(event_count); % return a double, since the counters_foot.number_of_groups (and other) counters have datatype double (due to initially holding NaN values)
dlt.event_count = event_count; % make easily accessible, instead of as length(dlt.absolute_group_trigger_time)

%% Reading is finished, make final checks and shrink pre-allocated matrix where needed

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
if log_invalid && length(DLT_logged_invalid) >= DLT_logged_invalid_next_index
  % Shrink array for logged invalid group data
  DLT_logged_invalid(DLT_logged_invalid_next_index:end) = [];
end

if readoption__skip_contents
  disp(sprintf('Info: Read %d groups. No events loaded, due to readoption__skip_contents.', any_group_count))
else
  disp(sprintf('Info: Read %d groups. Loaded %d events, containing %s hits.', any_group_count, event_count, mat2str(start_index(:,event_count+1)'-1)));
end

any_discarded = any(discarded(:));
if ~readoption__keep_discarded && any_discarded
  error('Some events are marked as discarded although readoption_keep_discarded was false. This indicates a programming error.');
end
% To let users know whether they need to check the discarded-status.
dlt.discarded_kept = any_discarded; 

%% Transfer from local variables to fields in the DLT instance
dlt.start_index = start_index; %clear start_index
dlt.XYT = XYT; %clear XYT
dlt.rescued = rescued; %clear rescued
dlt.discarded = discarded; %clear discarded
dlt.absolute_group_trigger_time = absolute_group_trigger_time;

if isnan(dlt.counters_foot.number_of_groups)
  % In case the file was ended (broken) before footer,
  % let one counter tell the number of groups that could be read.
  dlt.counters_foot.number_of_groups = double(any_group_count);
elseif double(any_group_count) ~= dlt.counters_foot.number_of_groups
  warning('DLT:count', '%d groups were read (though not necessarily kept in memory) but file footer says there should be %d groups.', any_group_count,dlt.counters_foot.number_of_groups)
end
if isnan(dlt.acquisition_duration) && ~dlt.has_read_foot
  % In case the file was ended (broken) before footer,
  % use last absolute group trigger time as substitute for duration.
  %dlt.acquisition_duration = abs_t;
  dlt.acquisition_duration = abs_t(end);
  % Note, abs_t can be later than dlt.absolute_group_trigger_time(end)
  % if last group was discarded (e.g. empty or invalid)
end

% Mark the loaded data as current
dlt.has_read_with_current_settings = true;
