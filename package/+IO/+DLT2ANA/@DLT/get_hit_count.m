% Return the number of accepted hits on the selected detector in the selected event.
% 
% If the untreated data layer has not been populated, i.e. .read() has not been called,
% the method returns [] regardless of what parameters are used.
%
% PARAMETERS
%  detector_index  Which detector, 1-based indexing.
%                  Or ':' to return array with count for each detectors.
%  event_index     (optional, default: 0)
%                  Which event, 1-based indexing.
%                  If 0, return total number of loaded hits regardless of in which event.
%                  If [], return an array with count for each loaded event.
% RETURNS
%  hit_count (uint32) Column array if ':' is used as detector_index.
% EXAMPLES
%  dlt.get_hit_count(1, 5)   % (1-by-1) count for loaded event #5, on detector 1
%  dlt.get_hit_count(1, [])  % (1-by-E) count for each event, on detector 1
%  dlt.get_hit_count(1)      % (1-by-1) total count for detector 1
%  dlt.get_hit_count(':')    % (D-by-1) total count for each detector
%  dlt.get_hit_count(':',[]) % (D-by-E) count for each event, on each detector
% SEE ALSO
%  get_loaded read
%
% AUTHOR
%  Erik Månsson, 2010--2015, erik.mansson@sljus.lu.se, erik.mansson@ifn.cnr.itfunction [hit_count] = get_hit_count(dlt, detector_index, event_index)

if any(detector_index > length(dlt.detectors)) && not(ischar(detector_index) && detector_index == ':')
  error('Detector index out of range. Note that event_index is the second argument to dlt.get_hit_count().')
end
if isempty(dlt.start_index)
  % Hits haven't been loaded, need to call .read() and not have .readoption__skip_contents
  hit_count = [];
  return;
end

if nargin < 3
  event_index = 0;
end
  
if isempty(event_index)
  % Count for each event
  hit_count = dlt.start_index(detector_index,2:end) - dlt.start_index(detector_index,1:end-1);
  
elseif event_index == 0
  % Total count, regardless of event
  hit_count = dlt.start_index(detector_index,end) - dlt.start_index(detector_index,1);

else
  % One event
  hit_count = dlt.start_index(detector_index,event_index+1) - dlt.start_index(detector_index,event_index);
end