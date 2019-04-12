% Read the DLT file header. (This happens automatically in contsructor.)
%
% Throws error with identifier DLT:head in case of failure.
%
% Note that simulated files (not recorded from hardware) have bogus
% hardware_settings: number_of_channels=0, trigger_channel__zerobased=255, max_hits_per_channel=255
%
% If the extra content between header and body contais
% UTF-8 text, that can be retrieved using
%   matlab_string = native2unicode(uint8(dlt.extra_header_content), 'UTF-8');
% Windows-1252 (single-byte encoding) text is instead given by
%   matlab_string = char(dlt.extra_header_content);
%
% AUTHOR
%  Erik Månsson, 2010--2015, erik.mansson@sljus.lu.se, erik.mansson@ifn.cnr.it
%
function read_head(dlt)

fseek(dlt.f, 0, 'bof'); % Start from beginning

% Check file type identifier (magic number)
identifier = fread(dlt.f, 8, '*char*1')';
if not(strcmp(identifier, sprintf('=\x1ePsljus')))
  dlt.close();
  error('DLT:head', 'File is not of DLT format: "%s".', dlt.filename)
end
dlt.body_position = fread(dlt.f, 1, 'uint32');
extra_header_length = dlt.body_position - 71; % (v2 header before property list is 71 bytes long)

fseek(dlt.f, 4, 'cof'); % skip 4 bytes to determine if version <=1 or not
version_hint = fread(dlt.f, 1, '*char*1');
fseek(dlt.f, -5, 'cof'); % read those 4 bytes again with version-dependent interpretation
if version_hint == '-'
  % version 0 or 1 (start with date, where 4-byte year is followed by '-')
  dlt.acquisition_start_str = fread(dlt.f, 28, '*char*1')';
  %dlt.acquisition_start_num = datenum(dlt.acquisition_start_str, 'yyyy-mm-ddTHH:MM:SS');
  dlt.version = fread(dlt.f, 1, 'uint32')';
  if dlt.version > 1
    error('DLT:head', 'DLT1 version mismatch in "%s".', dlt.filename)
  end
  extra_header_length = extra_header_length + 4; % In version 0 and 1, the minimal header length was 67 instead of 71.
else % version >= 2
  dlt.version = fread(dlt.f, 1, 'uint32')';
  dlt.acquisition_start_str = fread(dlt.f, 32, '*char*1')'; % includes milliseconds
  %dlt.acquisition_start_num = datenum(dlt.acquisition_start_str, 'yyyy-mm-ddTHH:MM:SS.FFF');
  if dlt.version < 2
    error('DLT:head', 'DLT2 version mismatch in "%s".', dlt.filename)
  end
end

% timezone = datevec(dlt.acquisition_start_str(end-7:end),'HH:MM:SS');
% timezone = timezone(4:6) * [3600; 60; 1] / 86400; % convert to days
% switch dlt.acquisition_start_str(end-8)
%   case '+'
%     %do nothing
%   case '-'
%     timezone = -timezone;
%   otherwise
%     error('DLT:head', 'Timezone format mismatch in "%s".', dlt.filename)
% end
% % Subtract time zone to express time since year 0 in UTC and ease
% % computation of acquisition duration.
% dlt.acquisition_start_num = dlt.acquisition_start_num - timezone;


% % Add the DLT2ANA conversion to the MATLAB path, if it is not already:
% function_path = mfilename('fullpath');
% class_path = function_path(1:findstr(function_path, '+DLT2ANA')+length('+DLT2ANA'));
% if ~contains(path, class_path)
% 	addpath(class_path);
% end
% Convert string and subtract time zone to get UTC datenum
try
  dlt.acquisition_start_num = IO.DLT2ANA.DLT.ISO8601_date_to_num(dlt.acquisition_start_str);
catch e
  if strcmp(e.identifier, 'ISO8601_date_str_to_num:tz')
    % Give more specific error message when error occurs in header
    error('DLT:head_date', 'Timezone format mismatch with "%s" in header of "%s": .', dlt.acquisition_start_str, dlt.filename)
  else
    rethrow(e)
  end
end


%error('DLT:head', 'Failed to read header of DLT file "%s" due to ...', dlt.filename);

dlt.hardware_settings = struct();
dlt.hardware_settings.number_of_channels = fread(dlt.f, 1, 'uint8')';
dlt.hardware_settings.trigger_channel__zerobased = fread(dlt.f, 1, 'uint8')'; %(The first channel is called 0)
dlt.hardware_settings.max_hits_per_channel = fread(dlt.f, 1, 'uint8')';
% The times are expresed in nanoseconds:
dlt.hardware_settings.group_range_start = fread(dlt.f, 1, 'int32')' * 1E-9; %[s]
dlt.hardware_settings.group_range_end = fread(dlt.f, 1, 'int32')' * 1E-9; %[s]
dlt.hardware_settings.trigger_deadtime = fread(dlt.f, 1, 'int32')' * 1E-9; %[s]
if dlt.version == 0
  extra_header_length = extra_header_length + 8; % In version 0 the time unit was not part of the header (was fixed)
  dlt.hardware_settings.time_unit  = 0.025E-9; %[s]  
else
  dlt.hardware_settings.time_unit = fread(dlt.f, 1, 'double')' * 1E-9; %[s]
end
if abs(dlt.hardware_settings.time_unit - 2.5E-11) > 2*eps(2.5E-11)
  warning('DLT:head', 'Unexpected time unit for TDC8HP: %.6g s in "%s".', dlt.hardware_settings.time_unit, dlt.filename)
  % NOTE: if other hardware becomes supported in the future, additional
  % allowed values can be added, or the checked move to the Detector-class.
elseif dlt.hardware_settings.time_unit == (2.5E-11 + eps(2.5E-11))
  % The (0.025 ns) * (1E-9 ns/s) computation gives a difference in the last bit.
  % (0.025)*1E-9: 2.500000000000000414197920067270789444557888003828338696621358394622802734375E-11
  % 2.5E-11     : 2.50000000000000009108049328874435394791386766399909902247600257396697998046875E-11
  % It seems more correct to use the 2.5E-11 value without the accumulation of rounding errors caused by the unit change (multiplication)
  dlt.hardware_settings.time_unit = 2.5E-11; % [s]
end

position = ftell(dlt.f);
if position ~= dlt.body_position - extra_header_length
  error('DLT:head', 'Unexpected file position. Fixed header ended at %d instead of expected %d.', position, dlt.body_position - extra_header_length)
end

if dlt.version > 0
  read_length = dlt.read_properties('head');
  extra_header_length = extra_header_length - read_length;
end

% Read any remaining data before the dlt.body_position.
% See method comment for how to get string from it.
dlt.extra_header_content = fread(dlt.f, extra_header_length, '*uint8')';

position = ftell(dlt.f);
if position ~= dlt.body_position
  error('DLT:head', 'Unexpected file position. Header ended at %d instead of expected %d.', position, dlt.body_position)
end
