% Test the rescue algorithm for groups/events...
%
% Usage:
% Make sure "Matlab xUnit" is installed in your Matlab path.
% Go to the same direcory as this file is in.
% Write runtests on the command line.
%
%%DEBUG DISABLED FOR OCTAVE WITHOUT PATH%% function test_suite = test_event_rescue % The second name must be same as file name
%%DEBUG DISABLED FOR OCTAVE WITHOUT PATH%% initTestSuite;
% The above two lines set up a "test suite" so that multiple 
% test-functions are run in the same file.

% Test cases are named test_... and call for instance
% assertTrue(m >= 5, 'Description of check/error message')
% assertEqual(-7, foo(), 'Description of check/error message')

% Version 0 of the rescue algorithm, corresponding to original in CAT (Coincident Acquisition of Times, in LabView)
%%DEBUG DISABLED FOR OCTAVE WITHOUT PATH%% function test_rescue_algorithm_v0_standalone

%  det = DetDLD80();
%  det.set_TOF_anomaly_range(-15E-9, 15E-9);
  % Alterntive: fake instance for Octave
  det = struct('time_unit', 25E-12, 'channels_onebased', [1 2 3 4]);
  det.min_TOF_anomaly_TU2 = int32((-15E-9) * 2/det.time_unit);
  det.max_TOF_anomaly_TU2 = int32(( 15E-9) * 2/det.time_unit);


  % Group#2 in 20130829_n0022.dlt: 4 triggings at each of the 4 channels, but invalid coordinates (presumably a spurious first and missing fourth/fifth on channel 4)
  % ch1_triggings = [29708 36740 45232 48301]*TU  %(x1)
  % ch2_triggings = [31382 36467 40030 44638]*TU  %(x2)
  % ch3_triggings = [29798 37206 46041 48526]*TU  %(y1)
  % ch4_triggings = [ 6531 31840 37094 40546]*TU  %(y2)
  % 
  % Manually reasonable rescue result ("skip spurious triggings / Rescue algorithm 1")
  % ch1_triggings = [29708 36740 NaN   45232 48301]*TU  %(x1)
  % ch2_triggings = [31382 36467 40030 44638 NaN  ]*TU  %(x2)
  % ch3_triggings = [29798 37206 NaN   46041 48526]*TU  %(y1)
  % ch4_triggings = [31840 37094 40546 NaN   NaN  ]*TU  %(y2)
  % ==>
  % t_x   = [-41.85   6.825] ns
  % t_y   = [-51.05   2.8  ] ns
  % t_TOF = [767.05 921.919] ns

  channels = [1 1 1 1, 2 2 2 2, 3 3 3 3, 4 4 4 4];
  values  = [29708 36740 45232 48301, 31382 36467 40030 44638, 29798 37206 46041 48526, 6531 31840 37094 40546]; % raw times from the TDC (in hardware time units)

  % % DEBUG Example for illustration in documentation book:
  % channels = [1 1, 2  2  2 2, 3 3 3, 4 4 4];
  % values  = [3160   4680,   2120   2520   4960   5360,   2000   5000   5400,    960   3600   4880]; % raw times from the TDC (in hardware time units)
  % % hit1: t=[3160   2120   2000   3600] TU: tx= 26 ty=-40 TOF=68   TOFy-TOFx= 4 ns
  % % skip: t=[4900   2520   5000   4880] TU; tx=119 ty=3  TOF=190.5 TOFy-TOFx=66 ns
  % % hit2: t=[4680   4960   5000   4880] TU; tx= -7 ty=3  TOF=122   TOFy-TOFx= 3 ns


  [used_XYT, any_hit_in_rescued_group] = rescue_algorithm0_standalone(det, channels, values);

%  assertElementsAlmostEqual(used_XYT(:,1), [-41.85; -51.05; 767.05], 'relative',1E-16, 'Values of T_Y in event #2');
%  assertElementsAlmostEqual(used_XYT(:,2), [-6.825; -2.8; 921.919], 'relative',1E-16, 'Values of T_Y in event #2');
%  assertEqual(3, size(T_XYT,1));
%  assertEqual(2, size(T_XYT,2)); % only two hits accepted by CAT and manually. Was a facor 2 missing or is the 
  wrong = [ any(abs(used_XYT(:,1)/1E-9 - [-41.850; -51.050; 767.050]) >= 0.001)  any(abs(used_XYT(:,2)/1E-9 - [6.825; 2.800; 921.919]) >= 0.001) ]
  assertFalse(wrong, 'XYT data does not match expectation.')
  assertEqual(2, size(used_XYT,2), 'XYT data has the wrong number of hits.')

