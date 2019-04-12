function [Matlab_datnum, timezone_seconds] = ISO8601_date_to_num(str)
%
% Convert extended ISO8601 date & time string (optionally with millisecond precision)
% with time zone, to a Matlab date number.
% PARAMETERS
%  str (String) the input date & time string
% RETURNS
%  Matlab_datnum    Matlab date number, i.e. days since year 0 (31 December year -1).
%                   Multiply by 86400 to get a time scale in units of seconds.
% timezone_seconds  The timezone-info of the input date
%
% AUTHOR
%  Erik M??nsson, 2010--2015, erik.mansson@sljus.lu.se, erik.mansson@ifn.cnr.itfunction [Matlab_datnum, timezone_seconds] = ISO8601_date_to_num(str)

try
  if length(str) == 28
    Matlab_datnum = datenum(str, 'yyyy-mm-ddTHH:MM:SS');
  elseif length(str) == 32
    if str(20) == ','
      % Handle incorrect locale setting for LabView when file was written: comma instead of period
      Matlab_datnum = datenum(str, 'yyyy-mm-ddTHH:MM:SS,FFF');
    else
      Matlab_datnum = datenum(str, 'yyyy-mm-ddTHH:MM:SS.FFF');
    end
  else
    error('Unexpected date string length.')
  end
catch e
  %error(sprintf('%s, for datetime "%s"', e.message, str), e);
  disp(sprintf('%s For string "%s".', e.message, str));
  rethrow(e);
end

timezone = datevec(str(end-7:end),'HH:MM:SS');
timezone_seconds = timezone(4:6) * [3600; 60; 1];
timezone = timezone_seconds / 86400; % convert to days
switch str(end-8)
  case '+'
    %do nothing
  case '-'
    timezone = -timezone;
  otherwise
    error('ISO8601_date_str_to_num:tz', 'Timezone format mismatch in "%s".', str)
end
% Subtract time zone to express time since year 0 in UTC and ease
% computation of acquisition duration.
Matlab_datnum = Matlab_datnum - timezone;
