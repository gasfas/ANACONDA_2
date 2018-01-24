function [ noise_fraction ] = shuffle_signal(exp, md)
% This macro verifies the data conversion and gives an estimate for the
% amount of false coincidences by shuffling the raw data and treating
% it, subsequently comparing it to the results from the original data.
% Input:
% exp		The experimental data
% calib_md	The calibration metadata.
% Output:
% 

calib_md = md.calib.signal_shuffle;

% Fetch the data pointers of the raw data to convert:
exp_unshuffled	= exp;
exp_shuffled	= exp;

detnr			= calib_md.detnr;

% shuffle the data:
for i = detnr
	detname = ['det' num2str(detnr)];
	raw_shuffled					= general.vector.shuffle(exp_shuffled.h.(detname).raw, calib_md.shuffle);
	exp_shuffled.h.(detname)		= [];
	exp_shuffled.h.(detname).raw	= raw_shuffled;
end

% Correct and convert:
exp_shuffled = macro.all(exp_shuffled, md, {'correct', 'convert'});

% compare the unshuffled and shuffled:
e_f_unshuffled	= macro.filter.conditions_2_filter(exp_unshuffled, calib_md.cond);
e_f_shuffled	= macro.filter.conditions_2_filter(exp_shuffled, calib_md.cond);

noise_fraction = sum(e_f_shuffled)/sum(e_f_unshuffled)*100;
disp(['Shuffled:   ' num2str(sum(e_f_shuffled)) ' events,'])
disp(['Unshuffled: ' num2str(sum(e_f_unshuffled)) ' events, '])
disp(['that is ' num2str(noise_fraction, 2) ' % of the number of unshuffled events. Method: ' calib_md.shuffle.method])

end