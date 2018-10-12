% Test the DLT reading...
%
% Usage:
% * Make sure the directory containing "Matlab xUnit" is in your Matlab path.
% * Go to the directory that contains the directories 'tests', '@DLT',
%   '@DetDLD80', and the rest of the DLT-reader (to be ANACONDA2).
% * Write runtests('tests') on the command line, since the tests are in the subdirectory 'tests'
%
function test_suite = test_DLT_reading % The second name must be same as file name
initTestSuite;
% The above two lines set up a "test suite" so that multiple 
% test-functions are run in the same file.

global filename
% filename = '..\..\examples\TOF\20110921_n028.dlt'; % 1.8MB file used by some test cases due to containing negative TOF-data. Also has non-DLD channels.
filename = '..\..\examples\20130829_n0022.dlt'; % 33 MB, I411-data from weekw 35-36 2013


% Test cases are named test_... and call for instance
% assertTrue(m >= 5, 'Description of check/error message')
% assertEqual(-7, foo(), 'Description of check/error message')

% Check info from header & footer
function test_open
global filename; dlt = DLT(filename);
dlt.read_foot;

LF = sprintf('\n');
comment = ['CO chan1=1.5E-6 mbar' LF ...
  '287.55 eV resonance, gap 29.07 mm, 269 mA.' LF ...
  'Lens -3250, drift -4000, pusher 480 V. eMCP 4000V, iMCP -2100 V' LF ...
  '(x=25.7mm y=20.3mm)' LF ...
  'Electron rate 3.3kHz, Ion rate 1.7 kHz.' LF ...
  'Needle potentiometer at "8".'];
assertEqual(comment, dlt.comment, 'Footer comment');

assertTrue(bitand(uint32(dlt.get('Classes saved')), DLT.GROUP_STATUS_BIT.incomplete_group)~=0, 'Incomplete DLT hits were saved.')
assertFalse(bitand(uint32(dlt.get('Classes saved')), DLT.GROUP_STATUS_BIT.lone_start_trigging)~=0, 'Empty groups were not saved.')

assertEqual(2560889, dlt.counters_foot.number_of_start_triggings, 'Start triggings, rounded to thousands.')
assertEqual( 952008, dlt.counters_foot.number_of_groups, 'Number of groups, rounded to thousands.')
assertEqual(1608881, dlt.counters_foot.lone_start_triggings, 'Number of lone starts, rounded to thousands.')
assertEqual(15*60 + 0.016, dlt.acquisition_duration, 'File duration');

% Read the body, using the implementation from 2013-09
% function test_body_2013
% global filename; 
% global dlt; % (DEBUG) keep for possible manual command-line usage after test
% dlt = DLT(filename);
% 
% dlt.readoption__values_in_nanoseconds = true;
% dlt.readoption__keep_empty = false;
% dlt.readoption__serial_values = true;
% dlt.readoption__padded_matrix = true;
% dlt.readoption__cell_per_group = true;
% tic
% g = dlt.read_body(false); % NOTE: this takes a while (263 seconds, 4 to 5 minutes)
% toc
% assertEqual(g, dlt.counters_foot.number_of_groups, 'Group count according to footer');
% assertEqual(952008, g, 'Group count read');
% 
% % % From body:
% % absolute_group_trigger_time = []; % indexing: absolute_group_trigger_time(group)
% % serial_values = uint32([]) % indexing: serial_values{group}
% % channel_group_values = {} % indexing: channel_group_values{channel}{group}(hit)
% % channel_hits = uint16([]) % indexing: channel_hits(group,channel)
% % channel_values = {[]} % indexing: channel_values{channel}(group,hit), zero-padded in columns beyond channel_hits(group,channel)
% 
% TUns = 0.025; %[ns] time unit
% TUs = 0.025E-9; %[s] time unit
% assertElementsAlmostEqual(TUns, dlt.hardware_settings.time_unit, 'relative',1E-15)
% 
% % Check group #2
% t = 58242478*TUs; %[s] = 0.001456061949999998;%[s] (hexadecimal 3F57DB2A9D326165 in IEEE754)
% assertElementsAlmostEqual(t, dlt.absolute_group_trigger_time(2), 'relative',1E-15, 'Group#2 trigger time relative start of acquisition.');
% 
% % Has 16 triggings, i.e. 4 hits on each of the four channels. 1-based indexing here:
% % ch1trig1: 29708*TUns
% % ch1trig4: 48301*TUns
% % ch4trig1:  6531*TUns
% % ch4trig4: 40546*TUns
% 
% s = dlt.serial_values{2};
% assertEqual(uint32(29708), s(1), 'Group#2 serial ch1trig1');
% assertEqual(uint32(48301), s(4), 'Group#2 serial ch1trig4');
% assertEqual(uint32(6531), bitand(2^24-1, s(13)),  'Group#2 serial ch4trig1');
% assertEqual(uint32(40546), bitand(2^24-1, s(16)), 'Group#2 serial ch4trig4');
% assertEqual(uint32(3), bitand(2^24*255, s(16))/2^24, 'Group#2 serial ch4trig4, zero-based channel id');
% 
% ch1 = dlt.channel_group_values{1}{2};
% ch4 = dlt.channel_group_values{4}{2};
% assertElementsAlmostEqual([29708 48301]*TUns, ch1([1 4]), 'relative', 1E-15, 'Group#2 channel_group_values ch1 trig1&4');
% assertElementsAlmostEqual([6531 40546]*TUns, ch4([1 4]), 'relative', 1E-15, 'Group#2 channel_group_values ch4 trig1&4');
% 
% assertEqual([4 4 4 4], dlt.channel_hits(2,:), 'Hits in group 2');
% ch1 = dlt.channel_values{1}(2,:);
% ch4 = dlt.channel_values{4}(2,:);
% assertElementsAlmostEqual([29708 48301]*TUns, ch1([1 4]), 'relative', 1E-15, 'Group#2 channel_values ch1 trig1&4');
% assertElementsAlmostEqual([6531 40546]*TUns, ch4([1 4]), 'relative', 1E-15, 'Group#2 channel_values ch4 trig1&4');
% 
% % Check group #952008 (last)
% assertEqual([1 1 1 1], dlt.channel_hits(g,:), 'Hits in last group');
% ch1 = dlt.channel_values{1}(end,:);
% ch4 = dlt.channel_values{4}(g,:);
% assertElementsAlmostEqual([132795]*TUns, ch1([1]), 'relative', 1E-15, 'Group#end channel_values ch1 trig1');
% assertElementsAlmostEqual([132889]*TUns, ch4([1]), 'relative', 1E-15, 'Group#end channel_values ch4 trig1');
% assertTrue(all(isnan(ch1(2:4))), 'Group#end channel_values ch1 trig2-4 absent');
% assertTrue(all(isnan(ch4(2:4))), 'Group#end channel_values ch4 trig2-4 absent');
% 
% toc

% Verify automatic definition of detector type.
function test_body_automatic_DLD80
global filename; 
dlt = DLT(filename);
%dlt.set_detectors('auto') happens by default already in constructor

assertEqual(1, length(dlt.detectors), 'A single detector');
assertTrue(isa(dlt.detectors{1}, 'Detector'), 'must be a subclass of Detector');
assertEqual('DetDLD80', class(dlt.detectors{1}), 'DetDLD80 class should be the guess for 20130829_n0022.dlt');


% Read the body, with detector settings accepting almost any TOF anomaly and radius.
function test_body_DLD80_wide_acceptance
global filename; 
global dlt; % (DEBUG) keep for possible manual command-line usage after test
dlt = DLT(filename);
assertFalse(dlt.is_loaded_data_current(), 'Not loaded yet.');

% Nearly disable hit validity checking by setting large limits, so that group#2 becomes included
% (to avoid manual work of interpreting another group). The last group is however valid also with normal limits.
detector = DetDLD80();
detector.set_TOF_anomaly_range(-1E-5, 1E-5); %[s]
detector.set_max_radius(0.5); %[m] (500 mm ~ roughly 1E3 ns)

if ~true
  % NOTE: new reader initially loaded only 813169 events. That was with default rescue_mode 'abort'.
  % Changing rescue mode to 'make empty' loads all the 952008 groups from the file.
  % Thus either the old Matlab reader was not checking as carefully
  % or the new reader (2014, still not vectorized) is rejecting too many events!?
  %expected_event_count = 813169; % TODO: investigate the events where rescuing (abortion) occurred correctly
  expected_event_count = 812959; % TODO: investigate the events where rescuing (abortion) occurred correctly
else
  % Keep all events (just make hit count zero), to match the old reader's event (group) count.
  detector.set_rescue_mode('make empty');
  expected_event_count = 952008;
  dlt.readoption__keep_empty = true; % needed when default option has been changed to false
end

dlt.set_detectors({detector}); % override defaults to nearly disable hit validity checking
assertFalse(dlt.is_loaded_data_current(), 'Not loaded yet, detectors changed.');

fprintf('\n'); % to not mix "." output from runtests() with messages printed by DLT.read
event_count = dlt.read(false);
assertTrue(dlt.is_loaded_data_current(), 'Data has been loaded.');

assertEqual(event_count, dlt.event_count, 'Event count attribute check');
assertEqual(1, double(length(dlt.detectors)), 'There should only be one detector.');
det_index = 1;

% Check group #2 (event #2, assuming both #1 and #2 were accepted)
% Because the event #1 has 8 triggings (2 hits on each of the 4 channels) the serialized
% index where event #2 (group #2) starts is 3.
e = 2;
u = dlt.start_index(det_index, e);
assertEqual(3, double(u), 'Event #2 start index.');

TUs = 0.025E-9; %[s] time unit
v = [detector.signal_speed_x; detector.signal_speed_y]; % to convert between T_XY [ns] and XY [m]
t = 58242478*TUs; %[s] = 0.001456061949999998;%[s] (hexadecimal 3F57DB2A9D326165 in IEEE754)
assertElementsAlmostEqual(t, dlt.absolute_group_trigger_time(e), 'relative',1E-15, 'Group#2 trigger time relative start of acquisition.');

% Has 16 triggings, i.e. 4 hits on each of the four channels. 1-based indexing here:
% ch1trig1: 29708*TUns, ..., % ch1trig4: 48301*TUns
% ch4trig1:  6531*TUns, ..., % ch4trig4: 40546*TUns
T_X = [-41.8500   6.8250 130.0500  91.5750]*1E-9; %[s] ch1-ch2
T_Y = [581.6750 134.1500 223.6750 199.5000]*1E-9; %[s] ch3-ch4 -- note this hit is invalid (outside ~85 ns)
TOF = [608.868750  889.081250 1052.481250 1137.568750]*1E-9; %[s] (ch1+ch2+ch3+ch4)/4
% Here checking untreated data. The untreated attribute is private, but has getter-method.
[T_first, XY_first] = dlt.get_loaded(det_index, e, 1); % a specific hit in the event
[T, XY] = dlt.get_loaded(det_index, e); % all hits in the event
assertElementsAlmostEqual(TOF, T, 'relative',1E-16, 'Times of flight in event #2');
assertEqual(TOF, T, 'Times of flight in event #2 (might fail due to rounding errors)');
% NOTE: Assuming the data layout has the concatenated hits as columns (to keep all coordinates of a hit close in memory).
assertEqual(T_first, T(:,1), 'Extracting first hit TOF');
assertEqual(XY_first, XY(:,1), 'Extracting first hit T_X and T_Y');
assertElementsAlmostEqual(T_X, XY(1,:)./v(1), 'relative',1E-16, 'Values of T_X in event #2');
assertElementsAlmostEqual(T_Y, XY(2,:)./v(2), 'relative',1E-16, 'Values of T_Y in event #2');
assertElementsAlmostEqual([T_X; T_Y], XY./repmat(v,1,length(T_X)), 'relative',1E-16, 'Values of T_X and T_Y in event #2');
% Helper for (accepted) hit count
assertEqual(4, double(dlt.get_hit_count(det_index, e)), 'Hit count of event #2');

% Check group #952008 (last)
T_X = [ 14.5500   ]*1E-9; %[s] ch1-ch2
T_Y = [-10.2750   ]*1E-9; %[s] ch3-ch4
TOF = [3314.843750]*1E-9; %[s] (ch1+ch2+ch3+ch4)/4
e = event_count;
assertEqual(length(dlt.start_index)-1, double(e), 'start_index should have one entry more than the number of events.');
%assertEqual(double(dlt.start_index(det_index,end-1)), ?, 'total hit count');
hits = double(dlt.get_hit_count(det_index, e));
assertEqual(1, hits, 'Hit count of last event');
assertEqual(hits, double(sum(dlt.get_hit_count(':', e),1)), 'Hit count for detector=: should concatenate per-detector counts vertically');
u = dlt.start_index(det_index,e);
assertEqual(double(dlt.start_index(det_index,end)), double(u)+hits, 'Last event start index plus number of hits should give the index beyond the used length of the concatenated "untreated" arrays.');
[T, XY] = dlt.get_loaded(det_index, e); % all hits in last event
assertElementsAlmostEqual(TOF, T, 'relative',1E-16, 'Times of flight in last event');
assertEqual(TOF, T, 'Times of flight in last event (might fail due to rounding errors)');
assertElementsAlmostEqual([T_X; T_Y], XY./repmat(v,1,length(T_X)), 'relative',1E-15, 'Values of T_X and T_Y in last event');



assertEqual(-1E-5, detector.min_TOF_anomaly, 'Previous min TOF anomaly.')
assertEqual(1E-5, detector.max_TOF_anomaly, 'Previous max TOF anomaly.')
% Change some detector setting, and test that it makes loaded data non-current (requires that detectors are mutable (handle-classes))
detector.set_TOF_anomaly_range(-15E-9, 15E-9); %[s]
assertFalse(dlt.is_loaded_data_current(), 'Data has not been loaded after detector change.');
assertEqual(-15E-9, detector.min_TOF_anomaly, 'New min TOF anomaly.')
assertEqual(15E-9, detector.max_TOF_anomaly, 'New max TOF anomaly.')

% This test is put last, since it depends on handling of invalid events and
% needs examination/debugging to determine which event count is "correct".
assertEqual(expected_event_count, event_count, 'The number of events, as groups in file if all events were accepted. (Note: depends on configuration so a lower value can be correct.)');

% TODO Variant of test_body_DLD80_wide_acceptance
% without 'make empty' and without readoption_keep...
function test_body_DLD80_wide_acceptance_not_empty
global filename; 
global dlt; % (DEBUG) keep for possible manual command-line usage after test
dlt = DLT(filename);
assertFalse(dlt.is_loaded_data_current(), 'Not loaded yet.');

% Nearly disable hit validity checking by setting large limits, so that group#2 becomes included
% (to avoid manual work of interpreting another group). The last group is however valid also with normal limits.
assertElementsAlmostEqual(3E-9, dlt.detectors{1}.min_TOF_anomaly, 'relative',1E-15, 'Min TOF anomaly should default to vaule from file footer.')
assertElementsAlmostEqual(6E-9, dlt.detectors{1}.max_TOF_anomaly, 'relative',1E-15, 'Max TOF anomaly should default to vaule from file footer.')
assertElementsAlmostEqual(0.045, sqrt(dlt.detectors{1}.max_radius_squared), 'relative',1E-15, 'Max radius should default to 45 mm.'); %[m] (45 mm ~ roughly 90 ns)

dlt.detectors{1}.set_rescue_mode('abort');
expected_event_count = 792988; % (the value loaded by read_slow, if read gives the same it is good enough for now)
dlt.readoption__keep_empty = false;
dlt.readoption__keep_discarded = false;
dlt.log_anomaly_histogram = true; % TODO check some result

fprintf('\n'); % to not mix "." output from runtests() with messages printed by DLT.read
event_count = dlt.read(false);
assertTrue(dlt.is_loaded_data_current(), 'Data has been loaded.');

assertEqual(event_count, dlt.event_count, 'Event count attribute check');
assertEqual(1, double(length(dlt.detectors)), 'There should only be one detector.');
det_index = 1;

TUs = dlt.hardware_settings.time_unit; % = 0.025E-9; %[s] time unit
v = [dlt.detectors{1}.signal_speed_x; dlt.detectors{1}.signal_speed_y]; % to convert between T_XY [ns] and XY [m]

% Check that group #2 (which is invalid, see test_body_DLD80_wide_acceptance())
% was NOT kept as Event #2.
t = 58242478*TUs; %[s] = 0.001456061949999998;%[s] (hexadecimal 3F57DB2A9D326165 in IEEE754)
assert(abs(t - dlt.absolute_group_trigger_time(2)) > t*1E-10, 'Kept Event#2 trigger time should not be that of Group#2.');
% To agree with read_slow, the Event#2 has the following absolute time
assertElementsAlmostEqual(0.005533575250000, dlt.absolute_group_trigger_time(2), 'relative',1E-15, 'Event#2 trigger time relative start of acquisition.');

% Check group #952008 (last) ==> Event#792988
T_X = [ 14.5500   ]*1E-9; %[s] ch1-ch2
T_Y = [-10.2750   ]*1E-9; %[s] ch3-ch4
TOF = [3314.843750]*1E-9; %[s] (ch1+ch2+ch3+ch4)/4
e = event_count;
assertEqual(length(dlt.start_index)-1, double(e), 'start_index should have one entry more than the number of events.');
assertEqual(1112588, double(dlt.start_index(e)), 'start_index(792988) according to read_slow')
hits = double(dlt.get_hit_count(det_index, e));
assertEqual(1, hits, 'Hit count of last event');
u = dlt.start_index(det_index,e);
[T, XY] = dlt.get_loaded(det_index, e); % all hits in last event
assertElementsAlmostEqual(TOF, T, 'relative',1E-16, 'Times of flight in last event');
assertEqual(TOF, T, 'Times of flight in last event (might fail due to rounding errors)');
assertElementsAlmostEqual([T_X; T_Y], XY./repmat(v,1,length(T_X)), 'relative',1E-15, 'Values of T_X and T_Y in last event');
assertElementsAlmostEqual(899.9853823364000, dlt.absolute_group_trigger_time(e), 'relative',1E-15, 'Last event trigger time relative start of acquisition.');


% This test is put last, since it depends on handling of invalid events and
% needs examination/debugging to determine which event count is "correct".
assertEqual(expected_event_count, event_count, 'The number of events, as groups in file if all events were accepted. (Note: depends on configuration so a lower value can be correct.)');

%% Test treatment of negative TOF-values.
function test_body_TDC_signed
filename = '..\..\examples\TOF\20110921_n028.dlt'; % 1.8MB file used by some test cases due to containing negative TOF-data. Also has non-DLD channels.
global dlt; % (DEBUG) keep for possible manual command-line usage after test
dlt = DLT(filename);
assert(dlt.hardware_settings.group_range_start < 0, 'Need a file where negative TOF was recorded.');

assertElementsAlmostEqual(-6E-9, dlt.detectors{1}.min_TOF_anomaly, 'relative',1E-15, 'Min TOF anomaly should default to vaule from file footer.')
assertElementsAlmostEqual(1E-9, dlt.detectors{1}.max_TOF_anomaly, 'relative',1E-15, 'Max TOF anomaly should default to vaule from file footer.')
assertElementsAlmostEqual(0.045, sqrt(dlt.detectors{1}.max_radius_squared), 'relative',1E-15, 'Max radius should default to 45 mm.'); %[m] (45 mm ~ roughly 90 ns)

% dlt.detectors{1}.set_rescue_mode('make empty');% would give group #1 and #6 same, but of course different event_count and expected_hit_counts
dlt.detectors{1}.set_rescue_mode('abort');
dlt.readoption__keep_empty = true;
dlt.readoption__keep_discarded = false; % (no effect since they are rescued by 'make empty')
event_count = dlt.read();

%assertEqual(82040, event_count, 'All groups should be loaded when resue=''make empty''.');
%expected_hit_counts = [35627; 67687; 0]; % (the value loaded by vectorized read, if read_slow gives the same it is good enough for now)
assertEqual(80534, event_count, 'Group count when resue=''abort''.');
expected_hit_counts = [35627; 66805; 0]; % (the value loaded by vectorized read, if read_slow gives the same it is good enough for now)


e = 1; % Group#1 has negative TOF on detector 2
assertElementsAlmostEqual(5.4240805E-4, dlt.absolute_group_trigger_time(e), 'relative',1E-15, 'Absolue time of group #1.');
assert(all(dlt.rescued(:,e) == [0;0;0]), 'First group not rescued on any detector');
assert(all(dlt.discarded(:,e) == [0;0;0]), 'First group not discarded on any detector');
assert(isempty(dlt.get_loaded(1,e)), 'Group#1 has no hits on detector 1.');
assertEqual(1, double(dlt.get_hit_count(2,e)), 'Group#1 has one hit on detector 2.');
assert(dlt.get_loaded(2,e) < dlt.hardware_settings.group_range_end, 'Hit in group#1 should be within recorded TOF range. If not, it suggests error in DLT.read''s handling of signed values or channel_index>128.');
assertElementsAlmostEqual(-4.4225E-8, dlt.get_loaded(2,e), 'relative',1E-15, 'Value of TOF in group#1.'); % correct treatment of signed value

% The next line added 2015-09-17. The test passes now, so it is probably OK.
assert(all([true false] == isnan(dlt.get_loaded(1,[e 6],1,NaN))), 'Group#1 has no hits on detector 1, group #6 has. Here testing to return TOF=NaN for events with fewer hits than requested.');

e = 6; % Group#6 has positive times on detector 1
[t,xy] = dlt.get_loaded(1,e);
assertElementsAlmostEqual(0.00452615985, dlt.absolute_group_trigger_time(e), 'relative',1E-15, 'Absolue time of group #6.');
assertElementsAlmostEqual(5.75796875E-6, t, 'relative',1E-15, 'TOF in group#6.');
assertElementsAlmostEqual([-0.0004675; 0.002301], xy, 'relative',1E-15, 'x and y in group#6.');

assertEqual(expected_hit_counts, double(dlt.get_hit_count(':')), 'Hit counts on each detector.')

% Repeat this test with read_slow (OK since the file is only 1.8 MB) to ensure both methods agree.
dlt.read_slow();
assertElementsAlmostEqual(5.4240805E-4, dlt.absolute_group_trigger_time(1), 'relative',1E-15, 'Absolue time of group #1. Using read_slow.');
assertElementsAlmostEqual(-4.4225E-8, dlt.get_loaded(2,1), 'relative',1E-15, 'Value of TOF in group#1. Using read_slow.'); % correct treatment of signed value
% Get 2.09715175E-4 by incorrect treatment, where truncated to max of I24 in hardware unit

e = 6; % Group#6 has positive times on detector 1
[t,xy] = dlt.get_loaded(1,6);
assertElementsAlmostEqual(0.00452615985, dlt.absolute_group_trigger_time(6), 'relative',1E-15, 'Absolue time of group #6. Using read_slow.');
assertElementsAlmostEqual(5.75796875E-6, t, 'relative',1E-15, 'TOF in group#6. Using read_slow.');
assertElementsAlmostEqual([-0.0004675; 0.002301], xy, 'relative',1E-15, 'x and y in group#6. Using read_slow.');

assertEqual(80534, event_count, 'Group count when resue=''abort''. Using read_slow.');
assertEqual(expected_hit_counts, double(dlt.get_hit_count(':')), 'Hit counts on each detector. Using read_slow.')

% TODO: would be good to have a file with 0-based channel >= 128, to further test treatment of signed values.


% Test reverse-loopup from hit to event index.
events_to_test = 5:9; % Events 5 and 9 have a hit on detector 2, events 6 to 8 have hits on detector 1
for d = 1:2
  for e = events_to_test
    hit_count = dlt.get_hit_count(d,e);
    TOF = dlt.get_loaded(d,e);
    assertEqual(double(hit_count), length(TOF), sprintf('Number of TOF-values from event %d', e));
    if hit_count > 0
      f = dlt.from_which_event(d, dlt.start_index(d,e)); % first hit in event
      assertEqual(e, f, sprintf('Mismatching from_which_event for first hit in event %d', e));
      f = dlt.from_which_event(d, dlt.start_index(d,e+1)-1); % last hit in event
      assertEqual(e, f, sprintf('Mismatching from_which_event for last hit in event %d', e));
      from_which_event = dlt.from_which_event(d);
      f = from_which_event(1, dlt.start_index(d,e):dlt.start_index(d,e+1)-1); % each hit in event, via array
      assertEqual(repmat(e,1,hit_count), f, sprintf('Mismatching from_which_event for hits hit in event %d', e));
    end
  end
end


function test_DLD_defaults
global filename; 
dlt = DLT(filename);
assertFalse(dlt.readoption__keep_empty, 'readoption__keep_empty default should be false');
assertFalse(dlt.readoption__keep_discarded , 'readoption__keep_discarded  default should be false');
% TODO more?

% function test_raw_detector
% TODO: make a mock detector that saves the raw trigging data to a data structure of its own,
% useful for development of event rescuing algorithms, and to have a test for the interface between
% detectors and the DLT.read() method.

function test_incomplete_DLD
global filename; 
global dlt; % (DEBUG) keep for possible manual command-line usage after test
dlt = DLT(filename);

global DLT_logged_invalid;
dlt.log_invalid = true; % to populate DLT_logged_invalid
global logged_TOF_anomaly_times2; logged_TOF_anomaly_times2 = [];

assertEqual(1, length(dlt.detectors), 'A single detector');
assertEqual('DetDLD80', class(dlt.detectors{1}), 'DetDLD80 class should be the guess for 20130829_n0022.dlt');

% NOTE: it seems quite many events are rejected with default settings (dlt.start_index(end) == 15299)
% DEBUG: 
dlt.detectors{1}.set_TOF_anomaly_range(3E-9, 6E-9); dlt.detectors{1}.set_max_radius(0.045); % explicitly set the defaults
% dlt.detectors{1}.set_TOF_anomaly_range(-1E-5, 1E-5); dlt.detectors{1}.set_max_radius(0.5); % allow very anomalous events, like in other test case

% First read and keep the discarded events by making them empty, this ensures the event index refers to global count of groups in the file.
dlt.detectors{1}.set_rescue_mode('make empty'); % To assign event indices for discarded events and keep (accept) them as empty events.
dlt.readoption__keep_empty = true; % needed when default option has been changed to false
dlt.readoption__keep_discarded = true; % needed when default option has been changed to false
dlt.log_invalid = true; % needed when default option has been changed to false

fprintf('\n'); % to not mix "." output from runtests() with messages printed by DLT.read
dlt.read();
file_group_count = 952008;
assertEqual(file_group_count, dlt.event_count, 'All groups in file should be kept.');


if true
  warning('Tests for logging discarded and rescued groups are disabled, since that was disabled when optimizing reading. TODO: re-implement such logging?');
else % TODO: re-implement such logging?
  assert(isstruct(DLT_logged_invalid) && ~isempty(DLT_logged_invalid), 'TODO: The following tests assume data from discarded and rescued groups was logged. Will fail until re-implemented (was disabled when optimizing reading).')

  % Which indices in DLT_logged_invalid are due to incomplete events?
  incomplete = find(bitand(IO.DLT2ANA.collect_field(DLT_logged_invalid,'rescued'), DLT.GROUP_STATUS_BIT.incomplete_group) ~= 0);
  % Which are due to anomalous time or position data?
  anomalous = find(bitand(IO.DLT2ANA.collect_field(DLT_logged_invalid,'rescued'), DLT.GROUP_STATUS_BIT.discarded_but_complete) ~= 0);
  assertEqual(length(DLT_logged_invalid), length(anomalous) + length(incomplete), 'Logged events should be either anomalous or incomplete. Not expected that any event is flagged with both reasons.')

  % Examine the first incomplete event
  log = DLT_logged_invalid(incomplete(1)); 
  assertEqual(18, double(log.event), 'First incomplete event is in the 18th group in 20130829_n0022.dlt.');
  assertEqual([1;2;3], double(log.channel), '#18 has one trigging each on channels 1 to 3 (one-based indexing)')
  assertEqual(0, double(dlt.get_hit_count(1, log.event)), 'Event #18 should be kept as empty event.')
  assertEqual(0, double(dlt.discarded(1,log.event)), 'Should be "rescued" (to empty)');
  assertEqual(DLT.GROUP_STATUS_BIT.incomplete_group, dlt.rescued(1,log.event), 'Should have incomplete_group flag');

  % Check that the global indexing agrees (would not be the case if rescue mode 'abort' had been used instead of 'make empty')
  event_indices = IO.DLT2ANA.collect_field(DLT_logged_invalid,'event');
  assertTrue(all(dlt.rescued(event_indices(incomplete)) == DLT.GROUP_STATUS_BIT.incomplete_group), 'Rescued events kept at correct indices');
  assertTrue(all(dlt.rescued(event_indices(anomalous)) == DLT.GROUP_STATUS_BIT.discarded_but_complete), 'Rescued events kept at correct indices');
  % dlt.detectors{1}.show_TOF_anomaly_histogram(dlt); % can be used to check TOF anomaly histogram

  % Check that the first discarded is event #2, due to radius
  log = DLT_logged_invalid(anomalous(1));
  assertEqual(2, double(log.event), 'First anomalous event is 2nd group in 20130829_n0022.dlt.');

  T_X = [-41.8500   6.8250 130.0500  91.5750]/0.025; %[TU] ch1-ch2
  T_Y = [581.6750 134.1500 223.6750 199.5000]/0.025; %[TU] ch3-ch4 -- note this hit is invalid (outside ~85 ns)
  TOF = [608.868750  889.081250 1052.481250 1137.568750]/0.025; %[TU] (ch1+ch2+ch3+ch4)/4
  assertEqual([4;4;4;4], double(log.counts), '#2 has four triggings on each channel')
  assertEqual(0, double(dlt.discarded(1,log.event)), 'Should be "rescued" (to empty)');
  assertEqual(DLT.GROUP_STATUS_BIT.discarded_but_complete, dlt.rescued(1,log.event), 'Should have discarded_but_complete flag');
  x1 = log.value(log.channel==1);
  x2 = log.value(log.channel==2);
  y1 = log.value(log.channel==3);
  y2 = log.value(log.channel==4);
  t_x = x1-x2
  % TODO: test something on the logged values from discarded
end

% TODO: read without keeping discarded events ('abort'), and ensure that event count is reduced accordingly.




% Read the body of corresponding files in version 2 and version 1 of the DLT format
function test_body_DLTv1_DLD80
filename = '..\..\examples/version 1/20101218_n0001 v1.dlt'; % NOT the global filename, use an old file with version 1 of the DLT format.
filename2 = '..\..\examples/version 1/20101218_n0001.dlt'; % The same file converted to version 2
dlt1 = DLT(filename);
dlt2 = DLT(filename2);

% Nearly disable hit validity checking by setting large limits, so that group#2 becomes included
% (to avoid manual work of interpreting another group). The last group is however valid also with normal limits.
detector = DetDLD80();
%detector.set_TOF_anomaly_range(-1E-5, 1E-5); %[s]
%detector.set_max_radius(0.5); %[m] (500 mm ~ roughly 1E3 ns)
% detector.set_rescue_mode('make empty');
% Tweaked to get same number of accepted events as shown in CAT screenshot (9058)
detector.set_TOF_anomaly_range(-5.15E-9, 1E-9); %[s]
detector.set_max_radius(44E-3); %[m] (roughly 80 ns) ?? seems twice as large as expected, TODO: are the G_x,y factors not used? -- compare CAT screenshot
detector.set_rescue_mode('abort');

dlt1.set_detectors({detector}); % override defaults to nearly disable hit validity checking
dlt2.set_detectors({detector}); % override defaults to nearly disable hit validity checking

dlt1.readoption__keep_empty = true; % needed when default option has been changed to false
dlt2.readoption__keep_empty = true; % needed when default option has been changed to false

% (OPTIONAL) Keeping discarded to make differences between the versions show up more clearly:
dlt1.readoption__keep_discarded = true;
dlt2.readoption__keep_discarded = true;

fprintf('\n'); % to not mix "." output from runtests() with messages printed by DLT.read
dlt2.read(false);
dlt1.read(false);
assertTrue(dlt1.is_loaded_data_current(), 'Data has been loaded.');
% Counts from screenshots of when loaded in LabView CAT program
assertEqual(9369 - 237 - 44, dlt1.counters_foot.number_of_groups, 'Total group count check 1');
assertEqual(9369           , dlt2.counters_foot.number_of_groups, 'Total group count check 2');
if dlt1.readoption__keep_discarded
  % Then all groups should be kept
  assertEqual(dlt1.counters_foot.number_of_groups, dlt1.event_count, 'Keep-all event count attribute check 1');
  assertEqual(dlt2.counters_foot.number_of_groups, dlt2.event_count, 'Keep-all event count attribute check 2');
else
  % When not keeping discarded, the accepted count should match that in CAT (LabView) screenshot. (It does.)
  assertEqual(9058, dlt1.event_count, 'Accepted event count attribute check 1');
  assertEqual(9058, dlt2.event_count, 'Accepted event count attribute check 2');
end

% Only two of the events were shown in CAT screenshot where TOF range started at 8
assertEqual(2, sum( dlt1.get_loaded(1) >= 800E-9 ), 'Hits with TOF >= 800ns hit, dlt1');
assertEqual(2, sum( dlt2.get_loaded(1) >= 800E-9 ), 'Hits with TOF >= 800ns hit, dlt2');


det_index = 1;

first_complete_but_discarded_1 = find( bitand(dlt1.discarded(det_index,:), bitxor(DLT.GROUP_STATUS_BIT.incomplete_group, 2^32-1)), 1);
first_complete_but_discarded_2 = find( bitand(dlt2.discarded(det_index,:), bitxor(DLT.GROUP_STATUS_BIT.incomplete_group, 2^32-1)), 1);
preceeding_discared_incomplete = sum(dlt2.discarded(det_index,1:first_complete_but_discarded_2-1)~=0);
assertEqual(first_complete_but_discarded_1, first_complete_but_discarded_2-preceeding_discared_incomplete, 'First group discarded although complete should be present at deducable index also in version1-file.');

% Check group #36 (event #36, is number #36 also in the version 1 file where none before is discarded)
e = 36;
assertEqual(e, find(dlt1.get_hit_count(det_index,[])>1, 1), 'Group#36 should be the first with more than one hit.');

TUs = 0.025E-9; %[s] time unit
d=[hex2dec('00000813') hex2dec('000004af') hex2dec('000000ff') hex2dec('00000bbb')   % first hit
   hex2dec('00005de9') hex2dec('00005be7') hex2dec('000057e6') hex2dec('000061d0')] * TUs; % second hit
expected_T = sum(d,2)'/4;
v = [detector.signal_speed_x; detector.signal_speed_y]; % to convert between T_XY [ns] and XY [m]
expected_XY = [ v.*[-diff(d(1,1:2)); -diff(d(1,3:4))] ,  v.*[-diff(d(2,1:2)); -diff(d(2,3:4))] ];

[T, XY] = dlt1.get_loaded(det_index, e); % all hits in the event, from DLT1 file
assertElementsAlmostEqual(expected_T, T, 'relative',1E-16, 'Times of flight in event #36, dlt1');
assertElementsAlmostEqual(expected_XY, XY, 'relative',1E-16, 'Values of T_X and T_Y in event #36, dlt1');

[T, XY] = dlt2.get_loaded(det_index, e); % all hits in the event, from DLT2 file
assertElementsAlmostEqual(expected_T, T, 'relative',1E-16, 'Times of flight in event #36, dlt2');
assertElementsAlmostEqual(expected_XY, XY, 'relative',1E-16, 'Values of T_X and T_Y in event #36, dlt2');

% Check last event, which should differ
T1 = dlt1.get_loaded(1, dlt1.counters_foot.number_of_groups);
T2 = dlt2.get_loaded(1, dlt2.counters_foot.number_of_groups);
T_wrong = dlt2.get_loaded(1, dlt1.counters_foot.number_of_groups);
assertEqual(T1, T2, 'TOF of last events should match.');
assert(T1 ~= T_wrong, 'TOF of last DLT1-event should not match event at same index from DLT2 (since some imcomplete events occur in DLT2 file).');

dlt1.close();
dlt2.close();
