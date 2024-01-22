function [exp_md] = plot(exp_md)
% This convenience funciton lists the default plotting metadata, and can be
% read by other experiment-specific metadata files.

% Specify which plot to show:
% d1.ifdo.BR_Ci						= true;
% d1.ifdo.TOF							= true;
% d1.ifdo.m2q							= true;
% d1.ifdo.TOF_X						= true;
% d1.ifdo.TOF_Px                      = true;
% d1.ifdo.XY						= true;
% d1.ifdo.theta_R					= true;
% d1.ifdo.theta					= true;
% d1.ifdo.TOF_hit1_hit2				= true;
% d1.ifdo.m2q_hit1_hit2				= true;
% d1.ifdo.m2q_hit2_hit3				= true;
% d1.ifdo.dp						= true;
% d1.ifdo.KERhit						= true;
% d1.ifdo.ker_hit1_hit2					= true;
% d1.ifdo.dp_xR						= true;
% d1.ifdo.dp_normphi					= true;
% d1.ifdo.dp_norm						= true;
% d1.ifdo.dp_norm_squared				= true;
% d1.ifdo.dp_sum_norm				= true;
% d1.ifdo.dp_sum_norm_squared		= true;
% d1.ifdo.angle_p_corr_C2			= true;
% d1.ifdo.angle_p_corr_C3			= true;
% d1.ifdo.angle_p_corr_C2_KER_sum	= true;
% d1.ifdo.angle_p_corr_C2_dp_sum_norm = true;
% d1.ifdo.angle_p_corr_C2_p_ratio = true;

% d1.ifdo.KER_sum					= true;
% d1.ifdo.m2q_l_sum_KER_sum			= true;
% d1.ifdo.m2q_sum_CSD				= true;
 d1.ifdo.Dalitz_C2					= true;
% load the signal plotting metadata:
exp_md = smita.metadata.defaults.exp.Laksman_TOF.plot_signals(exp_md);
signals = exp_md.plot.signal;

%% %%%%%%%%%%%%%%%%%%%%%%% PLOTTYPE DEFAULTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d1.BR_Ci						= metadata.create.plot.signal_2_plot({signals.m2q_l}); %signals.m2q signals.mult
d1.BR_Ci.GraphObj.Type			= 'bar';
% d1.BR_Ci.hist.Integrated_value		= 100;
% d1.BR_Ci.cond			=exp_md.cond.def.X; %exp_md.cond;  %def.C;exp_md.cond.def.X_X; %

d1.TOF							= metadata.create.plot.signal_2_plot({signals.TOF});
d1.TOF.hist.Integrated_value	= 1;
d1.TOF.GraphObj.ax_nr			= 1;
% Axes properties:
d1.TOF.axes(1).YTick			= linspace(0, 1, 1e1);
d1.TOF.axes(1).YLim				= [0 1];
d1.TOF.axes						= macro.plot.add_axes(d1.TOF.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q', 'X');
% d1.TOF.cond			=exp_md.cond.def.X;

d1.TOF_hit1_hit2				= metadata.create.plot.signal_2_plot({signals.TOF, signals.TOF});
d1.TOF_hit1_hit2.hist.hitselect = [1, 2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
d1.TOF_hit1_hit2.hist.binsize	= 2*d1.TOF_hit1_hit2.hist.binsize;
% d1.TOF_hit1_hit2.hist.saturation_limits = [0 0.25e-2]; % relative intensities. Everything above or below these limits will be set equal to the limit value.
d1.TOF_hit1_hit2.axes.axis		= 'equal';
d1.TOF_hit1_hit2.axes			= macro.plot.add_axes(d1.TOF_hit1_hit2.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q');
% d1.TOF_hit1_hit2.cond			=exp_md.cond.def.X_X; %CO2;

d1.m2q							= metadata.create.plot.signal_2_plot({signals.m2q});
d1.m2q.hist.Integrated_value	= 100;
d1.m2q.GraphObj.ax_nr			= 1;
% Axes properties:
d1.m2q.axes(1).YTick			= linspace(0, 1, 101);
d1.m2q.axes(1).YLim				= [0 0.1];
d1.m2q.axes						= macro.plot.add_axes(d1.m2q.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q', 'X');
d1.m2q.cond                     = exp_md.cond.def.H.dpY;%dp_sum; %X_X;

d1.m2q_hit1_hit2				= metadata.create.plot.signal_2_plot({signals.m2q, signals.m2q});
d1.m2q_hit1_hit2.hist.hitselect = [1, 2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
d1.m2q_hit1_hit2.hist.saturation_limits = [0 1e-3]; % [0 5e-4] relative intensities. Everything above or below these limits will be set equal to the limit value.
% d1.m2q_hit1_hit2.hist.saturation_limits = [0 7e-1]; % [0 5e-4] relative intensities. Everything above or below these limits will be set equal to the limit value.
d1.m2q_hit1_hit2.axes.axis		= 'equal';
d1.m2q_hit1_hit2.GraphObj.Type = 'imagesc';
d1.m2q_hit1_hit2.GraphObj.SizeData = 150;
d1.m2q_hit1_hit2.GraphObj.Marker = 'o';
% d1.m2q_hit1_hit2.GraphObj.MarkerEdgeColor = 'r';
d1.m2q_hit1_hit2.figure.Position = [1200 1000 600 350];
% d1.m2q_hit1_hit2.cond			=exp_md.cond.def.X_X; %exp_md.cond.def.O_C.dp_sum;  %exp_md.cond.def.dp_norm;  %exp_md.cond.def.C; 

d1.m2q_hit2_hit3				= metadata.create.plot.signal_2_plot({signals.m2q, signals.m2q});
d1.m2q_hit2_hit3.hist.hitselect = [2, 3]; %hitselect can be used to select only the first, second, etc hit of a hit variable.d1.m2q_hit2_hit3.axes.Title.String = 'PEPIPICO Mass spectrum';
d1.m2q_hit2_hit3.axes.axis		= 'equal';
d1.m2q_hit2_hit3.hist.binsize = [17 17];
d1.m2q_hit2_hit3.GraphObj.Type = 'scatter';
d1.m2q_hit2_hit3.GraphObj.SizeData = 150;
d1.m2q_hit2_hit3.GraphObj.Marker = 'o';
d1.m2q_hit2_hit3.GraphObj.MarkerEdgeColor = 'r';

d1.TOF_X						= metadata.create.plot.signal_2_plot({signals.TOF, signals.X});
d1.TOF_X.figure.Position		= plot.fig.Position('SE');
d1.TOF_X.axes					= macro.plot.add_axes(d1.TOF_X.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q','X');
d1.TOF_X.hist.saturation_limits = [0 0.1];
d1.TOF_X.cond                   = exp_md.cond.def.X_X;

d1.TOF_Px						= metadata.create.plot.signal_2_plot({signals.TOF, signals.dp_x});
d1.TOF_Px.figure.Position		= plot.fig.Position('SE');
d1.TOF_Px.axes					= macro.plot.add_axes(d1.TOF_Px.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q','X');
d1.TOF_Px.hist.saturation_limits = [0 0.001];

d1.XY							= metadata.create.plot.signal_2_plot({signals.X, signals.Y});
d1.XY.figure.Position			= plot.fig.Position('full');
d1.XY.axes.axis					= 'equal';
d1.XY.cond						= exp_md.cond.def.X_X; %exp_md.cond.CO2; %

d1.theta							= metadata.create.plot.signal_2_plot({signals.Theta});
% d1.theta.cond						= exp_md.cond.def.C; %exp_md.cond.CO2;

d1.theta_R						= metadata.create.plot.signal_2_plot({signals.Theta, signals.R});
d1.theta_R.figure.Position		= plot.fig.Position('SE');
d1.theta_R.axes.YLim			= [20 45];
d1.theta_R.cond					= exp_md.cond.def.X_X; %exp_md.cond.H;

d1.m2q							= metadata.create.plot.signal_2_plot({signals.m2q});

d1.dp							= metadata.create.plot.signal_2_plot(signals.dp);
d1.dp.cond						= exp_md.cond.def.X_X;%CO2;%def.O2_CO2x;%O_CO;
d1.dp.figure.Position		= plot.fig.Position('Full');

d1.KERhit							= metadata.create.plot.signal_2_plot(signals.KER_hit);
d1.KERhit.hist.Integrated_value	= 1;
d1.KERhit.cond						= exp_md.cond.def.X_X;%def.O2_CO2x;%O_CO;

d1.ker_hit1_hit2				= metadata.create.plot.signal_2_plot({signals.dp_sum_norm, signals.KER_sum}); %signals.KER_sum
% d1.ker_hit1_hit2.hist.hitselect = [1,2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
% d1.ker_hit1_hit2.hist.saturation_limits = [0 5e-1]; % [0 5e-4] relative intensities. Everything above or below these limits will be set equal to the limit value.
% d1.ker_hit1_hit2.hist.saturation_limits = [0 7e-1]; % [0 5e-4] relative intensities. Everything above or below these limits will be set equal to the limit value.
% d1.ker_hit1_hit2.axes.axis		= 'equal';
d1.ker_hit1_hit2.GraphObj.Type = 'imagesc';
d1.ker_hit1_hit2.GraphObj.SizeData = 150;
d1.ker_hit1_hit2.GraphObj.Marker = 'o';
% d1.ker__hit1_hit2.GraphObj.MarkerEdgeColor = 'r';
d1.ker_hit1_hit2.figure.Position = [1200 1000 600 350];
d1.ker_hit1_hit2.cond			=exp_md.cond.def.X_X; %exp_md.cond.def.O_C.dp_sum;  %exp_md.cond.def.dp_norm;  %exp_md.cond.def.C; 

d1.dp_xR						= metadata.create.plot.signal_2_plot({signals.dp_R, signals.dp_z});
d1.dp_xR.axes.axis				= 'equal';
d1.dp_xR.axes.colormap		= plot.custom_RGB_colormap('w', 'b');
%d1.dp_xR.cond					= exp_md.cond.H;
d1.dp_xR.figure.Position		= [1500 1000 440 460];
% d1.dp_xR.axes.Position		= [0.2 0.2 0.3 0.6];
% d1.dp_xR.axes.YTickLabel		= [];
% d1.dp_xR.axes.YLabel.String		= [];
d1.dp_xR.axes.XDir = 'reverse';

d1.dp_norm						= metadata.create.plot.signal_2_plot(signals.dp_norm);
d1.dp_norm.cond					= exp_md.cond.def.X_X  ;%exp_md.cond.def.O2_CO2x;%exp_md.cond.CO2;
d1.dp_norm.hist.Integrated_value	= 1;
d1.dp_norm.figure.Position		= [1500 1000 440 460];

d1.dp_norm_squared						= metadata.create.plot.signal_2_plot(signals.dp_norm_squared);
d1.dp_norm_squared.cond					= exp_md.cond.def.X_X; %exp_md.cond.CO2;%exp_md.cond.def.C;%exp_md.cond.def.O2_CO2x;%exp_md.cond.CO2;
d1.dp_norm_squared.figure.Position		= [1500 1000 440 460];

d1.dp_normphi					= metadata.create.plot.signal_2_plot({signals.dp_phi signals.dp_norm});
% d1.dp_normphi.cond				= exp_md.cond.H;
d1.dp_normphi.figure.Position	= [1230  410 500 460];
d1.dp_normphi.axes.colormap		= plot.custom_RGB_colormap('w', 'r');
d1.dp_normphi.axes.Position		= [0.2 0.2 0.6 0.6];

%(event):
d1.dp_sum_norm					= metadata.create.plot.signal_2_plot(signals.dp_sum_norm);
d1.dp_sum_norm.cond				= exp_md.cond.def.X_X; %exp_md.cond.CO2; % exp_md.cond.def.O2_CO2x;  %macro.filter.write_coincidence_condition(2, 'det1');%

d1.dp_sum_norm_squared					= metadata.create.plot.signal_2_plot(signals.dp_sum_norm_squared);
d1.dp_sum_norm_squared.cond				= exp_md.cond.def.X_X; 

d1.angle_p_corr_C2.axes.Type	= 'polaraxes';
d1.angle_p_corr_C2				= metadata.create.plot.signal_2_plot(signals.angle_p_corr_C2, d1.angle_p_corr_C2);
% d1.angle_p_corr_C2.hist.Maximum_value = 1;
d1.angle_p_corr_C2.cond			=  exp_md.cond.def.X_X; %exp_md.cond.def.O_C;exp_md.cond.CO2;%
% d1.angle_p_corr_C2.cond			= exp_md.cond.angle_p_corr_C2;
% d1.angle_p_corr_C2.cond			= exp_md.cond.incompl;
% d1.angle_p_corr_C2.cond			= exp_md.cond.NH2_H;

d1.angle_p_corr_C3.axes.Type	= 'polaraxes';
d1.angle_p_corr_C3				= metadata.create.plot.signal_2_plot(signals.angle_p_corr_C2, d1.angle_p_corr_C2);
d1.angle_p_corr_C3.hist.Maximum_value = 1;
d1.angle_p_corr_C3.cond			= exp_md.cond.def.X_X; %exp_md.cond.def.O_C; %exp_md.cond.CO2;
%


d1.KER_sum							= metadata.create.plot.signal_2_plot({signals.KER_sum});
d1.KER_sum.hist.Integrated_value	= 1;
d1.KER_sum.cond						= exp_md.cond.def.X_X; % exp_md.cond.def.CO2_C; %exp_md.cond.def.O_C; %exp_md.calib.det1.momentum.cond;
% d1.KER_sum.axes.YTick				= [];

d1.angle_p_corr_C2_KER_sum.axes.Type	= 'polaraxes';
d1.angle_p_corr_C2_KER_sum				= metadata.create.plot.signal_2_plot({signals.angle_p_corr_C2, signals.KER_sum}, d1.angle_p_corr_C2_KER_sum);
d1.angle_p_corr_C2_KER_sum.cond             = exp_md.cond.def.X_X;


d1.angle_p_corr_C2_dp_sum_norm.axes.Type	= 'polaraxes';
d1.angle_p_corr_C2_dp_sum_norm				= metadata.create.plot.signal_2_plot({signals.angle_p_corr_C2, signals.dp_sum_norm}, d1.angle_p_corr_C2_dp_sum_norm);
d1.angle_p_corr_C2_dp_sum_norm.cond         = exp_md.cond.def.X_X;
% d1.angle_p_corr_C2_dp_sum_norm.hist.saturation_limits = [0 5e-3]; %
% d1.angle_p_corr_C2_dp_sum_norm.axes.colormap         = plot.myjet;

d1.angle_p_corr_C2_p_ratio.axes.Type	= 'polaraxes';
d1.angle_p_corr_C2_p_ratio				= metadata.create.plot.signal_2_plot({signals.angle_p_corr_C2, signals.p_ratio}, d1.angle_p_corr_C2_p_ratio);
d1.angle_p_corr_C2_p_ratio.cond         = exp_md.cond.def.X_X;
% d1.angle_p_corr_C2_p_ratio.hist.saturation_limits = [0 5e-3]; %
% d1.angle_p_corr_C2_p_ratio.axes.colormap         = plot.myjet;


d1.m2q_l_sum_KER_sum				= metadata.create.plot.signal_2_plot({signals.m2q_l_sum, signals.KER_sum});
d1.m2q_l_sum_KER_sum.GraphObj.Type	= 'Y_mean';
d1.m2q_l_sum_KER_sum.hist.binsize(1) = 1;
% Axes properties:
d1.m2q_l_sum_KER_sum.axes.XTick	= 2*exp_md.sample.fragment.masses; % [Da] Tick of the axis that shows the m2q variable. 
d1.m2q_l_sum_KER_sum.axes.Position			= [0.2 0.25 0.6 0.55];
d1.m2q_l_sum_KER_sum.figure.Position		= [1390         569         531         405];
d1.m2q_l_sum_KER_sum.axes.XTickLabel = d1.m2q_l_sum_KER_sum.axes.XTick; % [Da] Tick of the axis that shows the m2q variable. 
d1.m2q_l_sum_KER_sum.axes(2)		= general.struct.catstruct(d1.m2q_l_sum_KER_sum.axes(1), signals.add_cluster_size.axes);
conv.eps_m = 1; conv.mult = 2; conv.charge = 1;
d1.m2q_l_sum_KER_sum.axes = macro.plot.add_axes(d1.m2q_l_sum_KER_sum.axes(1), signals.add_CSD.axes, conv, 'CSD', 'Y');
d1.m2q_l_sum_KER_sum.axes(2).XTickLabel = 2:2:22;
% d1.m2q_l_sum_KER_sum.cond			= exp_md.cond.angle_p_corr_C3;
d1.m2q_l_sum_KER_sum.cond.label		= exp_md.cond.def.label;
% d1.m2q_l_sum_KER_sum.cond		= exp_md.cond.incompl;

% If a new signal needs to be converted to a signal metadata, this can be automized: 
% d1.XY					= metadata.create.plot.data_pointer_2_md(p_d.(exp_names{1}), {'h.det1.X', 'h.det1.Y'});
d1.Dalitz_C2.Type				= 'ternary';
% d1.Dalitz_C2					= metadata.create.plot.signal_2_plot({signals.dp_norm, signals.dp_norm, signals.dp_sum_norm}, d1.Dalitz_C2);
d1.Dalitz_C2					= metadata.create.plot.signal_2_plot({signals.dp_norm_squared, signals.dp_norm_squared, signals.dp_sum_norm_squared}, d1.Dalitz_C2);
% d1.Dalitz_C2					= metadata.create.plot.signal_2_plot({signals.dp_norm_squared, signals.dp_norm_squared, signals.dp_norm_squared}, d1.Dalitz_C2);
d1.Dalitz_C2.hist.hitselect		= [1, 2, NaN]; %[1, 2, NaN]hitselect can be used to select only the first, second, etc hit of a hit variable.
d1.Dalitz_C2.hist.Maximum_value = 1;%
% d1.Dalitz_C2.hist.saturation_limits = [0 1.5]; % [0 4e-1] relative intensities. Everything above or below these limits will be set equal to the limit value.
d1.Dalitz_C2.figure.Position	= [1200 300 600 600];
d1.Dalitz_C2.figure.Name		= 'O2_C';
d1.Dalitz_C2.axes.XLabel.String		= '|p_1|^2 O_2^+ [a.u.]';
% d1.Dalitz_C2.axes.XLabel.String		= '|p_1|^2 (O_2^+) [a.u.]';
% d1.Dalitz_C2.axes.XLabel.String		= '|p_1|^2 (O^+) [a.u.]';
d1.Dalitz_C2.axes.YLabel.String		= '|p_2|^2 CO_2^+ [a.u.] ';
% d1.Dalitz_C2.axes.YLabel.String		= '|p_2|^2 ((CO_2)_n^+) [a.u.] ';
% d1.Dalitz_C2.axes.YLabel.String		= '|p_2|^2 (CO^+) [a.u.] ';
d1.Dalitz_C2.axes.ZLabel.String		= '|p_{res}|^2 [a.u.]';

d1.Dalitz_C2.axes.colormap			= plot.myjet;%plot.custom_RGB_colormap('w', 'r'); %

d1.Dalitz_C2.axes.axis		= 'equal';
% d1.Dalitz_C2.cond			= exp_md.cond.def.O2_CO2x;
% d1.Dalitz_C2.cond			= exp_md.cond.CO2;
d1.Dalitz_C2.cond			= exp_md.cond.def.X_X; %exp_md.cond.def.O_C;

% Save to exp_md:
exp_md.plot.det1 = d1;

end
