classdef DLT < handle
% Class representing a DLT file.
%
% DLT (Delay-Line Times) files are created by the CAT (Coincident Acquisition of Times)
% acquisition software, implemented in LabView.
%
% To read a DLT file into Matlab (e.g. for an ANACONDA2 analysis program),
% construct an instance of this class, adjust its configuration as needed,
% and finally call the read() method.
%
% The data structures (see below) holding the loaded event and hit data are
% called the "untreated" data layer, to distinguish them from an anticipated
% higher layer for "analysis".
% TODO: implement analysis layer methods and structures, with tools for conversion
% of X,Y,TOF data into physical coordinates such as momentum or kinetic energy.
% It is not decided whether that layer will be handled by the DLT class or elsewhere.
% 
% This is a handle class, i.e. instances are mutable and not copied on
% assignment. Multiple references may point to the same instance.
%
% DLT Methods:
%  DLT            - construct DLT instance for a file and reads the header.
%  read_foot      - read the file footer, with comment, counters and additional properties.
%  read           - load the file's data into memory.
%  get            - access the arbitrary properties that header and footer may contain.
%  get_hit_count  - simplified access to hit count, after file has been read.
%  (Run 'doc DLT' for a complete listing.)
%
% DLT Propeties:
%  discarded                   - tells whether a loaded event is OK to use, one row per detector.
%  rescued                     - tells discarded-status before event was rescued (if it was), one row per detector.
%  start_index                 - tells which indices in XYT belong to each event, one row per detector.
%  XYT                         - the untreated, loaded 3D (or 1D) hit data, one cell entry per detector.
%  absolute_group_trigger_time - timestamp for each event (if DLT.version >= 2).
%  readoption__keep_empty      - allow events with zero hits in the untreated layer?
%  readoption__keep_discarded  - allow discarded events in the untreated layer?
%  readoption__skip_contents   - to keep nothing but absolute_group_trigger_time in the untreated layer.
%  discarded_kept              - false if no discarded event was loaded.
%  (Run 'doc DLT' for a complete listing.)
%
% EXAMPLE
%   dlt = DLT('example file.dlt');
%   dlt.read()
%
% AUTHOR
%  Erik Månsson, 2010--2015, erik.mansson@sljus.lu.se, erik.mansson@ifn.cnr.it
  properties (Access = private)
    f = []; % file handle (file identifier from fopen)
    body_position = NaN;
    footer_position = NaN; % cached for internal re-use after findig the footer the first time
  end
  
  %% Allowing properties to be read but not changed externally:
  % NOTE: see docsearch('Property Set and Get Access Methods') -- will be
  % called by set() and get(): function set.SomePropertyName(obj, value)
  % NOTE: to increase performance for frequently internally accessed properties,
  % local caching or a fully private property is necessary:
  % http://blogs.mathworks.com/loren/2012/03/26/considering-performance-in-object-oriented-matlab-code/
  properties (SetAccess = protected)
    % The non-directory part of the file's path.
    filename = '';
    % The path of the directory contaning the file.
    directory = '';
    % Version number for the DLT file.
    % NaN before header has been read.
    version = NaN;

    % If the extra content between header and body contais
    % UTF-8 text, that can be retrieved using
    %   matlab_string = native2unicode(uint8(dlt.extra_header_content), 'UTF-8');
    % Windows-1252 (single-byte encoding) text is instead given by
    %   matlab_string = char(dlt.extra_header_content);
    extra_header_content = '';
    
    % Timestamp for when acquisition into the file was started, as text.
    acquisition_start_str = '';
    % Timestamp for when acquisition into the file was started, as Matlab datenum 
    % (in units of days from year 0, UTC)
    acquisition_start_num = NaN; 
    % Timestamp for when acquisition into the file was ended, as text.
    acquisition_end_str = '';
    % Timestamp for when acquisition into the file was ended, as Matlab datenum
    % (in units of days from year 0, UTC)
    acquisition_end_num = '';
    % The time interval during which the file was acquired, in seconds.
    acquisition_duration = NaN;
    
    % Acquisition settings that must be present in the file header.
    % This is a struct with the fields
    %   number_of_channels
    %   trigger_channel__zerobased (the first channel is called 0 rather than 1)
    %   max_hits_per_channel       
    %   group_range_start          [s]
    %   group_range_end            [s]
    %   trigger_deadtime           [s]
    %   time_unit                  [s]
    hardware_settings;
    
    % Propety list from the header.
    % SEE ALSO get
    properties_head = struct('name',{}, 'value',{}, 'raw_type',{},'raw_bytes',{});
    % Propety list from the footer.
    % SEE ALSO get
    properties_foot = struct('name',{}, 'value',{}, 'raw_type',{},'raw_bytes',{});
    % Propety list from the footer, or head for propeies not present in footer.
    % SEE ALSO get
    properties_united = struct('name',{}, 'value',{}, 'raw_type',{},'raw_bytes',{});
    
    % Counters from file footer, for how groups were classified during acquisition.
    %
    % Reading the file with other settings (e.g. for allowed time anomalies or rescuing)
    % than were used when acquiring will most likely make the number of
    % accepted/discarded events and hits loade by read() differ from these counters.
    counters_foot = struct('number_of_groups',NaN, 'number_of_accepted_DLD_hits',NaN, 'number_of_start_triggings',NaN, 'lone_start_triggings',NaN, 'discarded_groups',NaN, 'discarded_complete_DLD_hits',NaN);
    
    % Text comment from the file footer.
    comment = '';
    
    % Status for attempt(s) to read the footer.
    % []=not attempted, false=failed, true=succeeded.
    % SEE ALSO read_foot
    has_read_foot = []; 
    
    % Column cell-array of Detector subclass-instances.
    % The detectors are an important part of the configuration for how raw data
    % is pre-process by the read() method into the "untreated" data layer.
    %
    % The DLT() constructor calls dlt.set_detectors('auto'); to initialize
    % a default configuration.
    %
    % SEE ALSO Detector DetDLD80 DetTOF read set_detectors
    detectors = {}; 
    
    % The number of events loaded into memory. Depends on detector settings
    % as well as the readoption__...-properties, and is less than or equal
    % to counters_foot.number_of_groups.
    %
    % This property is a part of the "untreated" data layer.
    % SEE ALSO read readoption__keep_empty readoption__keep_discarded readoption__skip_contents
    event_count = 0;
    
    % For file versions >= 2, the TDC8HP's absolute time of the group trigger
    % is available here (1-by-event_count),
    % in units of seconds and measured from the start of the
    % acquisition (approximately given by acquisition_start_str).
    %
    % This property is a part of the "untreated" data layer.
    % SEE ALSO read
    absolute_group_trigger_time = [];

    % Matrix with array-indices for the untreated hit arrays of each detector.
    % The hits from event e at detector d occupy
    %   dlt.XYT{d}(:, dlt.start_index(d,e):dlt.start_index(d,e+1)-1),
    % which may be an empty array.
    %
    % Currently the data type (uint32) is used, but (double) would be possible too.
    %
    % This property is a part of the "untreated" data layer.
    % SEE ALSO read XYT
    start_index = uint32([]); 
    
    % Cell array, having a matrix of time and (optionally) position data per detector.
    % Instead of reading from this data structure directly, get_loaded() may be used.
    %
    % For a 3D-detector d, the hit at global index i has its
    % uncalibrated x-position [m] in XYT{d}(1,i),
    % uncalibrated y-position [m] in XYT{d}(2,i), and
    % uncalibrated time-of-flight [s] in XYT{d}(end,i).
    % For a 1D-detector (TOF), the matrix only has the last row.
    % This ordering scheme makes the TOF information appear at row 3 or row 1
    % but always the last, and keeps the X;Y at index 1;2 for the untreated
    % data just like for p_X;p_Y;p_Z momentum data.
    %
    % NOTE: In the LabVIEW CAT-program, units of [ns] were used for all dimensions,
    % thus leaving the T_X to X scaling to the higher layers ("clients"). That seems
    % incorrect since the calibration it is detector- rather than analysis-dependent.
    %
    % This property is a part of the "untreated" data layer.
    % SEE ALSO start_index read get_loaded Detector.read_TDC_vectorized_i1
    XYT = {};
    
    % Bitmask (uint32) notifying why an event is discarded, one row per detector.
    %
    % The value is zero if the event was accepted.
    % See Detector.read_vectorized_i1 for the meaning of nonzero values,
    % which are a subset of those defined in DLT.GROUP_STATUS_BIT.
    %
    % If discarded_kept==true, it is important to check that
    %   any(discarded(:,e)) == false
    % before using the contents of the event at index e (e.g. for a diagram).
    % If discarded_kept==false, it is safe to skip the check, as no discarded
    % events were kept in memory. Whether discarded events are kept is
    % configured by readoption__keep_discarded.
    % 
    % If the event was rescued (or one of multiple problems was rescued),
    % the corresponding bit is non-zero in rescued and zero in discarded,
    % so the condition bitand(discarded, rescued) == 0 always holds.
    %
    % This property is a part of the "untreated" data layer.
    % SEE ALSO read rescued readoption_keep_discarded discarded_kept GROUP_STATUS_BIT Detector.read_vectorized_i1
    discarded = uint32([]); 
    
    % Tells whether there is a need to check whether any(discarded(:,event_index))
    % before using the event's data. If discarded_kept==false, then none of the
    % events kept in memory are discarded.
    %
    % This property is a part of the "untreated" data layer.
    %
    % SEE ALSO discarded readoption_keep_discarded
    discarded_kept = false;
    
    % Bitmask (uint32) notifying why an event was rescued, one row per detector.
    %
    % If the event was rescued (or one of multiple problems was rescued),
    % the corresponding bit is non-zero in rescued and zero in discarded,
    % so the condition bitand(discarded, rescued) == 0 always holds.
    %
    % See Detector.read_vectorized_i1 for the meaning of nonzero values,
    % which are a subset of those defined in DLT.GROUP_STATUS_BIT.
    %
    % This property is a part of the "untreated" data layer.
    % SEE ALSO read discarded GROUP_STATUS_BIT Detector.read_vectorized_i1
    rescued = uint32([]); 

    
    % String summary of the 'Classes saved' property (or hard-coded for version < 2),
    % based on the return-value of
    %
    %   get('Classes saved')
    %
    % SEE ALSO get GROUP_STATUS_BIT
    description_of_event_classes_saved = ''; 
  end
  
  %% Cached derived properties and metadata about whether a reloading is required
  properties (Access = protected)
    % (protected) Tells whether settings were changed after the current 
    % SEE ALSO is_loaded_data_current
    has_read_with_current_settings = false;
    
    % Cached result from DLT.from_which_event.
    % Cell array with one 1-by-H array per detector.
    % SEE ALSO from_which_event
    from_which_event__cached = {}; 
  end
  
  %% Public, writable
  properties
    % To allow loading the absolute_group_trigger_time of all groups
    % but not load the triggings/values they contain. This bypasses the
    % calls to Detector-instances, and means most matrices for the "untreated"
    % data layer will be empty.
    % SEE ALSO read
    readoption__skip_contents = false
   
    % Controls whether events where no hit is produced by any detector,
    % (after rescuing) should be kept as events in the "untreated" data layer.
    %
    % Note that, it is the XYT hit data that is considered, not whether
    % there were raw TDC triggings. (This differs from the definition of
    % DLT.GROUP_STATUS_BIT.lone_start_trigging.) Consequently:
    % * A group with triggings only on channels for which no Detector is 
    %   configured will be considered empty.
    % * A group with triggings on three of the four channels needed for a
    %   DetDLD80 will (without advanced rescuing) yield zero hits and be
    %   considered empty. It will also be marked as discarded due to incompleteness,
    %   so also readoption__keep_discarded==true would be needed to keep it.
    %
    % SEE ALSO read start_index readoption__keep_discarded XYT
    readoption__keep_empty = false
    
    % May the "untreated" data layer contain events marked as discarded?
    %
    % If readoption__keep_discarded==false, discarded events are ignored
    % and do not contribute to the event count.
    % If readoption__keep_discarded==true all events (except empty when readoption__keep_empty==false)
    % will remain in the loaded data structures.
    %
    % Perhaps the only use case for keeping discarded events would be when
    % testing different anomaly limits, which could then be performed by iterating
    % through events in memory and updating the discarded-status without re-reading file.
    % The DLT and detector classes don't yet have methods to support such
    % updates withot re-reading. Since re-reading became sufficiently fast
    % with the the vectorized reader, there is not much need for keeping
    % discarded events and it would be possible to remove this feature.
    % Trigging data from incomplete groups (before rescuing) can not be kept 
    % in the untreated layer, so DLT_log_invalid should anyway be used for 
    % getting full details of all discarded events.
    readoption__keep_discarded = false
   
    % If true, the raw TDC data for events that were discarded or rescued (per detector)
    % is stored to the global struct array DLT_logged_invalid.
    % TODO: not yet implemented for read, only for read_slow
    % SEE ALSO read_slow
    log_invalid = false;
    
    % If true, detectors that support it will log histogram(s) of some parameters
    % that affect whether complete groups are discarded, e.g. TOF_anomaly for DetDLD80.
    % SEE ALSO DetDLD80.show_TOF_anomaly_histogram
    log_anomaly_histogram = false;
  end
  
  properties (Constant = true) % Using the DLT class as global namespace to access these constants
    
    % (constant) The first zero in the FOOTER_MARKER also serves to end the data body (not a group)
    FOOTER_MARKER = uint8([0;0;0;0;254;254;254;254])

    % (constant) Is the program running on little-endian hardware?
    LITTLE_ENDIAN_MACHINE = typecast(uint8([0 0 0 1]), 'uint32') ~= 1
    
    % (constant) Bitmask constants for encoding the status of a group (event).
    % Used in the 'Classes saved' property for describing which subset of
    % acquired groups were written to the DLT file.
    % SEE ALSO get discarded rescued
    GROUP_STATUS_BIT = struct( ... 
      'discarded_but_complete', uint32(bin2dec('0001')), ... % discarded due to additional validity check, e.g. DLD timing anomaly
      'incomplete_group', uint32(bin2dec('0010')), ... % different number of hits on DLD channels
      'lone_start_trigging', uint32(bin2dec('0100')), ... % (without any hit, not even on non-DLD channel. Before 2011-09-08 only DLD channels were considered.)
      'outside_TOF_filter', uint32(bin2dec('1000')), ... % this bitmask is not set if there is no filter in use
      'rescued', uint32(bin2dec('10000')) ... % For a group: this has been rescued/recovered. Other status bits maintain their value to tell e.g. that the raw data was incomplete. For 'Classes saved' property: rescuing was active when acquiring. If the read data is not processed by (same) rescue algorithm, an incomplete group may occur although 'Classes saved' says incomplete groups were not saved.
      );
  end
  
  %% Public methods
  methods (Access = public)
    function dlt = DLT(filename)
      % Construct a DLT instance to handle the reading of a specific DLT file.
      %
      % The constructor calls read_head() to read the file's header.
      % and dlt.set_detectors('auto') to configure a default set of detectors.
      %
      % (NOTE: Writing to DLT files is not supported by this class.)
      %
      % PARAMETERS
      %   file_name  to read from
      % SEE ALSO read_head RegroupedDLT
      
      if nargin == 0
        % Called without filename argument. This is only allowed from subclasses
        % to create virtual datasets not exactly corresponding to one DLT file.
        % SEE ALSO RegroupedDLT
        if strcmp(class(dlt), 'DLT')
          error('No filename given.')
        else
          return; % called from subclass constructor
        end
      end
  
      [dlt.directory, f, e] = fileparts(filename);
      dlt.directory = [dlt.directory filesep()];
      dlt.filename = [f e];
      
      [dlt.f,message] = fopen([dlt.directory dlt.filename], 'r', 'b', 'UTF-8'); % big-endian mode
      if dlt.f == -1
        dlt.f = [];
        error('Failed to open DLT file "%s":\n%s', dlt.filename, message);
      end
      
      % Read the file header. May throw errors.
      dlt.read_head();
      
      % Set up a default configuration of detectors, based on the file header.
      dlt.set_detectors('auto');
    end
    
    function delete(dlt)
      % Destructor
      dlt.close();
    end
    
    function close(dlt)
      % Release the file handle.
      %
      % This may be caled when no more reding sohould be performed in a while.

      if ~isempty(dlt.f)
        fclose(dlt.f);
        dlt.f = [];
      end
    end
    
    function str = char(dlt)
      % Return short string representation of the DLT instance
  
      % Strip all but one level of directories away
      [~,parent_directory] = fileparts(fileparts(dlt.directory));
      if isempty(parent_directory)
        n = [parent_directory filesep dlt.filename];
      else
        n = dlt.filename;
      end
      acq_start = datestr(dlt.acquisition_start_num, 'yyyy-mm-dd HH:MM');
      str = sprintf('%s<%s; %s; %d loaded>', class(dlt), n, acq_start, dlt.event_count);
    end

    function [current] = is_loaded_data_current(dlt)
      % Tells whether data has been loaded by dlt.read() and is still current.
      % If the list of detectors or any detector's settings are altered after the
      % data was loaded, this function returns false.
      %
      % IMPROVEMENT NOTE: the coverage is not pefect, for instance the readoption_... are
      % properties which can be changed without affecting has_read_with_current_settings.
      
      current = dlt.has_read_with_current_settings;
      if current
        for d = 1:length(dlt.detectors)
          if dlt.detectors{d}.changed
            current = false;
            break;
          end
        end
      end
    end
    
    function drop_untreated_data(dlt)
      % Clear the arrays and matrices of the untreated data layer.
      % Currently, scalar values such as total event count remain set
      % so the object may appear inconsistent after this.
      %
      % This method may be useful to release memroy after a set of DLT
      % have been used used to construct a RegroupedDLT dataset and are
      % no longer needed.
      %
      % NOTE: this method supports array input, i.e.
      %   a = [dlt1 dlt2]; a.drop_untreated_data();
      % (but not cell arrays).
      % SEE ALSO RegroupedDLT
      
      for i = 1:numel(dlt)
        dlt(i).has_read_with_current_settings = false;
        dlt(i).close();
        
        dlt(i).start_index = zeros(size(dlt(i).start_index,1), 0, 'uint32');
        dlt(i).rescued     = zeros(size(dlt(i).rescued,1),     0, 'uint32');
        dlt(i).discarded   = zeros(size(dlt(i).discarded,1),   0, 'uint32');
        dlt(i).absolute_group_trigger_time = zeros(1, 0);
        for d = 1:length(dlt(i).XYT)
          dlt(i).XYT{d} = zeros(size(dlt(i).XYT{d},1), 0);
        end
        
        dlt.from_which_event__cached = [];
      end
    end
    
    %% The remaining methods are implemented in separate files. See documentation there.
 
    success = read_foot(dlt)
    [value, full_property, indices] = get(dlt, property_name, require_datatype, which_list, which_occurence)
    set_detectors(dlt, detectors);
    
    group_count  = read_slow(dlt, continue_if_footer_is_missing)
    group_count  = read(dlt, continue_if_footer_is_missing)
    % TODO: remove read_slow() when vectorized has taken over all functionaligy, e.g. loggging of discarded?

    [T, X_Y, event_index] = get_loaded(dlt, detector_index, event_index, hit_index, strict)
    [hit_count] = get_hit_count(dlt, detector_index, event_index)
    
    
    [from_which] = from_which_event(dlt, detector_index, lookup_hit_index);
    [figure_handle] = show_info_window(dlt, figure_handle);
  
  end

  methods (Access = private)
    % Read_head is called from constructor, no reason to have public
    read_head(dlt)
    % Properties in head and footer are read in the same way
    read_length = read_properties(dlt, from_where)
  end
  
  
  methods (Static = true)
    % IMPROVEMENT: could have conversion and merging routines here if
    % worth the effort of duplication the LabView program
    
    % To avoid duplicating date conversion code. Could be moved to a public general library,
    % or made private here since it is not a public purpose of the DLT class.
    [Matlab_datnum, timezone_seconds] = ISO8601_date_to_num(str);
  end
end