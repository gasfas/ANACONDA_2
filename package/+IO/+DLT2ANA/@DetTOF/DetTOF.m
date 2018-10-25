classdef DetTOF < Detector
% A detector representing the usage of a single timing channel
% of the time-to-digital converter. Gives no X or Y coordinate.
%
% AUTHOR
%  Erik Månsson, 2010--2015, erik.mansson@sljus.lu.se, erik.mansson@ifn.cnr.it

  properties (Constant)
    % Single-channel detector
    min_number_of_channels = 1
    % Single-channel detector
    max_number_of_channels = 1
  end
  
  methods
    
    function det = DetTOF()
      % Construct a single-channel TOF detector, e.g. useable for an MCP or photodiode.
      % All parameters are set to their default values, e.g. the first channel is used.
      
      det.set_channels(1, 1);
    
      if length(det.rescue_mode_names) ~= 2
        error('The DetDLD80 constructor needs to be updated, due to changed number of default rescue mode names.')
      end
      % Extend the list of rescue modes
      det.rescue_mode_names{end+1} = 'skip incomplete hits / Rescue 1'; % index 3. TODO: implement based on the rescue algorithm in LabView (and document it)
    end
      
    function bool = has_XY(det)
      % Returns true, since the detector gives three-dimensional (TOF,T_X,T_Y) data.
      bool = false;
    end
    
  end
end