% Set the detectors to use for converting raw data to XYT in the untreated data layer.
%
% If the string 'auto' is given: Guess detector(s) based on the header information,
% e.g. a DetDLD80 for the first four channels and DetTOF for all other channels.
%
% PARAMETERS
%  detectors cell-array of instances of Detector-subclasses
%            or the string 'auto' (default).
% SEE ALSO detectors Detector DetDLD80 DetTOF
%
% AUTHOR
%  Erik Månsson, 2010--2015, erik.mansson@sljus.lu.se, erik.mansson@ifn.cnr.it
function set_detectors(dlt, detectors)
old = dlt.detectors;

if ischar(detectors) && strcmp(detectors, 'auto')
  % Guess detector configuration
  used_channels = 0;
  if dlt.hardware_settings.number_of_channels >= used_channels + 4
    % Add a DLD80 at channels 0 to 3, if possible
    det = DetDLD80();
    det.set_channels(0, 0:3);
    
    TOF_anomaly = [dlt.get(dlt, 'Min timing anomaly'), dlt.get(dlt, 'Max timing anomaly')] * 1E-9; %[s]
    if length(TOF_anomaly) == 2
      % Default to use same TOF anomaly setting as when recorded (since it varies from set-up to set-up)
      det.set_TOF_anomaly_range(TOF_anomaly(1), TOF_anomaly(2));
    end
    dlt.detectors = {det};
    used_channels = used_channels + 4;
  end
  while dlt.hardware_settings.number_of_channels > used_channels
    % Add single-channel detectors for the remaining channels
    det = DetTOF();
    det.set_channels(0, used_channels);
    dlt.detectors{end+1,1} = det;
    used_channels = used_channels + 1;
  end
 
% % This version only works if Detector < matlab.mixin.Heterogeneous, which is not used now
%elseif ~isa(detectors, 'Detector')
%    error('invalid_argument', 'Attemted to set detector array with objects which are not inheriting from the Detector class.')

else
  if ~iscell(detectors) % a single instance is given
    detectors = {detectors}; % ensure that cell
  end
  for i = 1:length(detectors)
    if ~isa(detectors{i}, 'Detector')
      error('invalid_argument', 'Attemted to set detector array with an object (or cell array containing object) that is not inheriting from the Detector class.')
    end
  end

  dlt.detectors = detectors;
end

% If data has been read, invalidate it if the detector list is changed.
if any(size(old) ~= size(dlt.detectors))
  dlt.has_read_with_current_settings = false;
else
  for d = 1:length(dlt.detectors)
    if not(old{d} == dlt.detectors{d})
      dlt.has_read_with_current_settings = false;
    end
  end
end

