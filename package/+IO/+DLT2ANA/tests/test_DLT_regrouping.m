% Test the regrouping of DLT-events into larger groups, mainly as a way to 
% test covariance analysis before data that really needs it has been recorded.
%
% Usage:
% * Make sure the directory containing "Matlab xUnit" is in your Matlab path.
% * Go to the directory that contains the directories 'tests', '@DLT',
%   '@DetDLD80', and the rest of the DLT-reader (to be ANACONDA2).
% * Write runtests('tests') on the command line, since the tests are in the subdirectory 'tests'
%
function test_suite = test_DLT_regrouping % The second name must be same as file name
initTestSuite;
% The above two lines set up a "test suite" so that multiple 
% test-functions are run in the same file.

global filename2
filename2 = '..\..\examples\TOF\20110921_n028.dlt'; % 1.8MB file used by some test cases due to containing negative TOF-data. Also has non-DLD channels.

% Test cases are named test_... and call for instance
% assertTrue(m >= 5, 'Description of check/error message')
% assertEqual(-7, foo(), 'Description of check/error message')

%% Just regrouping

function test_regrouping_count
% Test with a fixed number of loaded events per new group.
global filename2; raw = DLT(filename2); raw.read();

events_to_test = 1:30; % select a continguous block of events, with a size divisable by 3 (the grouping size)
groups_to_test = 1:10;

expected_count1  = raw.get_hit_count(1, events_to_test);
expected_count2  = raw.get_hit_count(2, events_to_test);
expected_abs_t   = raw.absolute_group_trigger_time(events_to_test);
[~, expected_XY] = raw.get_loaded(1, events_to_test); % use some detector 1-data
expected_TOF     = raw.get_loaded(2, events_to_test); % use some detector 2-data
% Do the merging of output data
expected_count1 = (expected_count1(1:3:end) + expected_count1(2:3:end) + expected_count1(3:3:end));
expected_count2 = (expected_count2(1:3:end) + expected_count2(2:3:end) + expected_count2(3:3:end));
expected_abs_t  = (expected_abs_t(1:3:end) + expected_abs_t(2:3:end) + expected_abs_t(3:3:end)) / 3;

rg = RegroupedDLT.regroup(raw, 'count', 3);

assertEqual(expected_count1, rg.get_hit_count(1, groups_to_test), 'Hit count check for detector 1.');
assertEqual(expected_count2, rg.get_hit_count(2, groups_to_test), 'Hit count check for detector 2.');
assertEqual(expected_abs_t, rg.absolute_group_trigger_time(groups_to_test), 'Absolute time averaging.');
[~, XY] = rg.get_loaded(1, groups_to_test);
assertEqual(expected_XY, XY, 'Concatenated XY hit data should be identical although the groups are larger.');
assertEqual(expected_TOF, rg.get_loaded(2, groups_to_test), 'Concatenated TOF hit data should be identical although the groups are larger.');
assertEqual(floor(raw.event_count / 3), rg.event_count, 'Expected event count, ignoring the last groups rather than grouping too few.');
assertEqual(sum(raw.get_hit_count(1, 1:(rg.event_count*3))), double(rg.get_hit_count(1)), 'Expected hit count to match sum of used groups from detector 1.');
assertEqual(sum(raw.get_hit_count(2, 1:(rg.event_count*3))), double(rg.get_hit_count(2)), 'Expected hit count to match sum of used groups from detector 2.');
assertEqual(0, double(rg.get_hit_count(3)), 'There were no groups for detector 3.');


function test_regrouping_time
% Test with a fixed group trigger time interval per new group.
global filename2; raw = DLT(filename2); raw.read();

interval = 0.004; %[s]
% start = raw.absolute_group_trigger_time(1) - abs(diff(raw.absolute_group_trigger_time(1:2)))/2; % old
start = 1.6E-4 - interval/2; %[s] see "phase" in RegroupedDLT. This was manually assessed as OK for the test file
boundaries = start:interval:0.045; % range to 0.041 s gives 27 source events in the test file
intervals_to_test = 1:length(boundaries)-1; % 11 intervals (10 groups as one interval is empty)
events_to_test = 1:find(raw.absolute_group_trigger_time <= boundaries(end), 1, 'last'); % 31 source groups

[~, expected_XY] = raw.get_loaded(1, events_to_test); % use some detector 1-data
expected_TOF     = raw.get_loaded(2, events_to_test); % use some detector 2-data

rg = RegroupedDLT.regroup(raw, 'time', interval);
% 2015-02-11 when this test first succeeded it was checked that both time:unordered and time:ordered
% implementations in RegroupedDLT returned the same result if the data was nearly ordered (event 1 & 2 are disordered without effect on grouping)

g = 0;
for i = intervals_to_test
  which = find(boundaries(i) <= raw.absolute_group_trigger_time & raw.absolute_group_trigger_time < boundaries(i+1));
  if isempty(which)
    continue;
  end
  g = g + 1; % output group counter
  assertEqual(sum(raw.get_hit_count(1, which)), double(rg.get_hit_count(1, g)), sprintf('Hit count check for detector 1, for output group #%d.', g));
  assertEqual(sum(raw.get_hit_count(2, which)), double(rg.get_hit_count(2, g)), sprintf('Hit count check for detector 2, for output group #%d.', g));
  assertElementsAlmostEqual(mean(raw.absolute_group_trigger_time(which)), rg.absolute_group_trigger_time(g), 'relative',1E-14,  sprintf('Absolute time averaging, for output group #%d.', g));
  assertEqual(raw.get_loaded(2, which), rg.get_loaded(2, g), sprintf('Concatenated TOF hit data for output group #%d.', g));
end
assertEqual(10, g, 'Merging should give 10 groups');
assertEqual(raw.get_hit_count(':'), rg.get_hit_count(':'), 'Regrouping by time should not change the total hit count.');
[~, XY] = rg.get_loaded(1, 1:g);
assertEqual(expected_XY, XY, 'Concatenated XY hit data should be identical although the groups are larger.');
assertEqual(expected_TOF, rg.get_loaded(2, 1:g), 'Concatenated TOF hit data should be identical although the groups are larger.');


function test_regrouping_shuffle
% Test with a fixed number of loaded events per new group, but randomized order.
global filename2; raw = DLT(filename2); raw.read();


rg = RegroupedDLT.cut(raw, 'time', 0.4, 100); % an select times between 0.4 and 100 s
rg_excluded = RegroupedDLT.cut(raw, 'time', 100, 0.4); % a negated filter

assertEqual(raw.get_hit_count(':'), rg_excluded.get_hit_count(':') + rg.get_hit_count(':'), 'Total hit count conserved by normal + negated cuts.')
assertEqual(raw.event_count, rg_excluded.event_count + rg.event_count, 'Total event count conserved by normal + negated cuts.')
assert(any(raw.get_hit_count(':') > rg.get_hit_count(':')), 'The cut removes some hits.')
assert(any(raw.event_count > rg.event_count), 'The cut removes some events.')
assert(all(rg.absolute_group_trigger_time >= 0.4 & rg.absolute_group_trigger_time < 100), 'Respect range of normal filter.');
assert(~any(rg_excluded.absolute_group_trigger_time >= 0.4 & rg_excluded.absolute_group_trigger_time < 100), 'Respect range of negative filter.');

% Test also that decorrelating the hits changes the hit values but not the count
old_det2_T = rg.get_loaded(2);
[~, old_det1_XY] = rg.get_loaded(1);
old_hit_count1 = rg.get_hit_count(1,[]);
old_hit_count2 = rg.get_hit_count(2,[]);

rg.shuffle_hits();

assert(any(old_det2_T ~= rg.get_loaded(2)), 'Some hit coordinate is expected to differ. That they are equal by chance is very unlikely (but try re-running the test).');
[~, new_det1_XY] = rg.get_loaded(1);
assert(any(any(new_det1_XY ~= old_det1_XY)), 'Some hit coordinate is expected to differ. That they are equal by chance is very unlikely (but try re-running the test).');
assertEqual(old_hit_count1, rg.get_hit_count(1,[]), 'The hit count should not be affected by hit shuffling.');
assertEqual(old_hit_count2, rg.get_hit_count(2,[]), 'The hit count should not be affected by hit shuffling.');



%% Merging
% 
% function test_merging_none
% % Test merging two DLT instances, without regrouping.
% 
% function test_merging_count
% % Test merging two DLT instances without time adjustment, regrouping by count.
% 
% function test_merging_time
% % Test merging two DLT instances with time adjustment, with regrouping by time.

