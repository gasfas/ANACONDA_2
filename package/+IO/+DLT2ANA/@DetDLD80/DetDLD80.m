classdef DetDLD80 < Detector
% A detector for the RoentDek DLD80 model of delay-line detectors
% with two axes (four timing channels).
      
  properties (SetAccess = private)
    
    % A DLD detector gives a time-difference T_X proportional to the x coordinate,
    % which is multiplied by signal_speed_x to obtain x in units of length
    % (not calibrated for centering).
    %
    % The LabVIEW CAT program has fixed _x=5.5E5 and _y=5.2E5 [m/s] but it is not
    % obvious that this is very accurate, since y/x tweaking is done in the momentum
    % converter. The RoentDek manuals say 1E-3m/1.9E-9s = 5.26315E5m/s is a typical value
    % (5% accuracy) and that X and Y differ. The above values are within that range,
    % but not quite symmetrically.
    signal_speed_x = 5.5E5; %[m/s] 
    signal_speed_y = 5.2E5; %[m/s]
    
    % Min value [s] for the "TOF anomaly", TOF_y - TOF-x,
    % where TOF_x = (T_X1+T_X2)/2 and TOF_y = (T_y1+T_y2)/2.
    % This is used to decide whether a hit is valid (i.e. for setting
    % the discarded status and within event rescuing algorithms).
    % 
    % The good TOF anomaly range is usually about 2 ns wide but the center
    % varies betwen set-ups. A calibration/choice should be made after each
    % time the DLD detector has been reconnected to the TDC card. 
    %
    % There is a small XY-dependance in the anomaly, so a very
    % tight range will skew the analyzed distributions, while a too wide range
    % will permit false "hits" with non-physical coordinates instead.
    %
    % SEE ALSO max_TOF_anomaly set_TOF_anomaly_range show_TOF_anomaly_histogram
    min_TOF_anomaly = -15E-9; %[s]
    
    % Max value [s] for the "TOF anomaly", TOF_y - TOF-x,
    % where TOF_x = (T_X1+T_X2)/2 and TOF_y = (T_y1+T_y2)/2.
    % SEE ALSO min_TOF_anomaly set_TOF_anomaly_range show_TOF_anomaly_histogram
    max_TOF_anomaly =  15E-9; %[s]
    
    % Max value for X^2+Y^2, where X = signal_speed_x * (T_X1-T_X2) etc.
    % This is used to decide whether a hit is valid (i.e. for setting
    % the discarded status and within event rescuing algorithms).
    % 
    % Discussion: It was deemed more physical to replace the max_pseudoradial_time
    % (~90ns in sqrt(T_X^2+T_Y^2) with an actual max_radius [mm] (about 41-45 mm)
    % where the differing signal velocities (picth factors) for X and Y are used,
    % so that the accepted data region becomes circular instead of elliptic.
    % This would require a bit more computation (thus slightly slower rescuing)
    % and be closely coupled to the conversion from T_X to X and T_Y to Y.
    % Thus it would make sense to simultaneously change the Untreated layer to hold
    % X and Y in units of position rather than nanoseconds. While this has the benefit
    % of making the untreated layer truly detector independent (the T_X to X calibration
    % is a property of the detector alone, not of the entire spectrometer)
    % but if this needs to be re-calibrated, the caching effect of the Untreated layer
    % disappears. Actually, the G_x and G_y signal speeds are not configurable
    % in the LabVIEW CAT program, a second tweaking of x/y ratio happens in the
    % momentum conversion. Conclusion: use real radius.
    % 
    max_radius_squared = 0.045^2; %[m^2]

    % (Auto-generated configuration for show_TOF_anomaly_histogram.)
    % SEE ALSO set_TOF_anomaly_range show_TOF_anomaly_histogram
    TOF_anomaly_histogram_bin_with_TU2 = int32(0); % disables logging
    % (Auto-generated configuration for show_TOF_anomaly_histogram.)
    % SEE ALSO set_TOF_anomaly_range show_TOF_anomaly_histogram
    TOF_anomaly_histogram_index_of_zero = int32(0);
    % The frequency data [count] for the TOF anomaly histogram,
    % if logging is enabled via DLT.log_anomaly_histogram before reading.
    % SEE ALSO set_TOF_anomaly_range show_TOF_anomaly_histogram
    TOF_anomaly_histogram = []; %[count]
    % The abscissa [s] for the TOF anomaly histogram,
    % if logging is enabled via DLT.log_anomaly_histogram before reading.
    % SEE ALSO set_TOF_anomaly_range show_TOF_anomaly_histogram
    TOF_anomaly_histogram_abscissa = []; %[s]
  end
  
  properties (Access=private)
    % Cached values in integer bin units (or a multiple thereof). Dependent on .time_unit.
    % NOTE: since NaN (which would discard all events) can not be stored in integer,
    % the empty range from -(2^31) to -(2^31) is used until updated by initialize_reading.
    min_TOF_anomaly_TU2 = int32(-2^31); % in units of [time_unit/2] (old comment said [2*time_unit], but seems inconsistent)
    max_TOF_anomaly_TU2 = int32(-2^31); % in units of [time_unit/2] (old comment said [2*time_unit], but seems inconsistent)
  end
  
  properties (Constant)
    % Four channels are required
    min_number_of_channels = 4
    % Four channels are required
    max_number_of_channels = 4
  end
  
  methods
    function det = DetDLD80()
      % Construct a detector for the RoentDek DLD80 model of delay-line detectors
      % with two axes (four timing channels).
      % All parameters are set to reasonable default values,
      % e.g. channels 1 to 4 (zero-based: 0 to 3) are used.
      
      % Default 4-by-1 channel array, in the order x1, x2, y1 and y2.
      % The indices are one-based i.e. the first channel has index 1
      det.set_channels(1, [1; 2; 3; 4]);
    
      if length(det.rescue_mode_names) ~= 2
        error('The DetDLD80 constructor needs to be updated, due to changed number of default rescue mode names.')
      end
      % Extend the list of rescue modes
      det.rescue_mode_names{end+1} = 'skip spurious triggings / Rescue alg.1'; % index 3. TODO: implement based on the rescue algorithm in LabView (and document it)
    end
      
    function bool = has_XY(det)
      % Returns true, since the detector gives three-dimensional (TOF,T_X,T_Y) data.
      bool = true;
    end
    
    function set_TOF_anomaly_range(det, min, max)
      % Set the min and max "TOF anomaly", TOF_y - TOF-x where TOF_x = (T_X1+T_X2)/2
      % and TOF_y = (T_y1+T_y2)/2. This is used to decide whether a hit is valid
      % (i.e. for setting the discarded status and within event rescuing algorithms).
      % 
      % The good TOF anomaly range is usually about 2 ns wide but the center
      % varies betwen set-ups. A calibration/choice should be made (e.g. using
      % show_TOF_anomaly_histogram()) after each time the DLD detector has been 
      % reconnected to the TDC card. There is a small XY-dependance in the anomaly,
      % so a very tight range will skew the analyzed distributions, while a too
      % wide range will permit false "hits" with non-physical coordinates instead.
      %
      % PARAMETERS
      %  min [s] The lowest permitted TOF anomaly.
      %  max [s] The highest permitted TOF anomaly.
      % SEE ALSO
      %  min_TOF_anomaly max_TOF_anomaly show_TOF_anomaly_histogram TOF_anomaly_histogram
      if min <= max
        det.min_TOF_anomaly = min;
        det.max_TOF_anomaly = max;
        if any(abs([min max]) > 1)
          warning('unreasonable_magnitude', 'Unusually large values were given for the TOF anomaly setting. Could they have been given in nanoseconds rather than seconds?\nGiven values correspond to the range %.3f to %.3f ns.', min/1E-9, max/1E-9);
        end
        det.changed = true; % Mark the instance as unclen, meaning Untreated data should to be re-read from file before 
      else
        error('invalid_argument', 'Min may not be greater than max.');
      end
    end
    
    function set_max_radius(det, max)
      % Max value for sqrt(X^2+Y^2), where X = signal_speed_x * (T_X1-T_X2) etc.
      % This is used to decide whether a hit is accepted (e.g. within event rescuing
      % algorithms).
      % PARAMETERS
      %  min [m]
      if max > 0
        det.max_radius_squared = max(1)^2;
        det.changed = true; % Mark the instance as unclen, meaning Untreated data should to be re-read from file before 
      else
        error('invalid_argument', 'Max radius must be greater than zero.');
      end
    end
    
    function set_signal_speed(det, v_x, v_y)
      % Set the signal propagation speeds to calibrate the position detection.
      %
      % IMPROVEMENT: Make an automatic calibrator that uses the background signal
      % of a loaded file, and the assumption that the MCP is circular,
      % to deduce the correct v_y/v_x ratio.
      %
      % PARAMETERS
      %  v_x [m/s] speed for the x-coordinate
      %  v_y [m/s] speed for the y-coordinate
      % SEE ALSO
      %  signal_speed_x
      det.signal_speed_x = v_x;
      det.signal_speed_y = v_y;
    end
    
    function initialize_reading(det, dlt)
      % This method is called on each detector after the DLT file header has been
      % read, but before the body data (raw TDC) is read.
      %
      % It can be used to cache some properties which are dependent on both
      % detector configuration and the file that is being read.
      %
      % PARAMETERS
      %  dlt Reference to the file reading instance of the DLT class.

      initialize_reading@Detector(det, dlt); % call base implementation, which sets det.time_unit
      
      % Cache int32 for tests in read_TDC_array
      det.min_TOF_anomaly_TU2 = int32(det.min_TOF_anomaly * 2/det.time_unit);
      det.max_TOF_anomaly_TU2 = int32(det.max_TOF_anomaly * 2/det.time_unit);
      
      if dlt.log_anomaly_histogram % determined by setting in DLT instance
        % Enable TOF anomaly histogram logging
        TOF_anomaly_histogram_bin_with = 0.1E-9;
        det.TOF_anomaly_histogram_bin_with_TU2 = int32(TOF_anomaly_histogram_bin_with * 2/det.time_unit); %TOF anomaly histogram bin width [time_unit/2]
        det.TOF_anomaly_histogram_index_of_zero = int32(25E-9 / 0.1E-9); %[histogram bins]
        det.TOF_anomaly_histogram = zeros(2*det.TOF_anomaly_histogram_index_of_zero-1, 1, 'double'); %[count] (can't use uint32 for accumarray)
        det.TOF_anomaly_histogram_abscissa = (double(det.TOF_anomaly_histogram_bin_with_TU2)*det.time_unit/2) * (double(-det.TOF_anomaly_histogram_index_of_zero+1:det.TOF_anomaly_histogram_index_of_zero-1))'; %[s]

        % IMPROVEMENT/NOTE: could implement another detector class which is similar to DetDLD80 except 
        % that it returns no XY information and returns the TOF_anomaly as TOF-value (for plotting by usual tools)

      else
        det.TOF_anomaly_histogram_bin_with_TU2 = int32(0); % disables logging
        det.TOF_anomaly_histogram_index_of_zero = int32(0);
        det.TOF_anomaly_histogram =  uint32([]);
        det.TOF_anomaly_histogram_abscissa = [];
      end
    end

    legend_handle = show_TOF_anomaly_histogram(det, dlt);
    
  end
end
