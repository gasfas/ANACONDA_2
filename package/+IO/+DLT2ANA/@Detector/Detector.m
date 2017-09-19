classdef (Abstract) Detector < handle % subclasses cannot be mixed in []-arrays, but in {}-cell arrays
% Common interface for all detector classes, which convert raw data
% from the DLT file into less device-dependent data in the "Untreated" layer.
% 
% This is a handle class, i.e. instances are mutable and not copied on
% assignment. Multiple references may point to one instance.
% TODO: evaluate whether immuable objects would be better, then DLT.set_detectors
% needs to be called to apply any change in detector settings. With mutable detector
% instances, each detector instead needs to keep "has changed"-flags to determine
% if changes invalidate old data stored the untreated layer or only the treated layer
% (e.g. if complete but discarded events are kept in memory and only the anomaly-limits are changed).

% NOTE: classdef (HandleCompatible) Detector < matlab.mixin.Heterogeneous % would allow mixing subclasses in []-array, but methods must be sealed and return same-sized results for this to be meaningful.


  % NOTE: while public SetAccess=private and the set.varname syntax for setter method
  % in Matlab class can be used (allowing object.varname=value for setting),
  % it is said to be slower for frequently reading methods than a private property
  % with a custom set_varname method.
  % http://blogs.mathworks.com/loren/2012/03/26/considering-performance-in-object-oriented-matlab-code/
  %    However, when testing in Matlab2013a the privatization did not seem to matter much,
  %    and reading via obj.varnme or obj.get_varname takes the same amount of time,
  %    (vectorization allowing operation on an array of objects however improves the NewCylinder example much,
  %    but it is not applicable to the detectors or events).
  % http://stackoverflow.com/questions/1693429/is-matlab-oop-slow-or-am-i-doing-something-wrong/1745686#1745686
  properties (SetAccess=private)
    % (N-by-1) array telling which channels to use,
    % The number of channels depends on the subclass. 
    % The indices are one-based i.e. the first channel has index 1
    % (unlike in the actual DLT file and the LabView CAT program,
    %  where the first hardware channel has index 0).
    % SEE ALSO set_channels channels_token
    channels_onebased = int32([]);

    % For internal use by DLT.read and Detector.read_TDC_vectorized_i1.
    % (N-by-1) array telling which channels to use, in the form they
    % are sent to Detector.read_TDC_vectorized_i1.
    %
    % To simplify readout of TDC time-values (signed) and channels (unsigned)
    % with minimal overhead (typecasts and math), the search for hits on a
    % given channel is performed using a more cryptic token than human-readable
    % channel index.
    % 
    % Currently channels_token = channels_onebased - 1, when channels_onebased <= 128
    %           channels_token = channels_onebased - 257, when channels_onebased >= 129
    %
    % SEE ALSO DLT.read set_channels channels_onebased Detector.read_TDC_vectorized_i1
    channels_token = int32([]);


    % The currently selected rescue mode index (uint32),
    % a one-based index into rescue_mode_names.
    % SEE ALSO
    %  set_rescue_mode
    rescue_mode = uint32(1); % 'no rescuing'
  end
  
  properties (SetAccess = protected) %(read-performance is not important for these)
    
    % Has any setting been changed since the last call to clean_changes()?
    %
    % Since Detector objects are implemented as mutable, settings can be changed
    % after the detector has already been used to read data from file to the
    % Untreated layer. When a change is made, changed is set to true so that
    % a re-read can be triggered when data from the Untreated layer is needed
    % (to not return outdated data).
    % SEE ALSO
    %  clean_changes
    changed = true;

    % Cell array of strings, where .rescue_mode is the index of the seleted mode.
    %
    % Default implementation: two available modes:
    %   'abort' if varying hit count on channels for this detector,
    %   don't allow the group to be used at all (even if other detectors OK).
    %   'make empty' if varying hit count on channels for this detector,
    %   then store as empty event (with incomplete-flag set in the rescued-bitmask).
    % Subclasses should implement these two modes as index 1 and 2,
    % and possibly additional modes.
    % For single-channel detectors, nothing needs to be done.
    %
    % SEE ALSO
    %  set_rescue_mode
    rescue_mode_names = {'abort', 'make empty'};
  end
  
  properties (SetAccess=private, GetAccess=protected)
    % Cached value from DLT.hardware_settings.time_unit [s]
    time_unit = NaN;
  end
  
  properties (Constant, Abstract)
    % The minimal number of channels, a constant of each subclass
    min_number_of_channels
    % The maximal number of channels, a constant of each subclass
    max_number_of_channels
  end
  
  methods (Abstract) % The interface methods, which subclasses need to implement
    % No constructor defined for the abstract base class
    
    % Returns true if the detector gives three-dimensional (TOF,X,Y) data
    % or false if the detector only gives TOF data.
    bool = has_XY(det)
    
    % Interpret triggings of the TDC (time-to-digigal) converter,
    % within each group group in a buffered block,
    % into device-independent TOF, X, Y coordinates (or only TOF).
    %
    % The number of groups given in the buffer block is
    %   G = sum(is_last) = sum(is_start).
    % This method parses all groups and determines which are discarded. Depending
    % on Detector.rescue_mode, initially invalid groups may sometimes be rescued
    % and thus not marked as discarded.
    %
    % The hit coordinates in 3D (or 1D for such detectors) are produced and 
    % concatenated to the XYT output. This is done at least for accepted groups,
    % but possibly also for for groups that were discarded due to a value-anomaly
    % rather than trigging-incompleteness (i.e. where hit data could be produced).
    % The part of the XYT matrix that belongs to the group at index g is
    %   XYT(:, event_start(g):event_start(g+1)-1),
    % i.e. the number of hits returned for the group is given by
    %   event_start(g+1)-event_start(g).
    %
    % For multi-detector configurations, DLT.read will consider the status returned
    % by each detector. If no detector discards a group, it will be accepted as an event.
    % One exception is that empty groups (with no hit from any detector) are rejected
    % and hidden from the group count if dlt.readoption__keep_empty==false.
    % The setting dlt.readoption__keep_discarded determines whether discarded groups
    % are kept in memory (with any invalid XYT-data returned) marked as discarded 
    % or completely rejected and hidden from the group count.
    % 
    %
    % PARAMETERS
    %  channel_token(int32) B-by-1 array with (approximatively) the zero-based
    %                       channel index of each trigging, interleaved by group start markers.
    %  value    (int32)     B-by-1 array with the raw (time) value of each trigging,
    %                       interleaved by group start markers.
    %  is_last  (logical)   B-by-1 array marking the last trigging in each group,
    %                       or the group start marker for empty groups.
    %  is_start (logical)   B-by-1 array marking each group start marker.
    %  indices_to_ignore (int32) I-by-1 array with the indices of the above arrays
    %                       that contain data for absolute_group_trigger_time instead of TDC-triggings.
    %                       These are the two indices following each group start marker. 
    %
    % PARAMETER DETAILS
    %  channel_token
    %    channel_onebased = channels_token + 1, when channels_token > 0.
    %    channel_onebased = channels_token + 257, when channels_token < 0.
    %
    %    channel_onebased from 1 to 253 are defined as valid channel
    %    indices for the DLT file format while 253 and 255 are reserved for possible
    %    future extensions (e.g. status/error codes or non-TDC data)
    %    and 256 is not allowed (interferes with the group-start marker
    %    used for a simple constraint that allows recovering a corrupted
    %    file where data from head/middle is missing).
    %
    %    Example: triggings on the fifth channel have channel_tokens==4,
    %    and all their time-values are found by value(channel_tokens==4).
    %
    %  value
    %    The time value of each trigging from a RoentDek TDC8HP
    %    is a 24 bit signed integer in units of det.time_unit.
    %    Here it has been converted into a 32 bit signed integer,
    %    so the high byte is either 0xFF (negative) or 0x00 (non-negative).
    %
    %    The raw words from the TDC-card (DLT-file) can be reconstructed
    %    as (2^24*(chanels-1) + value_unsigned).
    %    where value_unsigned = value if value >= 0, or value + 2^24 otherwise.
    %
    % RETURN
    %  XYT (double) 3-by-hit_count or 1-by-hit_count, matching has_XY().
    %      If has_XY() is true, the first row contains x-position [m]
    %      and the second row contains y-position [m].
    %      The last row, i.e. XYT(end,:), is always time-of-flight [s].
    %      Depending on has_XY() the last row is either row 1 or row 3.
    %      (Detectors that only give position are not implemented yet, they
    %      could either return two rows or put NaN at the third row.)
    %
    %  event_start      (double) 1-by-(G+1) array
    %      The part of the XYT matrix that belongs to the group at index g is
    %        XYT(:, event_start(g):event_start(g+1)-1),
    %      i.e. the number of hits returned for the group is given by
    %        event_start(g+1)-event_start(g).
    %      Note that this array has an entry at index G+1, to mark the end of the last group.
    %
    %  discarded        (uint32) 1-by-G 
    %      Bitmask with the following meanings
    %      1 'discarded_but_complete': discarded due to additional validity check,
    %              e.g. DLD timing anomaly or (x,y)-radius.
    %      2 'incomplete_group': different number of hits on DLD channels
    %      If extensions to other bits are made, they should be consistent
    %      with DLT.GROUP_STATUS_BIT (but not all flags defined there may be returned by this method).
    %
    %  rescued          (uint32) 1-by-G
    %      Bitmask with the same meanings as in discarded.
    %      If rescued~=0 then the problems marked by the nonzero bits existed but
    %      a re-analysis (dependent on rescue_mode) could produce a useable set of hits,
    %      and at least one bit in discarded has been cleared.
    % 
    %      If there were multiple problems, a rescue_mode algorithm can in principle
    %      rescue a serious problem ('incomplete_group') while leaving a mild problem
    %      e.g. hit outside allowed (x,y)-radius, thus returning discarded=1, rescued=2
    % 
    %      The condition bitand(discarded, rescued) == 0 always holds.
    %
    %  from_which_group (double) 1-by-hit_count, or 1-by-(hit_count+1) where last entry is ignored
    %      The reverse mapping of event_start, such that 
    %        all(from_which_group(event_start(g):event_start(g+1)-1) == g).
    %      Note that from_which_group is missing the info about empty groups,
    %      which is present in event_start.
    % 
    % SEE ALSO
    %  has_XY
    %  rescue_mode_name
    %  TDC.read
    %  read_TDC_vectorized_i5 -- an alternative implementation (requiring minor adjustment in TDC.read) where the first filtering step is done before Detector-methods are called.
    [XYT_here, event_start_here, discarded_here, rescued_here, from_which_group] = read_TDC_vectorized_i1(det, channel_token, value, is_last, is_start, indices_to_ignore)
    
    % NOTE: This is an alternative to read_TDC_vectorized_i1,
    % requiring minor changes in DLT.read. Currently the _i1 version's preformance
    % is preferred, but it is not always faster and the difference is often small.
    [XYT_here, event_start_here, discarded_here, rescued_here, from_which_group] = read_TDC_vectorized_i5(det, channel_token, value, is_last);

    % DEPRECATED: This version is used by DLT.read_slow, which is much slower than DLT.read.
    % 
    % Interpret triggings of the TDC (time-to-digigal) converter, within a group,
    % into device-independent TOF, X, Y coordinates (or only TOF).
    % 
    % SEE ALSO
    % read_TDC_vectorized_i1 for the replacement
    % read_TDC_array.m for full documentation
    [XYT, rescued, discarded] = read_TDC_array(det, channels, values, counts_selected)
    
    
    % TODO: add methods for serialization of settings to/from configuration file
    % TODO: add methods for controls in a settings GUI
  end
  
  methods
    function clean_changes(det)
      % Clear the changed-flag, to mark that the "Untreated" layer's data cache,
      % read with the current detector instance, is valid. If a detector
      % setting is later altered, changed=true will be set again.
      % SEE ALSO
      %  changed
      det.changed = false;
    end
    
    function set_channels(det, numbering_start, channel_ids)
      % Set which channels to use.
      % The required number of channels differs between implementations.
      %
      % PARAMETERS
      %  numbering_start 1 if the given indices are one-based (as mostly in Matlab),
      %                  i.e. the first channel that exists in hardware is 1.
      %                  The allowed range is 1 to 253 in this case.
      %                  0 if the given indices are one-based (as in DLT file-format and mostly in LabVIEW),
      %                  i.e. the first channel that exists in hardware is 0.
      %                  The allowed range is 0 to 252 in this case.
      %  channel_ids     An array with four channel indices, in the selected numbering system,
      %                  in the order x1, x2, y1 and y2.
      % SEE ALSO
      %  channels_onebased
      if numbering_start == 1
        % 1-based indexing (normal in Matlab, but not in the low-level DLT data)
        channel_ids = channel_ids - 1;
      elseif numbering_start ~= 0
        error('invalid_argument', 'Indexing must be zero-based or one-based.');
      end
      
      if any(channel_ids < 0 | channel_ids > 252)
        error('invalid_argument', 'Zero-based channel ids should be in the range 0 to 252, inclusive.');
      elseif length(channel_ids) < det.min_number_of_channels
        error('invalid_argument', 'At least %d channels must be selected.', det.min_number_of_channels);
      elseif length(channel_ids) > det.max_number_of_channels
        error('invalid_argument', 'At most %d channels may be selected.', det.max_number_of_channels);
      end
      if length(unique(channel_ids)) ~= length(channel_ids)
        warning('Detector:non_unique_channels', 'Some detector channel is used more than once for %s.', class(dlt));
      end
      %det.channels_zerobased = uint32(channel_ids(:));
      %det.channels_onebased = uint32(channel_ids(:) + 1); % Using uint32 would need a typecast from int32 buffer in DLT.read (or make correct treatment of negative I24 time-values more difficult)
      det.channels_onebased = int32(channel_ids(:) + 1); % Now using int32
      % To simplify handling of channels from int32, the typecast or addition
      % needed when channel_zerobased >= 128 (nonzero high bit in the byte)
      % is not performed while reading. The search for hits on a given channel
      % can be performed just as well using a more cryptic token, it is not
      % necessary to perform math to in DLT.read get human-readable channel index.
      det.channels_token = channel_ids(:); % like zero-based index
      det.channels_token(det.channels_onebased > 128) = det.channels_token(det.channels_onebased > 128) - 256; % subtract 256 where channel_ids(:)>=128

      det.changed = true; % Mark the instance as unclen, meaning Untreated data should to be re-read from file before 
    end

    function [index, name] = set_rescue_mode(det, rescue_mode)
      % Configure whether attempts should be made to rescue events where
      % some hit is invalid, either by being incomplete or by having some
      % numeric property out of the allowed range (anomaly).
      %
      % The implementation and the types of anomalities considered are
      % detector-dependent and may be configured by additional methods/attributes.
      % The supported modes for each detector class are listed in the
      % read-only attribute .rescue_mode_names.
      %
      % PARAMETERS
      %  rescue_mode (uint32 or string) The mode to select.
      % RETURNS
      %  index (uint32) The selected rescue_mode number.
      %  name (string) Name of the selected rescue mode.
      % SEE ALSO
      %  rescue_mode_names

      mode_list = sprintf('%d:''%s''', 1, det.rescue_mode_names{1});
      for index = 2:length(det.rescue_mode_names)
        mode_list = sprintf('%s, %d:''%s''', mode_list, index, det.rescue_mode_names{index});
      end
      if ischar(rescue_mode)
        index = uint32(find(strcmp(det.rescue_mode_names, rescue_mode)));
      elseif ~isnumeric(rescue_mode) || rescue_mode < 1 || rescue_mode > length(det.rescue_mode_names)
        index = [];
      else
        index = uint32(rescue_mode);
      end
      if length(index) ~= 1
        error('Detector:invalid_rescue_mode', 'Attempted to set unknown rescue_mode. %s supports the modes\n%s.', class(det), mode_list);
      end
      det.rescue_mode = index;
      name = det.rescue_mode_names{index};
      det.changed = true; % Mark the instance as unclen, meaning Untreated data should to be re-read from file before 
    end
    
    function [index, name] = get_rescue_mode(det)
      % Return the current rescue mode for this detector instance, as number and name.
      %
      % RETURNS
      %  index (uint32) The selected rescue_mode number.
      %  name (string) Name of the selected rescue mode.
      % SEE ALSO
      %  set_rescue_mode
      %  rescue_mode_names
      index = det.rescue_mode;
      name = det.rescue_mode_names{index};
    end
    
    function initialize_reading(det, dlt)
      % This method is called on each detector after the DLT file header has been
      % read, but before the body data (raw TDC) is read.
      %
      % It can be used to cache some properties which are dependent on both
      % detector configuration and the file that is being read.
      %
      % The base implementation copies dlt.hardware_settings.time_unit
      % to a field in the Detector instance, since these
      % values are normally needed to correctly handle the TDC data.
      %
      % PARAMETERS
      %  dlt Reference to the file reading instance of the DLT class.
      det.time_unit = dlt.hardware_settings.time_unit;
    end
    
    function str = char(det, style)
      % Return short string representation of the Detector instance.
      % PARAMETERS
      %  style   (optional, default 'medium')
      %          Controls the amount of information returned.
      %          'medium'    Full class name, channel and rescue mode.
      %          'short TeX' Omit details and return TeX-formatted string with channel as subscript.
      %          (more may be added...)
      if nargin < 2
        style = 'medium';
      end
      
      if length(det.channels_onebased(:)) > 1 && all(diff(det.channels_onebased(:)) == 1)
        % Consequtive channels
        ch = det.channels_onebased(:);
        ch = sprintf('%d-%d', ch(1), ch(end));
      else % Arbitrary channels, or just one
        ch = sprintf(',%d', det.channels_onebased(:)');
        if ~isempty(ch)
          ch = ch(2:end); % skip the first comma
        end
      end
      [~,m] = det.get_rescue_mode;

      switch style
        case 'short TeX'
          str = class(det);
          if length(str) > 3 && strcmp(str(1:3), 'Det')
            str = str(4:end); % shorten typical detector class names
          end
          if length(ch) == 1
            str = sprintf('%s_%s', str, ch); % can be shown TeX-formatted
          else
            str = sprintf('%s_{%s}', str, ch); % can be shown TeX-formatted
          end
        otherwise %& case 'medium'
          str = sprintf('%s<ch %s; %s>', class(det), ch, m);
      end
    end
  end
  
end