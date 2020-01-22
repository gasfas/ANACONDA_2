function [exp_md] = plot(exp_md)
% This convenience funciton lists the default plotting metadata, and can be
% read by other experiment-specific metadata files.


%% IF DO
% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1

d1.labels_to_show     = exp_md.sample.fragment.masses;

% Specify which plot to show:
d1.ifdo.BR_Ci						= false;
d1.ifdo.TOF							= false;
d1.ifdo.TOF_X						= false;
d1.ifdo.TOF_R						= false;
d1.ifdo.XY                          = false;
d1.ifdo.XY_filt                     = false;
d1.ifdo.dp                          = false;
d1.ifdo.dpyz                        = false;
d1.ifdo.dpxz                        = false;
d1.ifdo.dpxy                        = false;
d1.ifdo.p_norm                      = false;
d1.ifdo.p_sum_norm                  = false;
d1.ifdo.p_sum						= false;
d1.ifdo.TOF_hit1_hit2				= false;
d1.ifdo.m2q_hit1_hit2				= false;
d1.ifdo.angle_p_corr_C2				= false;
d1.ifdo.angle_p_corr_p				= false;

% Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 

% Specify which plot to show:
% d2.ifdo.BR_Ci			= true;
d2.ifdo.XY              = true;
d2.ifdo.TOF             = true;
d2.ifdo.XY_filt         = false;
d2.ifdo.dpxy            = false;
d2.ifdo.dpxz            = false;
d2.ifdo.dpyz            = false;
d2.ifdo.XYTOF           = false;
d2.ifdo.theta_R         = false;
d2.ifdo.TOF_X           = true;
d2.ifdo.TOF_Y           = false;
d2.ifdo.pz_X            = false;
d2.ifdo.px_TOF          = false;
d2.ifdo.KER_theta       = false;
d2.ifdo.dp              = false;

% cross-detector histograms:
exp_md.plot.e.ifdo.m2q_2_KER	= false;

% load the signal plotting metadata:
exp_md = metadata.defaults.exp.MAXLAB_REMI.plot_signals(exp_md);
signals = exp_md.plot.signal;

%% %%%%%%%%%%%%%%%%%%%%%%% PLOTTYPE DEFAULTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1% Detector 1

d1.BR_Ci						= metadata.create.plot.signal_2_plot({signals.i_mult});
d1.BR_Ci.GraphObj.Type			= 'bar';
d1.BR_Ci.hist.Integrated_value		= 1;
d1.BR_Ci.axes.Title.String		= 'Ion detector multiplicity';

d1.TOF							= metadata.create.plot.signal_2_plot({signals.i_TOF});
d1.TOF.hist.Integrated_value	= 1;
d1.TOF.GraphObj.ax_nr			= 1;
d1.TOF.axes.Position			= plot.ax.Position('Full');
% Axes properties:
d1.TOF.axes(1).YTick			= linspace(0, 1, 101);
d1.TOF.axes(1).YLim				= [0 0.5];
d1.TOF.axes						= macro.plot.add_axes(d1.TOF.axes(1), signals.add_m2q.axes, exp_md.conv.det2, 'm2q', 'X');

d1.TOF_hit1_hit2				= metadata.create.plot.signal_2_plot({signals.i_TOF, signals.i_TOF});
d1.TOF_hit1_hit2.hist.hitselect = [1, 2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
d1.TOF_hit1_hit2.hist.binsize	= d1.TOF_hit1_hit2.hist.binsize;
d1.TOF_hit1_hit2.axes.axis		= 'equal';
d1.TOF_hit1_hit2.axes			= macro.plot.add_axes(d1.TOF_hit1_hit2.axes(1), signals.add_m2q.axes, exp_md.conv.det2, 'm2q');

d1.TOF_X						= metadata.create.plot.signal_2_plot({signals.i_TOF, signals.i_X});
d1.TOF_X.figure.Position		= plot.fig.Position('N');
d1.TOF_X.axes.XTickLabelRotation = 45;
d1.TOF_X.axes.Position			= [0.05 0.2 0.9 0.6];
d1.TOF_X.axes					= macro.plot.add_axes(d1.TOF_X.axes(1), signals.add_m2q.axes, exp_md.conv.det2, 'm2q', 'X');

d1.TOF_R						= metadata.create.plot.signal_2_plot({signals.i_TOF, signals.i_R});
d1.TOF_R.figure.Position		= plot.fig.Position('N');
d1.TOF_R.axes.Position			= plot.ax.Position('Full');
d1.TOF_R.axes					= macro.plot.add_axes(d1.TOF_R.axes(1), signals.add_m2q.axes, exp_md.conv.det2, 'm2q', 'X');

d1.XY                               = metadata.create.plot.signal_2_plot({signals.i_X, signals.i_Y});
d1.XY.figure.Position               = plot.fig.Position('SE');
d1.XY.axes.Title.String             = 'Ion detector image';
d1.XY.axes.axis                     = 'equal';
d1.XY.axes.colormap                 = 'colormap';

d1.XY_filt                          = metadata.create.plot.signal_2_plot({signals.i_X, signals.i_Y});
d1.XY_filt.figure.Position          = plot.fig.Position('SE');
d1.XY_filt.axes.Title.String		= 'Ion detector image';
d1.XY_filt.axes.axis				= 'equal';
d1.XY_filt.axes.colormap			= 'colormap';
d1.XY_filt.cond                     = exp_md.cond.eRiXY;

d1.dp						= metadata.create.plot.signal_2_plot({signals.i_dp});
d1.dp.figure.Position		= plot.fig.Position('Full');
d1.dp.GraphObj.Type = 'patch';
d1.dp.GraphObj.contourvalue = 10;
d1.dp.GraphObj.FaceColor = 'r';

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

% d1.angle_p_corr_C2.axes.Type	= 'polaraxes';
% d1.angle_p_corr_C2				= metadata.create.plot.signal_2_plot({signals.i_angle_p_corr_C2}, d1.angle_p_corr_C2);
% d1.angle_p_corr_C2.figure.Position = [1200 500 600 300];
% d1.angle_p_corr_C2.hist.Integrated_value = 1;
% 
% d1.angle_p_corr_p.axes.Type	= 'polaraxes';
% d1.angle_p_corr_p				= metadata.create.plot.signal_2_plot({signals.i_angle_p_corr_C2, signals.i_p_norm}, d1.angle_p_corr_p);
% d1.angle_p_corr_p.hist.hitselect = [NaN, 2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
% d1.angle_p_corr_p.hist.binsize	= 2* d1.angle_p_corr_p.hist.binsize;

d1.dpyz                     = metadata.create.plot.signal_2_plot({signals.i_dpy, signals.i_dpz});
d1.dpyz.figure.Position		= [200 200 900 900];
% d2.dpyz.axes.axis				= 'equal';
d1.dpyz.axes(1).Title.String = 'Ion momentum py - pz';
%d2.dpyz.cond                  = exp_md.cond.e.mult;
%d1.dpyz.cond                = exp_md.cond.eRiXY;
d1.dpyz.axes.colormap       = 'jet';
d1.dpyz.axes.FontSize                 = 18;
d1.dpyz.axes.TitleFontSizeMultiplier  = 1.5;

d1.dpxz                     = metadata.create.plot.signal_2_plot({signals.i_dpx, signals.i_dpz});
d1.dpxz.figure.Position		= [200 200 900 900];
% d2.dpyz.axes.axis				= 'equal';
d1.dpxz.axes(1).Title.String = 'Ion momentum px - pz';
%d2.dpyz.cond                  = exp_md.cond.e.mult;
%d1.dpxz.cond                = exp_md.cond.eRiXY;
d1.dpxz.axes.colormap       = 'jet';
d1.dpxz.axes.FontSize                 = 18;
d1.dpxz.axes.TitleFontSizeMultiplier  = 1.5;

d1.dpxy                     = metadata.create.plot.signal_2_plot({signals.i_dpx, signals.i_dpy});
d1.dpxy.figure.Position		= [200 200 900 900];
% d2.dpyz.axes.axis				= 'equal';
d1.dpxy.axes(1).Title.String = 'Ion momentum px - pz';
%d2.dpyz.cond                  = exp_md.cond.e.mult;
%d1.dpxz.cond                = exp_md.cond.eRiXY;
d1.dpxy.axes.colormap       = 'jet';
d1.dpxy.axes.FontSize                 = 18;
d1.dpxy.axes.TitleFontSizeMultiplier  = 1.5;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 % Detector 2 

d2.TOF							= metadata.create.plot.signal_2_plot({signals.e_TOF});
d2.TOF.hist.Integrated_value	= 1;
d2.TOF.GraphObj.ax_nr			= 1;
d2.TOF.axes.Position			= plot.ax.Position('Full');
% Axes properties:
d2.TOF.axes(1).YTick			= linspace(0, 0.1, 101);
d2.TOF.axes(1).YLim				= [0 0.04];
d2.TOF.axes(1).XLim				= [0 100];
d2.TOF.axes						= macro.plot.add_axes(d2.TOF.axes(1), signals.add_m2q.axes, exp_md.conv.det2, 'm2q', 'X');


d2.BR_Ci						= metadata.create.plot.signal_2_plot({signals.e_mult});
d2.BR_Ci.GraphObj.Type			= 'bar';
d2.BR_Ci.hist.Integrated_value		= 1;
d2.BR_Ci.axes.Title.String			= 'Electron detector multiplicity';

d2.theta_R						= metadata.create.plot.signal_2_plot({signals.e_Theta, signals.e_R});
d2.theta_R.figure.Position		= plot.fig.Position('SE');
d2.theta_R.axes.YLim			= [20 35];

d2.KER_theta                    = metadata.create.plot.signal_2_plot({signals.e_KER_sum, signals.e_Theta});
d2.KER_theta.figure.Position	= [200 200 900 900];
d2.KER_theta.axes.Title.String    = 'Energy vs angle';
% d2.KER_theta.cond               = exp_md.cond.eRiXY;
d2.KER_theta.axes.colormap      = 'jet';

d2.XY						= metadata.create.plot.signal_2_plot({signals.e_X, signals.e_Y});
d2.XY.figure.Position		= [200 200 900 900];
d2.XY.axes.Title.String		= 'Electron detector image';
d2.XY.axes.colormap         = 'jet';
d2.XY.axes.XLim             = [-30 30];
d2.XY.axes.YLim             = [-30 30];
d2.XY.cond                  = exp_md.cond.i_XY;
 
d2.XYTOF						= metadata.create.plot.signal_2_plot({signals.e_X, signals.e_Y});
d2.XYTOF.figure.Position		= [200 200 900 900];
d2.XYTOF.axes.Title.String		= 'Electron detector image';
d2.XYTOF.axes.colormap     = 'jet';
%d2.XYTOF.cond               = exp_md.cond.tofe;

% d2.XY.axes.axis				= 'equal';
%d2.XY.cond                  = exp_md.cond.elec;
d2.XY_filt						= metadata.create.plot.signal_2_plot({signals.e_X, signals.e_Y});
d2.XY_filt.figure.Position		= [200 200 900 900];
d2.XY_filt.axes.Title.String		= 'Filtered electron detector image';
%5d2.XY_filt.cond                  = exp_md.cond.eRiXY;
d2.XY_filt.axes.colormap     = 'jet';

d2.dpxy						= metadata.create.plot.signal_2_plot({signals.e_dpx, signals.e_dpy});
d2.dpxy.figure.Position		= [200 200 900 900];
d2.dpxy.axes(1).Title.String = 'Electron momentum px - py';
d2.dpxy.axes.colormap       = jet;
% d2.dpxy.axes.colormap(1,:)  = [1 1 1];
%d2.dpxy.cond                  = exp_md.cond.e.mult;
%d2.dpxy.cond                = exp_md.cond.eRiXY;
d2.dpxy.axes.FontSize                 = 18;
d2.dpxy.axes.TitleFontSizeMultiplier  = 1.5;

d2.dpxz                     = metadata.create.plot.signal_2_plot({signals.e_dpx, signals.e_dpz});
d2.dpxz.figure.Position		= [200 200 900 900];
d2.dpxz.axes.colormap       = jet;
% d2.dpxz.axes.colormap(1,:)  = [1 1 1];
% d2.dpxz.axes.axis				= 'equal';
d2.dpxz.axes(1).Title.String = 'Electron momentum px pz';
%d2.dpxz.cond                =  exp_md.cond.eRiXY;
d2.dpxz.axes.FontSize                 = 18;
d2.dpxz.axes.TitleFontSizeMultiplier  = 1.5;

d2.dpyz                     = metadata.create.plot.signal_2_plot({signals.e_dpy, signals.e_dpz});
d2.dpyz.figure.Position		= [200 200 900 900];
% d2.dpyz.axes.axis				= 'equal';
d2.dpyz.axes(1).Title.String = 'Electron momentum py - pz';
%d2.dpyz.cond                  = exp_md.cond.e.mult;
%d2.dpyz.cond                = exp_md.cond.eRiXY;
d2.dpyz.axes.colormap       = jet;
% d2.dpyz.axes.colormap(1,:)  = [1 1 1];
% d2.dpyz.axes.colormap(
d2.dpyz.axes.FontSize                 = 18;
d2.dpyz.axes.TitleFontSizeMultiplier  = 1.5;

d2.dp						= metadata.create.plot.signal_2_plot({signals.e_dp});
d2.dp.figure.Position		= plot.fig.Position('Full');
d2.dp.GraphObj.Type = 'patch';
d2.dp.GraphObj.contourvalue = 0;
d2.dp.GraphObj.FaceColor = 'r';

d2.TOF_X						= metadata.create.plot.signal_2_plot({signals.e_TOF, signals.e_X});
d2.TOF_X.figure.Position		= [200 200 900 900];
d2.TOF_X.axes.XTickLabelRotation = 45;
%d2.TOF_X.axes.Position			= [0.05 0.2 0.9 0.6];
%d2.TOF_X.axes.axis					= 'equal';
d2.TOF_X.axes(1).Title.String   = 'Electron TOF vs X';
d2.TOF_X.axes(1).YLim          = [-40 40];
d2.TOF_X.axes(1).XLim          = [0 100];
% d2.TOF_X.cond                  = exp_md.cond.eRiXY;
d2.TOF_X.axes.colormap       = 'jet';

d2.TOF_Y						= metadata.create.plot.signal_2_plot({signals.e_TOF, signals.e_Y});
d2.TOF_Y.figure.Position		= [200 200 900 900];
d2.TOF_Y.axes.XTickLabelRotation = 45;
%d2.TOF_X.axes.Position			= [0.05 0.2 0.9 0.6];
%d2.TOF_X.axes.axis					= 'equal';
d2.TOF_Y.axes(1).Title.String   = 'Electron TOF vs Y';
%d2.TOF_Y.cond                    = exp_md.cond.eRiR;
d2.TOF_Y.axes.colormap       = 'jet';

d2.pz_X                         = metadata.create.plot.signal_2_plot({signals.e_dpz, signals.e_X});
d2.pz_X.figure.Position		= [200 200 440 460];
%d2.pz_X.axes.axis				= 'equal';
d2.pz_X.axes(1).Title.String = 'pz vs X';


d2.px_TOF                         = metadata.create.plot.signal_2_plot({signals.e_TOF, signals.e_dpx});
d2.px_TOF.figure.Position		= [200 200 440 460];
%d2.px_TOF.axes.axis				= 'equal';
d2.px_TOF.axes(1).Title.String = 'px vs TOF';
d2.px_TOF.axes(1).YLim          = [ -1 1];
d2.px_TOF.axes(1).XLim          = [72 130];
%d2.px_TOF.cond                    = exp_md.cond.eRiXY;
d2.px_TOF.axes.colormap          = 'jet';

% Energy vs Angle (2D plots)
d2.KER_polarxyz                         = metadata.create.plot.signal_2_plot({ signals.e_KER_sum ,signals.e_PolAngleXYZ});
d2.KER_polarxyz.figure.Position         = [200 200 900 900];
d2.KER_polarxyz.axes(1).Title.String    = 'KER vs azimuthal angle';
% d2.KER_polarxyz.axes(1).YLim            = [ -1 1];
% d2.KER_polarxyz.axes(1).XLim            = [72 130];
%d2.KER_polarxyz.cond                    = exp_md.cond.eRiXY;
d2.KER_polarxyz.axes.colormap           = 'jet';
d2.KER_polarxyz.axes.FontSize           = 18;
d2.KER_polarxyz.axes.TitleFontSizeMultiplier  = 1.5;

d2.KER_polarxz                              = metadata.create.plot.signal_2_plot({signals.e_KER_sum, signals.e_PolAngleXZ});
d2.KER_polarxz.figure.Position              = [200 200 900 900];
d2.KER_polarxz.axes(1).Title.String         = 'KE vs PXZ';
d2.KER_polarxz.axes.Fontsize                = 40;
% d2.KER_polarxyz.axes(1).YLim            = [ -1 1];
% d2.KER_polarxyz.axes(1).XLim            = [72 130];
%d2.KER_polarxz.cond                         = exp_md.cond.eRiXY;
d2.KER_polarxz.axes.colormap                = 'jet';
d2.KER_polarxz.axes.FontSize                 = 18;
d2.KER_polarxz.axes.TitleFontSizeMultiplier  = 1.5;

d2.KER_polaryz                              = metadata.create.plot.signal_2_plot({signals.e_KER_sum, signals.e_PolAngleYZ });
d2.KER_polaryz.figure.Position              = [200 200 900 900];
d2.KER_polaryz.axes(1).Title.String         = 'KE vs PYZ';
d2.KER_polaryz.axes.Fontsize                = 40;
% d2.KER_polarxyz.axes(1).YLim            = [ -1 1];
% d2.KER_polarxyz.axes(1).XLim            = [72 130];
%d2.KER_polaryz.cond                         = exp_md.cond.eRiXY;
d2.KER_polaryz.axes.colormap                = 'jet';
d2.KER_polaryz.axes.FontSize                 = 18;
d2.KER_polaryz.axes.TitleFontSizeMultiplier  = 1.5;

d2.KERoverAngle                              = metadata.create.plot.signal_2_plot({signals.KERoverAngleUp});
d2.KERoverAngle.figure.Position              = [200 200 900 900];
d2.KERoverAngle.axes(1).Title.String         = 'KE vs angle';
d2.KERoverAngle.axes.Fontsize                = 40;
% d2.KER_polarxyz.axes(1).YLim            = [ -1 1];
% d2.KER_polarxyz.axes(1).XLim            = [72 130];
d2.KERoverAngle.cond                         = exp_md.cond.eRiXY;
d2.KERoverAngle.axes.colormap                = 'jet';
d2.KERoverAngle.axes.FontSize                 = 18;
d2.KERoverAngle.axes.TitleFontSizeMultiplier  = 1.5;
%% 

exp_md.plot.det1 = d1;
exp_md.plot.det2 = d2;
end