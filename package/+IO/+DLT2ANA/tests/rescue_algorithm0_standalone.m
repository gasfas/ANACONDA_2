% Reference implementation in Matlab of the original rescue algoritm ("skip spurious triggings / Rescue algorithm 0")
% by translation of the original implementation in lib_hits.llb/sub_RescueDiscardedEvent.vi.
%
% It is expected that minor modifications will be made in the version 1 ("skip spurious triggings / Rescue algorithm 1")
% to be implemented for the Matlab reader (Anaconda2), e.g. to have a limit for max_r [m] instead of max_t_r [ns] 
% and to change the cost function (increase the weight of TOF anomaly vs. radius).
%
% PARAMETERS
%  det       An instance of the DetDLD80 class, with the detector's parameters for min and max TOF anomaly.
%            (NOTE: this version 0 implementation does not use the max_r parameter.)
%
%  channels  (uint32) T-by-1 array with the one-based channel index of each trigging.
%            The conversion from zero-based index in the DLT file format
%            to one-based index is done to fit the convention in Matlab.
%            Values from 1 to 253 are defined as valid channel
%            indices for the DLT file format while 253 and 255 are reserved for possible
%            future extensions (e.g. status/error codes or non-TDC data)
%            and 256 is not allowed (interferes with the group-start marker
%            used for a simple constraint that allows recovering a corrupted
%            file where data from head/middle is missing).
%            Example: triggings on the fifth channel have channel==5,
%            and the time-values in values(channel==5).
%
%  values    (int32) T-by-1 array with the time value of each trigging.
%            24 bits, in units of det.time_unit.
%
% RETURNS
%  used_XYT      (double) 3-by-hit_count, must match result from has_XY().
%                The first row contains x-position [m]
%                and the second row contains y-position [m].
%                The last row, i.e. XYT(end,:), is always time-of-flight [s].
%  any_hit_in_rescued_group (boolean) = size(used_XYT,2) > 0
%
% AUTHOR
%  Erik Månsson, 2010--2015, erik.mansson@sljus.lu.se, erik.mansson@ifn.cnr.it
function [used_XYT, any_hit_in_rescued_group] = rescue_algorithm0_standalone(det, channels, values)

debug_trace = false;
debug_trace = true; % to print DEBUG info at important steps along the way


max_t_r_squared = 90E-9^2; %[s^2] (IMPROVEMENT: use actualy x,y data with axis-dependent propagation speed instead of t_r, if not much slower)
% Now assuming a range chosen symmetrically around peak, to not need an extra "nominal TOF_anomaly" setting.
TOF_anomaly_TU2_range_centre = int32((det.min_TOF_anomaly_TU2 + det.max_TOF_anomaly_TU2)/2)
TOF_anomaly_TU2_abs_max = int32((det.max_TOF_anomaly_TU2 - det.min_TOF_anomaly_TU2)/2)

% Define an array of triggings per channel (since they differ in lenth and this implementation is specific to a four-channel detector, using a matrix is not obviously helpful)
chs = det.channels_onebased; % cache
values_ch1 = values(channels==chs(1));
values_ch2 = values(channels==chs(2));
values_ch3 = values(channels==chs(3));
values_ch4 = values(channels==chs(4));
counts_per_channel = [length(values_ch1) length(values_ch2) length(values_ch3) length(values_ch4)];
max_depth = sum(counts_per_channel)

used_XYT = []; % for output X;Y;TOF data
base_indices = [0 0 0 0]; % A zero-based index per channel (four channels). Triggings before this index are already used by the extracted hits.
% (IMPROVEMENT: convert to one-based index in Matlab. Verify that same result.)
while true
  % Outer loop: "Get a hit"
  % Each iteration succeds in extracting a valid hit (the "first" remaining hit, ordered by a depth + cost measure),
  % or terminates the rescuing.

  % To achieve a depth-first search in a simple way, an inner loop is used to traverse all index combinations in "numerical" order
  % but only the ones at the desired_depth are actually evaluated.
  % When the transversal at the current desired_depth is completed:
  %  a) if any index-combination at the desired_depth gave a valid hit, use the combination that gave a hit with the lowest cost-value and break the inner loop.
  %     The outer loop will then attempt to extract further hits using the triggings AFTER the ones already used.
  %     IMPROVEMENT NOTE: To not consider the previously skipped triggings BEFORE/BETWEEN the previously extracted hits is
  %     a non-essential restriction -- this algorithm will fail to find some "overlapping" hits at nearly identical TOF.
  %  b) if the maximum depth is reached: terminate the search
  %  c) otherwise, increase desired_depth and continue inner loop.

  desired_depth = sum(base_indices);
  current_indices = base_indices;
  best_cost = Inf; % will be <Inf if any valid hit is found
  best_indices = NaN(1,4);
  best_XYT = NaN(3,1);
  break_inner = false;
  if debug_trace
    desired_depth
  end
  while ~break_inner
    % Inner loop: "Evaluate index-combinations, in a depth-first order"
    
    if (sum(current_indices) == desired_depth)
      % The current index-combination should be evaluated
      if debug_trace
        disp(current_indices)
      end

      t_x2x1 = [values_ch2(1+current_indices(2)) values_ch1(1+current_indices(1))]; %[raw time units]
      t_y2y1 = [values_ch4(1+current_indices(4)) values_ch3(1+current_indices(3))]; %[raw time units]
      t_r_squared = double(diff(t_x2x1).^2 + diff(t_y2y1).^2) * det.time_unit^2; %[s^2]
      TOF_anomaly_TU2_abs = abs( sum(t_y2y1)-sum(t_x2x1) - TOF_anomaly_TU2_range_centre ); % (y1+y2)-(x1+x2)-TOF_anomaly_TU2_range_centre, in 0.5*hardware bin units [det.time_unit/2]

      % Does the current index choice give a valid hit? And how good is it (low cost)?
      valid = t_r_squared < max_t_r_squared && TOF_anomaly_TU2_abs <= TOF_anomaly_TU2_abs_max;	
      cost = t_r_squared + double(TOF_anomaly_TU2_abs)*det.time_unit/2; % the ad-hoc cost function [unit-mismatch, i.e. now in ns^2 for t_r^2 and ns for the TOF anomaly]
      % TODO IMPROVEMENT: It seems the weight of TOF_anomaly (valid range: a few ns) should to be increased versus t_r^2 (valid range 80^2),
      % to prefer correct matching of hits even when their radial coordinate happens to be large.
      % Could use parameters consistently squared like: cost = (TOF_anomaly_TU2_abs/TOF_anomaly_TU2_abs_max)^2 + (t_r^2/t_max^2).

      if valid && cost < best_cost
        best_cost = cost;
        best_indices = current_indices;	
        best_XYT = [double(diff(t_x2x1)); double(diff(t_y2y1)); double(sum(t_x2x1+t_y2y1))/4] * det.time_unit;
      end
    end

    break_inner = false;
    % Prepare next index combination
    for j = 4:-1:1
      current_indices(j) = current_indices(j) + 1;
      if current_indices(j) < counts_per_channel(j)
        % No more roll-over, next index combination has been reached
        break;
      else
        % Roll-over: restart from lowest remaining index on this channel, and resume loop to increment index on previous channel
        current_indices(j) = base_indices(j);

        if j == 1
          % When first index rolls over, a full traversal of all remaining index-combinations has been done (at desired_depth).
          if best_cost < Inf
            % A valid hit was found at this depth, use it.
            used_XYT(:,end+1) = best_XYT;
            %found = true; %(redundant, check "best_cost < Inf")
            break_inner = true; % base indices will be updated at end of outer loop iteration
            if debug_trace
              disp(sprintf('hit: best_cost=%.3g, %s, %s ns', best_cost, mat2str(best_indices), mat2str(best_XYT'/1E-9)))
            end
          else
            %found = false; %(redundant, check "best_cost < Inf")
            break_inner = desired_depth >= max_depth;
            desired_depth = desired_depth + 1; % go to next depth (current_indices have restarted at base_indices), unless break_inner is true
            if debug_trace
              desired_depth
            end
          end
        end
      end
    end
  
  end % End of inner loop

  if best_cost < Inf
    base_indices = best_indices + 1; % add 1 to each channel, to skip past the now used hit. (If no hit was found, the outer loop exits and new base_indices have no effect.)

    if any(base_indices >= counts_per_channel) % (NOTE: this comparison is for zero-based base_indices)
      % On some channel, all triggings have been used/skipped. Since the current rescue algorithm never adds data
      % (just skips triggings to produce valid hits) no further valid hits can be produced.
      if debug_trace
        disp(sprintf('base_indices reached end: %s', mat2str(base_indices)))
      end
      break;
      % (NOTE: an extended algorithm that reconstructs a lost trigging from nomainal_TOF_anomaly or MCP-TOF does not need to end here, but may need different overall aproach.)
    end
    % will resume outer loop, to look for hits beyond the currently used (starting from a higher desired_depth)
  else
    break; % No more hit was found
  end

end % End of outer loop

any_hit_in_rescued_group = size(used_XYT,2) > 0;

if debug_trace
  disp('Used XYT (a column per hit):')
  disp(used_XYT / 1E-9) % DEBUG display [ns]
end

