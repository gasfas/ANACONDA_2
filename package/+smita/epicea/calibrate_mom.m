%% Load data
clear
addpath('E:\PhD\Adamantane_data\data')
addpath('E:\PhD\Anaconda2\ANACONDA_2\package\+smita\epicea')

S =data_list_adamantane;
%%
dir= S(3).dir_ada;
mdata = IO.import_metadata(dir);
% mdata.spec.Efield = mdata.spec.Efield.*0.67;
% mdata.spec.Efield = mdata.spec.Efield.*0.8;

raw_data = IO.import_raw(dir);
data            = macro.filter(raw_data, mdata); %define the multiplicity of events
data_corrected = macro.correct(data, mdata);
data_converted = macro.convert(data_corrected, mdata);
data_stats = get_data_stats(data_converted);
%% RT plot
get_rt_plot(data_converted, data_stats, mdata);
% convert.m2q_2_TOF(29,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0)
%% Calibrate momentum
mdata = IO.import_metadata(dir);
macro.plot(data_converted,mdata);
% mdata.plot.det2.m2q.cond = mdata.calib.det2.momentum.cond;
% macro.plot(data_converted,mdata);
% macro.calibrate.Molecular_Beam(data_converted,2,mdata.calib.det2.MB)
% disp(mdata.spec.Efield)
macro.calibrate.momentum(data_converted,2,mdata);


