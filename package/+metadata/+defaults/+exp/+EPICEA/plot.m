function [exp_md] = plot(exp_md)
% This convenience funciton lists the default plotting metadata, and can be
% read by other experiment-specific metadata files.


%% IF DO
% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1

% Specify which plot to show:
% d1.ifdo.BR_Ci			= true;
% d1.ifdo.XY         	= true;
% d1.ifdo.theta_R		= true;
% d1.ifdo.theta_E		= true;
% d1.ifdo.R				= true;
% d1.ifdo.E				= true;

% Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 

d2.labels_to_show     = exp_md.sample.fragment.masses;

% Specify which plot to show:
d2.ifdo.BR_Ci							= true;
% d2.ifdo.TOF							= true;
% d2.ifdo.TOF_X						= true;
% d2.ifdo.TOF_R						= true;
% d2.ifdo.XY						= true;
% d2.ifdo.dp						= true;
% d2.ifdo.p_norm					= true;
% d2.ifdo.dp_sum_norm				= true;
% d2.ifdo.dp_sum						= true;
% d2.ifdo.TOF_hit1_hit2				= true;
% d2.ifdo.m2q_hit1_hit2				= true;
% d2.ifdo.angle_p_corr_C2				= true;
% d2.ifdo.angle_p_corr_p				= true;
% d2.ifdo.p_norm_hit1_hit2			= true;
% d2.ifdo.Dalitz_C2					= true;
% d2.ifdo.KER_sum					= true;

% cross-detector histograms:
% exp_md.plot.e.ifdo.m2q_2_KER	= false;

% load the signal plotting metadata:
exp_md = metadata.defaults.exp.EPICEA.plot_signals(exp_md);
signals = exp_md.plot.signal;

%% %%%%%%%%%%%%%%%%%%%%%%% PLOTTYPE DEFAULTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1
d1.BR_Ci						= metadata.create.plot.signal_2_plot({signals.e_mult});
d1.BR_Ci.GraphObj.Type			= 'bar';
d1.BR_Ci.hist.Integrated_value		= 1;
d1.BR_Ci.axes.Title.String			= 'Electron detector multiplicity';

d1.theta_R						= metadata.create.plot.signal_2_plot({signals.e_Theta, signals.e_R});
d1.theta_R.figure.Position		= plot.fig.Position('SE');
% d1.theta_R.cond					= exp_md.cond.e_KE;

d1.R						= metadata.create.plot.signal_2_plot({signals.e_R_only});
d1.R.axes.camroll			= 90;
d1.R.axes.Position			= [0.1 0.2 0.6 0.6];
d1.R.axes.YTickLabel		= '';
d1.R.figure.Position		= [1400 434 300   540];
d1.R.axes.XAxisLocation		= 'top';
d1.R.axes.YDir	= 'reverse';
d1.R.axes.XDir				= 'reverse';

d1.E						= metadata.create.plot.signal_2_plot({signals.e_E});
d1.E.axes.camroll			= -90;
d1.E.axes.Position			= [0.1 0.2 0.6 0.6];
d1.E.axes.YTickLabel		= '';
d1.E.figure.Position		= [1400 434 300   540];
d1.E.axes.XAxisLocation		= 'top';

d1.XY						= metadata.create.plot.signal_2_plot({signals.e_X, signals.e_Y});
d1.XY.figure.Position		= plot.fig.Position('SE');

d1.theta_E						= metadata.create.plot.signal_2_plot({signals.e_Theta, signals.e_E});
d1.theta_E.figure.Position		= plot.fig.Position('SE');

% % Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 
d2.BR_Ci						= metadata.create.plot.signal_2_plot({signals.i_mult});
d2.BR_Ci.GraphObj.Type			= 'bar';
d2.BR_Ci.hist.Integrated_value		= 1;
d2.BR_Ci.axes.Title.String		= 'Ion detector multiplicity';
d2.BR_Ci.cond					= exp_md.cond.e_KE;

d2.TOF							= metadata.create.plot.signal_2_plot({signals.i_TOF});
d2.TOF.hist.Integrated_value	= 1;
d2.TOF.GraphObj.ax_nr			= 1;
d2.TOF.axes.Position			= plot.ax.Position('Full');
% Axes properties:
d2.TOF.axes(1).YTick			= linspace(0, 1, 101);
d2.TOF.axes(1).YLim				= [0 0.01];
d2.TOF.axes						= macro.plot.add_axes(d2.TOF.axes(1), signals.add_m2q.axes, exp_md.conv.det2, 'm2q', 'X');

d2.TOF_hit1_hit2				= metadata.create.plot.signal_2_plot({signals.i_TOF, signals.i_TOF});
d2.TOF_hit1_hit2.hist.hitselect = [1, 2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
d2.TOF_hit1_hit2.hist.bgr		= metadata.create.plot.signal_2_plot({signals.i_TOF_bgr, signals.i_TOF_bgr});
d2.TOF_hit1_hit2.hist.bgr.hist.hitselect = [1, 2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
d2.TOF_hit1_hit2.hist.bgr.weight	= 0;
d2.TOF_hit1_hit2.hist.Intensity_scaling = 'linear';
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

d2.m2q_hit1_hit2				= metadata.create.plot.signal_2_plot({signals.i_m2q, signals.i_m2q});
d2.m2q_hit1_hit2.hist.hitselect = [1, 2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
d2.m2q_hit1_hit2.hist.binsize	= [0.4 0.4];
d2.m2q_hit1_hit2.hist.Intensity_scaling = 'linear';
d2.m2q_hit1_hit2.hist.bgr		= metadata.create.plot.signal_2_plot({signals.i_m2q, signals.i_m2q});
d2.m2q_hit1_hit2.hist.bgr.hist.hitselect = [1, 2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
d2.m2q_hit1_hit2.hist.bgr.weight	= 0.01;

d2.m2q_hit1_hit2.axes.axis		= 'equal';
d2.m2q_hit1_hit2.axes.XTick		= d2.m2q_hit1_hit2.axes.XTick(d2.m2q_hit1_hit2.axes.XTick ~= 31);
d2.m2q_hit1_hit2.axes.XTickLabel	= d2.m2q_hit1_hit2.axes.XTickLabel(d2.m2q_hit1_hit2.axes.XTickLabel ~= 31);
d2.m2q_hit1_hit2.axes.FontSize	= 12;
d2.m2q_hit1_hit2.axes.colormap			= plot.custom_RGB_colormap('w', 'r', 0, 0.7);

d2.m2q_hit1_hit2.cond			= exp_md.cond.def.REAL_TRG;
d2.m2q_hit1_hit2.figure.Position = [1200 100 700 800];

d2.XY						= metadata.create.plot.signal_2_plot({signals.i_X, signals.i_Y});
d2.XY.figure.Position		= plot.fig.Position('SE');

d2.dp						= metadata.create.plot.signal_2_plot({signals.i_dp});
d2.dp.figure.Position		= plot.fig.Position('Full');

d2.p_norm_hit1_hit2					= metadata.create.plot.signal_2_plot({signals.i_p_norm, signals.i_p_norm});
d2.p_norm_hit1_hit2.hist.hitselect	= [1, 2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
d2.p_norm_hit1_hit2.axes.axis		= 'equal';
[d2.p_norm_hit1_hit2.axes.XLabel.String, d2.p_norm_hit1_hit2.axes.YLabel.String]	= deal('$|p|$ hit 1 [a.u.]', '$|p|$ hit 2 [a.u.]');
d2.p_norm_hit1_hit2.cond			= exp_md.cond.CHx_CF3;

d2.p_norm					= metadata.create.plot.signal_2_plot({signals.i_p_norm});
d2.p_norm.figure.Position		= plot.fig.Position('SE');
d2.p_norm.hist.hitselect		= [1];
% d2.p_norm.cond				= exp_md.cond.Npl_Npl;
d2.p_norm.cond			= exp_md.cond.CHx_CF3;

d2.dp_sum					= metadata.create.plot.signal_2_plot({signals.i_dp_sum});
d2.dp_sum.figure.Position		= plot.fig.Position('SW');
d2.dp_sum.cond			= exp_md.cond.Npl_Npl;
d2.dp_sum.GraphObj.contourvalue = 0.95;
d2.dp_sum.GraphObj.Type	= 'projection';
d2.dp_sum.figure.Position = plot.fig.Position('E');
d2.dp_sum.cond			= exp_md.cond.C2Hx_CF3;

d2.dp_sum_norm					= metadata.create.plot.signal_2_plot({signals.i_dp_sum_norm});
d2.dp_sum_norm.figure.Position		= plot.fig.Position('SE');
d2.dp_sum_norm.axes.YLim				= [0 0.03];
d2.dp_sum_norm.figure.Position = plot.fig.Position('SW');
d2.dp_sum_norm.hist.Integrated_value = 1;
d2.dp_sum_norm.cond			= exp_md.cond.C2Hx_CF3;

d2.angle_p_corr_C2.axes.Type	= 'polaraxes';
d2.angle_p_corr_C2				= metadata.create.plot.signal_2_plot({signals.i_angle_p_corr_C2}, d2.angle_p_corr_C2);
d2.angle_p_corr_C2.figure.Position = [1200 500 600 300];
d2.angle_p_corr_C2.hist.Integrated_value = 1;
d2.angle_p_corr_C2.cond			= exp_md.cond.C2Hx_CF3;

d2.angle_p_corr_p.axes.Type	= 'polaraxes';
d2.angle_p_corr_p				= metadata.create.plot.signal_2_plot({signals.i_angle_p_corr_C2, signals.i_p_norm}, d2.angle_p_corr_p);
d2.angle_p_corr_p.hist.hitselect = [NaN, 2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
d2.angle_p_corr_p.hist.binsize(2)= 2*d2.angle_p_corr_p.hist.binsize(2);
d2.angle_p_corr_p.cond			= exp_md.cond.CHx_CF3;

d2.Dalitz_C2.Type				= 'ternary';
d2.Dalitz_C2					= metadata.create.plot.signal_2_plot({signals.i_p_norm, signals.i_p_norm, signals.i_dp_sum_norm}, d2.Dalitz_C2);
d2.Dalitz_C2.hist.hitselect		= [1, 2, NaN]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
d2.Dalitz_C2.figure.Position	= [1200 300 600  600];
d2.Dalitz_C2.figure.Name		= 'C2Hx_CF2';
% d2.Dalitz_C2.axes.XLabel.String		= '$|p_1|$ (CH$_3^+$) [a.u.]';
d2.Dalitz_C2.axes.XLabel.String		= '$|p_1|$ (C$_2$H$_3^+$) [a.u.]';
d2.Dalitz_C2.axes.YLabel.String		= '$|p_2|$ (CF$_2^+$) [a.u.]';
d2.Dalitz_C2.axes.ZLabel.String		= '$|p_{res}|$ [a.u.]';
% d2.Dalitz_C2.axes.Xlim_scaled		= [0 0.5];
% d2.Dalitz_C2.axes.Ylim_scaled		= [0 0.5];
% d2.Dalitz_C2.axes.Zlim_scaled		= [0 0.5];
d2.Dalitz_C2.axes.colormap			= plot.custom_RGB_colormap('w', 'k');

d2.Dalitz_C2.axes.axis		= 'equal';
d2.Dalitz_C2.cond			= exp_md.cond.C2Hx_CF2;

% KER sum plot:
d2.KER_sum							= metadata.create.plot.signal_2_plot({signals.i_KER_sum});
d2.KER_sum.hist.Integrated_value	= 1;
% d2.KER_sum.cond						= exp_md.cond.NH_H;


exp_md.plot.det1 = d1;
exp_md.plot.det2 = d2;
end