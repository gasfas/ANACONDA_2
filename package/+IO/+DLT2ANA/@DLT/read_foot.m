% Read the DLT file footer.
% 
% To access propeties and counters from the footer, this method needs to be
% called first. If the footer has already been read successfully, it won't be
% re-read. This method will be called automatically by read() if needed.
% 
% For version 1 of the DLT file format, this method needs to perform a search
% backwards from the end of the file to find the footer. For version 2,
% the footer's start position is determined by information at the end of the file.
%
% If the acquisition program crashed while writing a file,
% its footer will be missing and this method will throw the error 'DLT:foot'.
% In that case, read(true) may be used to read as much event data as
% possible although the file is incorrectly terminated.
%
% AUTHOR
%  Erik Månsson, 2010--2015, erik.mansson@sljus.lu.se, erik.mansson@ifn.cnr.it
function success = read_foot(dlt)
%DLT.FOOTER_MARKER == uint8([0;0;0;0;254;254;254;254]); % the first zero in the FOOTER_MARKER also servest to end the data body (not a group)
assert(length(DLT.FOOTER_MARKER) == 8);

if isempty(dlt.version) || isnan(dlt.version) || ~isfinite(dlt.version)
  error('DLT:foot', 'Unknown file version %g in "%s".', dlt.version, dlt.filename);
end
if ~isempty(dlt.has_read_foot) % no need to try again
  success = dlt.has_read_foot; %return old success status
  return;
end
dlt.has_read_foot = false; % true if function returns without error

match = []; % true if footer start marker was found
if any(~isnan(dlt.footer_position)) && dlt.footer_position > 0
  % Jumpt to already known footer position
  fseek(dlt.f, dlt.footer_position, 'bof');
  footer_marker = fread(dlt.f, 8, '*uint8');
  match = false;
elseif dlt.version >= 2
  % Read footer position and jump to it
  fseek(dlt.f, -4, 'eof');
  footer_length = fread(dlt.f, 1, 'uint32');
  fseek(dlt.f, -footer_length, 'eof');
  footer_marker = fread(dlt.f, 8, '*uint8');
  match = false;
end

if ~isempty(match) % has read footer_marker: check it
  if length(footer_marker)==8 && all(footer_marker == DLT.FOOTER_MARKER)
    % OK footer found
    match = true;
  else
    error('DLT:foot', 'Failed to find footer in "%s".', dlt.filename)
  end

else %%%%%%%%%%%%%%%%%%%%%%%%
  
  % Version 1 (or 0, not really tested)
  % Need to search from end of file to find footer
  file_info = dir([dlt.directory filesep dlt.filename]);
  file_size = file_info.bytes;
  max_search = min([6400 file_size]); % To speed up error when no footer exists, don't search trough entire file. Most likely footer is smaller than 4 kB.
  search_area = min([400 max_search]);
  
  if dlt.version == 1 % version 1: contains two U32 more than version 0
    offset_to_string_marker = 8 + 6*4 + 28;
  else
    offset_to_string_marker = 8 + 4*4 + 28;
  end
  
  match = false;
  while search_area <= max_search && not(match) % For each search_area
    fseek(dlt.f, -search_area, 'eof');
    position = ftell(dlt.f);
    buffer = fread(dlt.f, search_area, 'uint8'); %read an array of bytes
    
    for i = 1:(size(buffer)-7) % For each byte
      if all(buffer(i:(i+7)) == DLT.FOOTER_MARKER)
        position_after_marker = position + (i-1) + 8;
        % Check that also the string terminator (0x00) in backward direction
        % and the '2' and '-' from YYYY-MM-DD... match.
        if buffer(i + offset_to_string_marker) == 0 ...
            && buffer(i + offset_to_string_marker - 28) == 50 ... % == int8('2')
            && buffer(i + offset_to_string_marker - 28+4) == 45 % == int8('-')
          % OK, the footer is (most likely) found.
          % TODO: DEBUG offsets
          fseek(dlt.f, position_after_marker, 'bof'); % prepare for reading footer contents
          match = true; % to break the outer loop (search_area) when footer found
          break; % break loop "each byte": has found footer
        end
      end
    end
    % search_area = search_area * 2;
    if search_area < max_search
      search_area = max_search; % no need to grow gradually, jump directly to maximum
    else
      break; % i.e. the loop will iterate at most twice
    end
  end
end

if match
  % Current position is after the footer marker, save its start in file
  % object to read quicker if done again (mainly for version 0 & 1)
  dlt.footer_position = ftell(dlt.f) - length(DLT.FOOTER_MARKER);
else
  error('DLT:foot', 'Failed to find footer in "%s".', dlt.filename)
end

% Start reading footer contents
counters = struct();
% Redundant, for integrity check of the body data:
counters.number_of_groups = fread(dlt.f, 1, 'uint32'); % The number of groups in the file, regardless of what they contain.
% Non-redundant, Statistics of what was detected during acquisition, but not necessarily saved to file. The filter-dependent values also depend on which timing anomaly limits were used.
counters.number_of_accepted_DLD_hits = fread(dlt.f, 1, 'uint32'); % filter-dependent
if dlt.version >= 1 % not in version 0
  counters.number_of_start_triggings = fread(dlt.f, 1, 'uint32');
else
  counters.number_of_start_triggings = NaN;
end
counters.lone_start_triggings = fread(dlt.f, 1, 'uint32');
counters.discarded_groups = fread(dlt.f, 1, 'uint32'); % filter-dependent
if dlt.version >= 1 % not in version 0
  counters.discarded_complete_DLD_hits = fread(dlt.f, 1, 'uint32'); % filter-dependent
else
  counters.discarded_complete_DLD_hits = NaN;
end
% Combining several counters also gives (?):
%   (Discarded events) = (Start triggings) - (Accepted events) - (Lone start triggings)
%   (Number of status-only groups) = (Groups) - (Start triggings)
dlt.counters_foot = counters;


if dlt.version >= 2
  dlt.acquisition_end_str = fread(dlt.f, 32, '*char*1')';
else
  dlt.acquisition_end_str = fread(dlt.f, 28, '*char*1')';
end
% Convert string and subtract time zone to get UTC datenum
try
dlt.acquisition_end_num = DLT.ISO8601_date_to_num(dlt.acquisition_end_str);
catch e
  if strcmp(e.identifier, 'ISO8601_date_str_to_num:tz')
    % Give more specific error message when error occurs in footer
    error('DLT:foot_date', 'Timezone format mismatch with "%s" in footer of "%s": .', dlt.acquisition_end_str, dlt.filename)
  else
    rethrow(e)
  end
end
dlt.acquisition_duration = (dlt.acquisition_end_num - dlt.acquisition_start_num) * 86400; % duration in seconds
% The scaling to and from datenum (day as unit) gives slight rounding error in the duration.
% Since the file format (v2) only has 1 ms precision, the duration is rounded here (to 0.1ms precision to possibly see any large error)
dlt.acquisition_duration = round(dlt.acquisition_duration*1E4)/1E4;

if dlt.acquisition_duration < 0
  warning('DLT:foot_duration', 'Negative duration %.4g s from %s to %s in "%s".', dlt.acquisition_duration, dlt.acquisition_start_str, dlt.acquisition_end_str, dlt.filename);
end

if dlt.version >= 2
  dlt.read_properties('foot');
  
  % Like DLT1and2_to_ANACONDA.m: make text description of the 'Classes saved' property.
  classes_mask = uint32(dlt.get(dlt, 'Classes saved', 'b'));
  if isempty(classes_mask)
    dlt.description_of_event_classes_saved = '?'; % in case the property is missing, which apparently is possible (How? Is it with v.1 client & v.2 server?)
  else
    classes_str = 'complete';
    if bitand(DLT.GROUP_STATUS_BIT.discarded_but_complete, classes_mask) ~= 0
      classes_str = [classes_str ', discarded but complete'];
    end
    if bitand(DLT.GROUP_STATUS_BIT.incomplete_group, classes_mask) ~= 0
      classes_str = [classes_str ', incomplete groups'];
    end
    if bitand(DLT.GROUP_STATUS_BIT.lone_start_trigging, classes_mask) ~= 0
      classes_str = [classes_str ', lone start triggings'];
    end
    if bitand(DLT.GROUP_STATUS_BIT.outside_TOF_filter, classes_mask) ~= 0
      classes_str = [classes_str ', outside TOF filter (if any)'];
    end
    if bitand(DLT.GROUP_STATUS_BIT.rescued, classes_mask) ~= 0
      classes_str = [classes_str ', rescued'];
    end
    dlt.description_of_event_classes_saved = sprintf('(b%s): %s.', dec2bin(classes_mask), classes_str);
  end
else
  dlt.description_of_event_classes_saved = 'Version 1: only complete events.';
end


if dlt.version >= 2
  % (There was a 0x00 before too, already read as end marker of the property list.)
  dlt.comment = fread(dlt.f, Inf, '*char')'; % (This reads UTF-8 encoding, specified when opening file.)

  % NOTE: Since UTF-8 encoding usd and set in call to fopen(), a limited
  % size to read will be specified in characters, not in bytes. Thus ftell & file
  % size does not tell what size to read, and we must use "Inf" size
  % (or read raw bytes to convert explicitly afterwards).
  % It seems the 0x00 and U32 at the end are kept as byte-characters although the reader expects & decodes UTF-8.
  if dlt.comment(end-4) == 0
    dlt.comment = dlt.comment(1:end-5); % skip the 0x00 at the end and the U32 footer length.
  elseif dlt.comment(end) == 0
    % (unexpected, but if only one zero appeared then skip that)
    dlt.comment = dlt.comment(1:end-1); % skip the 0x00 at the end.
  end
else
  zero_before = fread(dlt.f, 1, '*uint8')'; % Skip the 0x00 before string
  if zero_before ~= 0
    warning('DLT:foot_comment', 'Malformed footer: missed text-start marker, possibly failed to read comment text in "%s".', dlt.filename);
  end
  dlt.comment = fread(dlt.f, Inf, '*char')'; % (This reads UTF-8 encoding, specified when opening file.)
  if dlt.comment(end) == 0
    dlt.comment = dlt.comment(1:end-1); % skip the 0x00 at the end.
  end
end

%disp([dlt.footer_position dlt.footer_position-dlt.body_position]./ counters.number_of_groups)

dlt.has_read_foot = true; % done
