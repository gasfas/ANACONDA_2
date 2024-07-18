function [exp_md] = ICE_plot(exp_md)
% This convenience funciton lists the default plotting metadata, and can be
% read by other experiment-specific metadata files.

%% IF DO
% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1

d1.labels_to_show     = exp_md.sample.fragment.masses;

% Specify which plot to show:
% d1.ifdo.BR_Ci							= true;
% d1.ifdo.TOF							= true;
d1.ifdo.m2q							= true;
% d1.ifdo.TOF_X						= true;
% d1.ifdo.TOF_R						= true;
% d1.ifdo.XY						= true;
% d1.ifdo.dp						= true;
% d1.ifdo.p_norm					= true;
% d1.ifdo.p_sum_norm				= true;
% d1.ifdo.p_sum						= true;
% d1.ifdo.TOF_hit1_hit2				= true;
% d1.ifdo.m2q_hit1_hit2				= true;
% d1.ifdo.angle_p_corr_C2				= true;
% d1.ifdo.angle_p_corr_p				= true;

% Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 

% Specify which plot to show:
% d2.ifdo.TOF				= true;
% d2.ifdo.BR_Ci			= true;
d2.ifdo.XY         	    = true;
% d2.ifdo.TOF_hit1_hit2   = true;
% d2.ifdo.dpxy         	= true;
% d2.ifdo.theta_R		= true;


% cross-detector histograms:
exp_md.plot.e.ifdo.m2q_2_KER	= false;

% load the signal plotting metadata:
signals = exp_md.plot.signal;

%% %%%%%%%%%%%%%%%%%%%%%%% PLOTTYPE DEFAULTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1
d1.BR_Ci						= metadata.create.plot.signal_2_plot({signals.i_mult});
d1.BR_Ci.GraphObj.Type			= 'bar';
d1.BR_Ci.hist.Integrated_value		= 1;
d1.BR_Ci.axes.Title.String		= 'Ion detector multiplicity';

d1.TOF							= metadata.create.plot.signal_2_plot({signals.i_TOF});
d1.TOF.hist.Integrated_value	= 1;
d1.TOF.hist.Intensity_scaling = 'Logarithmic';
d1.TOF.GraphObj.ax_nr			= 1;
d1.TOF.axes.Position			= plot.ax.Position('Full');
% Axes properties:
% d1.TOF.axes.YTick			= [0:1e3:1e4];
% d1.TOF.axes.YLim				= [0 0.7e4];
% d1.TOF.axes						= macro.plot.add_axes(d1.TOF.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q', 'X');

d1.m2q							= metadata.create.plot.signal_2_plot({signals.i_m2q});
d1.m2q.hist.Integrated_value	= 1;
d1.m2q.axes.Position			= plot.ax.Position('Full');
% d1.m2q.cond                     = exp_md.cond.BR;
d1.m2q.cond                  =  exp_md.cond.BR;
d1.m2q.cond.label            = exp_md.cond.def.label;
d1.m2q.cond.label.value      = [80];
% Axes properties:
% d1.m2q.axes.YTick			= [0:1e3:1e4];
% d1.m2q.axes.YLim				= [0 0.7e4];

d1.TOF_hit1_hit2				= metadata.create.plot.signal_2_plot({signals.i_TOF, signals.i_TOF});
d1.TOF_hit1_hit2.hist.hitselect = [1, 2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
d1.TOF_hit1_hit2.hist.binsize	= d1.TOF_hit1_hit2.hist.binsize;
d1.TOF_hit1_hit2.axes.axis		= 'equal';
d1.TOF_hit1_hit2.axes			= macro.plot.add_axes(d1.TOF_hit1_hit2.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q');
% d1.TOF_hit1_hit2.cond			= exp_md.cond.def.X_X; 

d1.m2q_hit1_hit2				= metadata.create.plot.signal_2_plot({signals.i_m2q, signals.i_m2q});
d1.m2q_hit1_hit2.hist.hitselect = [1, 2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
% d1.m2q_hit1_hit2.hist.binsize	= d1.TOF_hit1_hit2.hist.binsize;
d1.m2q_hit1_hit2.axes.axis		= 'equal';

d1.TOF_X						= metadata.create.plot.signal_2_plot({signals.i_TOF, signals.i_X});
d1.TOF_X.figure.Position		= plot.fig.Position('N');
d1.TOF_X.axes.XTickLabelRotation = 45;
d1.TOF_X.axes.Position			= [0.05 0.2 0.9 0.6];
d1.TOF_X.axes					= macro.plot.add_axes(d1.TOF_X.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q', 'X');

d1.TOF_R						= metadata.create.plot.signal_2_plot({signals.i_TOF, signals.i_R});
d1.TOF_R.figure.Position		= plot.fig.Position('N');
d1.TOF_R.axes.Position			= plot.ax.Position('Full');
d1.TOF_R.axes					= macro.plot.add_axes(d1.TOF_R.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q', 'X');

d1.XY						= metadata.create.plot.signal_2_plot({signals.i_X, signals.i_Y});
d1.XY.figure.Position		= plot.fig.Position('SE');
d1.XY.axes.Title.String		= 'Ion detector image';
d1.XY.axes.axis				= 'equal';

d1.dp						= metadata.create.plot.signal_2_plot({signals.i_dp});
d1.dp.figure.Position		= plot.fig.Position('Full');

d1.p_norm					= metadata.create.plot.signal_2_plot({signals.i_p_norm});
d1.p_norm.figure.Position		= plot.fig.Position('SE');

d1.p_sum					= metadata.create.plot.signal_2_plot({signals.i_p_sum});
d1.p_sum.figure.Position		= plot.fig.Position('SW');
d1.p_sum.GraphObj.contourvalue = 0.95;
d1.p_sum.GraphObj.Type	= 'projection';
d1.p_sum.figure.Position = plot.fig.Position('E');

d1.p_sum_norm					= metadata.create.plot.signal_2_plot({signals.i_p_sum_norm});
d1.p_sum_norm.figure.Position		= plot.fig.Position('SE');
d1.p_sum_norm.axes.YLim				= [0 0.03];
d1.p_sum_norm.figure.Position = plot.fig.Position('SW');
d1.p_sum_norm.hist.Integrated_value = 1;

d1.angle_p_corr_C2.axes.Type	= 'polaraxes';
d1.angle_p_corr_C2				= metadata.create.plot.signal_2_plot({signals.i_angle_p_corr_C2}, d1.angle_p_corr_C2);
d1.angle_p_corr_C2.figure.Position = [1200 500 600 300];
d1.angle_p_corr_C2.hist.Integrated_value = 1;

d1.angle_p_corr_p.axes.Type	= 'polaraxes';
d1.angle_p_corr_p				= metadata.create.plot.signal_2_plot({signals.i_angle_p_corr_C2, signals.i_p_norm}, d1.angle_p_corr_p);
d1.angle_p_corr_p.hist.hitselect = [NaN, 2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
d1.angle_p_corr_p.hist.binsize	= 2* d1.angle_p_corr_p.hist.binsize;

% % Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 

d2.BR_Ci						= metadata.create.plot.signal_2_plot({signals.e_mult});
d2.BR_Ci.GraphObj.Type			= 'bar';
d2.BR_Ci.hist.Integrated_value		= 1;
d2.BR_Ci.axes.Title.String			= 'Electron detector multiplicity';

d2.TOF_hit1_hit2				= metadata.create.plot.signal_2_plot({signals.e_TOF, signals.e_TOF});
d2.TOF_hit1_hit2.hist.hitselect = [1, 2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
d2.TOF_hit1_hit2.hist.binsize	= d2.TOF_hit1_hit2.hist.binsize;
d2.TOF_hit1_hit2.axes.axis		= 'equal';
% d2.TOF_hit1_hit2.cond			= exp_md.cond.def.X_X; 

d2.theta_R						= metadata.create.plot.signal_2_plot({signals.e_Theta, signals.e_R});
d2.theta_R.figure.Position		= plot.fig.Position('SE');
% d2.theta_R.axes.YLim			= [20 35];
d2.theta_R.cond.ion             =  macro.filter.write_coincidence_condition(1, 'det1');
d2.theta_R.cond.elec            =  macro.filter.write_coincidence_condition(2, 'det2');

d2.XY						= metadata.create.plot.signal_2_plot({signals.e_X, signals.e_Y});
% d2.XY.figure.Position		= [1500 1000 440 460];
d2.XY.axes.Title.String		= 'Electron detector image';
d2.XY.axes.axis				= 'equal';
d2.XY.cond                  =  exp_md.cond.BR;
d2.XY.cond.label            = exp_md.cond.def.label;
d2.XY.cond.label.value      = [80]


d2.TOF						= metadata.create.plot.signal_2_plot({signals.e_TOF});
d2.TOF.axes.Title.String		= 'Electron TOF';

d2.dpxy						= metadata.create.plot.signal_2_plot({signals.e_dpx, signals.e_dpy});
d2.dpxy.figure.Position		= [1500 1000 440 460];
d2.dpxy.figure.Position		= plot.fig.Position('NE');
d2.dpxy.axes.axis				= 'equal';

exp_md.plot.det1 = d1;
exp_md.plot.det2 = d2;
end