function [exp_md] = plot(exp_md)
% This convenience funciton lists the default plotting metadata, and can be
% read by other experiment-specific metadata files.


%% IF DO
% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1

% Specify which plot to show:
% d1.ifdo.BR_Ci			= true;
d1.ifdo.XY         	= true;
d1.ifdo.dpxy         	= true;
d1.ifdo.theta_R		= false;

% Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 

d2.labels_to_show     = exp_md.sample.fragment.masses;

% Specify which plot to show:
d2.ifdo.BR_Ci							= false;
d2.ifdo.TOF							= false;
d2.ifdo.TOF_X						= false;
d2.ifdo.TOF_R						= false;
d2.ifdo.XY                          = false;
d2.ifdo.dp                          = false;
d2.ifdo.p_norm                      = false;
d2.ifdo.p_sum_norm                  = false;
d2.ifdo.p_sum						= false;
d2.ifdo.TOF_hit1_hit2				= false;
d2.ifdo.m2q_hit1_hit2				= false;
d2.ifdo.angle_p_corr_C2				= false;
d2.ifdo.angle_p_corr_p				= false;

% cross-detector histograms:
exp_md.plot.e.ifdo.m2q_2_KER	= false;

% load the signal plotting metadata:
exp_md = metadata.defaults.exp.Laksman_TOF_e_XY.plot_signals(exp_md);
signals = exp_md.plot.signal;

%% %%%%%%%%%%%%%%%%%%%%%%% PLOTTYPE DEFAULTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1
d1.BR_Ci						= metadata.create.plot.signal_2_plot({signals.e_mult});
d1.BR_Ci.GraphObj.Type			= 'bar';
d1.BR_Ci.hist.Integrated_value		= 1;
d1.BR_Ci.axes.Title.String			= 'Electron detector multiplicity';

d1.theta_R						= metadata.create.plot.signal_2_plot({signals.e_Theta, signals.e_R});
d1.theta_R.figure.Position		= plot.fig.Position('SE');
d1.theta_R.axes.YLim			= [20 35];

d1.XY						= metadata.create.plot.signal_2_plot({signals.e_X, signals.e_Y});
d1.XY.figure.Position		= [200 200 440 460];
d1.XY.axes.Title.String		= 'Electron detector image';
d1.XY.axes.axis				= 'equal';

d1.dpxy						= metadata.create.plot.signal_2_plot({signals.e_dpx, signals.e_dpy});
d1.dpxy.figure.Position		= [200 200 440 460];
d1.dpxy.figure.Position		= plot.fig.Position('NE');
d1.dpxy.axes.axis				= 'equal';
d1.dpxy.axes(1).Title.String= 'Electron momentum';

% % Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 
d2.BR_Ci						= metadata.create.plot.signal_2_plot({signals.i_mult});
d2.BR_Ci.GraphObj.Type			= 'bar';
d2.BR_Ci.hist.Integrated_value		= 1;
d2.BR_Ci.axes.Title.String		= 'Ion detector multiplicity';

d2.TOF							= metadata.create.plot.signal_2_plot({signals.i_TOF});
d2.TOF.hist.Integrated_value	= 1;
d2.TOF.GraphObj.ax_nr			= 1;
d2.TOF.axes.Position			= plot.ax.Position('Full');
% Axes properties:
d2.TOF.axes(1).YTick			= linspace(0, 1, 101);
d2.TOF.axes(1).YLim				= [0 0.5];
d2.TOF.axes						= macro.plot.add_axes(d2.TOF.axes(1), signals.add_m2q.axes, exp_md.conv.det2, 'm2q', 'X');

d2.TOF_hit1_hit2				= metadata.create.plot.signal_2_plot({signals.i_TOF, signals.i_TOF});
d2.TOF_hit1_hit2.hist.hitselect = [1, 2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
d2.TOF_hit1_hit2.hist.binsize	= d2.TOF_hit1_hit2.hist.binsize;
d2.TOF_hit1_hit2.axes.axis		= 'equal';
d2.TOF_hit1_hit2.axes			= macro.plot.add_axes(d2.TOF_hit1_hit2.axes(1), signals.add_m2q.axes, exp_md.conv.det2, 'm2q');

d2.TOF_X						= metadata.create.plot.signal_2_plot({signals.i_TOF, signals.i_X});
d2.TOF_X.figure.Position		= plot.fig.Position('N');
d2.TOF_X.axes.XTickLabelRotation = 45;
d2.TOF_X.axes.Position			= [0.05 0.2 0.9 0.6];
d2.TOF_X.axes					= macro.plot.add_axes(d2.TOF_X.axes(1), signals.add_m2q.axes, exp_md.conv.det2, 'm2q', 'X');

d2.TOF_R						= metadata.create.plot.signal_2_plot({signals.i_TOF, signals.i_R});
d2.TOF_R.figure.Position		= plot.fig.Position('N');
d2.TOF_R.axes.Position			= plot.ax.Position('Full');
d2.TOF_R.axes					= macro.plot.add_axes(d2.TOF_R.axes(1), signals.add_m2q.axes, exp_md.conv.det2, 'm2q', 'X');

d2.XY						= metadata.create.plot.signal_2_plot({signals.i_X, signals.i_Y});
d2.XY.figure.Position		= plot.fig.Position('SE');
d2.XY.axes.Title.String		= 'Ion detector image';
d2.XY.axes.axis				= 'equal';

d2.dp						= metadata.create.plot.signal_2_plot({signals.i_dp});
d2.dp.figure.Position		= plot.fig.Position('Full');

d2.p_norm					= metadata.create.plot.signal_2_plot({signals.i_p_norm});
d2.p_norm.figure.Position		= plot.fig.Position('SE');

d2.p_sum					= metadata.create.plot.signal_2_plot({signals.i_p_sum});
d2.p_sum.figure.Position		= plot.fig.Position('SW');
d2.p_sum.GraphObj.contourvalue = 0.95;
d2.p_sum.GraphObj.Type	= 'projection';
d2.p_sum.figure.Position = plot.fig.Position('E');

d2.p_sum_norm					= metadata.create.plot.signal_2_plot({signals.i_p_sum_norm});
d2.p_sum_norm.figure.Position		= plot.fig.Position('SE');
d2.p_sum_norm.axes.YLim				= [0 0.03];
d2.p_sum_norm.figure.Position = plot.fig.Position('SW');
d2.p_sum_norm.hist.Integrated_value = 1;

d2.angle_p_corr_C2.axes.Type	= 'polaraxes';
d2.angle_p_corr_C2				= metadata.create.plot.signal_2_plot({signals.i_angle_p_corr_C2}, d2.angle_p_corr_C2);
d2.angle_p_corr_C2.figure.Position = [1200 500 600 300];
d2.angle_p_corr_C2.hist.Integrated_value = 1;

d2.angle_p_corr_p.axes.Type	= 'polaraxes';
d2.angle_p_corr_p				= metadata.create.plot.signal_2_plot({signals.i_angle_p_corr_C2, signals.i_p_norm}, d2.angle_p_corr_p);
d2.angle_p_corr_p.hist.hitselect = [NaN, 2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
d2.angle_p_corr_p.hist.binsize	= 2* d2.angle_p_corr_p.hist.binsize;

exp_md.plot.det1 = d1;
exp_md.plot.det2 = d2;
end