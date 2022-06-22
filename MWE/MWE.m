%% Small example of loading a single file, and to run the macros.
% where to find the file:
filename = '/home/ina/Documents/Lund/DLT_example/Argon_001';
filename = 'Argon_001';

%% Import the data:
mdata       = IO.import_metadata(filename); % Metadata
data        = IO.import_raw(filename); % Data

%% Treatment of the data

data = macro.correct(data, mdata);
data = macro.convert(data, mdata);
data = macro.filter(data, mdata);

%% Plot (demonstration of applying conditions to a plot)
% Make a single plot:
macro.plot.create.plot(data, mdata.plot.det1.KER_sum)
% add a condition to this plot:
mdata.plot.det1.KER_sum.cond.KER = mdata.cond.def.KER_sum;
mdata.plot.det1.KER_sum.cond.KER.value = [1 80]; % [eV]
mdata.plot.det1.KER_sum.axes.Title.String = 'KER filtered';
% And plot it again:
macro.plot.create.plot(data, mdata.plot.det1.KER_sum)

% % Make all plots the plot metadata asks for:
% [mdata]  = IO.import_metadata(filename);
% ax = macro.plot(data, mdata);

%% Calibration
% macro.calibrate.TOF_2_m2q(data, mdata.calib.det1.TOF_2_m2q)
% macro.calibrate.momentum(d.(exp_name), 1, md.(exp_name).calib.det1.momentum)
% macro.calibrate.R_circle(d.(exp_name).h.det1, md.(exp_name).calib.det1.R_circle)
% macro.calibrate.Molecular_Beam(d.(exp_name), 1, md.(exp_name).calib.det1.MB)