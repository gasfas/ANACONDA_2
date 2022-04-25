function [exp_md] = plot(exp_md)
% This convenience funciton lists the default plotting metadata, and can be
% read by other experiment-specific metadata files.

% Specify which plot to show:
d1.ifdo.BR_Ci						= true;
% d1.ifdo.TOF							= true;
% d1.ifdo.m2q							= true;
% d1.ifdo.TOF_X						= true;
% d1.ifdo.TOF_Px                      = true;
% d1.ifdo.XY						= true;
% d1.ifdo.theta_R					= true;
% d1.ifdo.TOF_hit1_hit2				= true;
% d1.ifdo.m2q_hit1_hit2				= true;
% d1.ifdo.m2q_hit2_hit3				= true;
% d1.ifdo.dp						= true;
% d1.ifdo.dp_xR						= true;
% d1.ifdo.dp_normphi					= true;
% d1.ifdo.dp_norm						= true;
% d1.ifdo.dp_sum_norm				= true;
% d1.ifdo.angle_p_corr_C2			= true;
% d1.ifdo.angle_p_corr_C2_KER_sum	= true;
% d1.ifdo.angle_p_corr_C2_dp_sum_norm = true;
% d1.ifdo.KER_sum					= true;
% d1.ifdo.m2q_l_sum_KER_sum			= true;
% d1.ifdo.m2q_sum_CSD				= true;

% load the signal plotting metadata:
exp_md = metadata.defaults.exp.Laksman_TOF.plot_signals(exp_md);
signals = exp_md.plot.signal;

%% %%%%%%%%%%%%%%%%%%%%%%% PLOTTYPE DEFAULTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d1.BR_Ci						= metadata.create.plot.signal_2_plot({signals.mult});
d1.BR_Ci.GraphObj.Type			= 'bar';
d1.BR_Ci.hist.Integrated_value		= 1;

d1.TOF							= metadata.create.plot.signal_2_plot({signals.TOF});
% d1.TOF.hist.Integrated_value	= 1;
d1.TOF.GraphObj.ax_nr			= 1;
% Axes properties:
d1.TOF.axes(1).YTick			= linspace(0, 1000, 1e1);
d1.TOF.axes(1).YLim				= [0 2e3];
d1.TOF.axes						= macro.plot.add_axes(d1.TOF.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q', 'X');
% d1.TOF.cond			=exp_md.cond.CO2;

d1.TOF_hit1_hit2				= metadata.create.plot.signal_2_plot({signals.TOF, signals.TOF});
d1.TOF_hit1_hit2.hist.hitselect = [1, 2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
d1.TOF_hit1_hit2.hist.binsize	= 2*d1.TOF_hit1_hit2.hist.binsize;
% d1.TOF_hit1_hit2.hist.saturation_limits = [0 5e-4]; % relative intensities. Everything above or below these limits will be set equal to the limit value.
d1.TOF_hit1_hit2.axes.axis		= 'equal';
d1.TOF_hit1_hit2.axes			= macro.plot.add_axes(d1.TOF_hit1_hit2.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q');
%d1.TOF_hit1_hit2.cond			=exp_md.cond.CO2;

d1.m2q							= metadata.create.plot.signal_2_plot({signals.m2q});
d1.m2q.hist.Integrated_value	= 1;
d1.m2q.GraphObj.ax_nr			= 1;
% Axes properties:
d1.m2q.axes(1).YTick			= linspace(0, 1, 101);
d1.m2q.axes(1).YLim				= [0 0.1];
d1.m2q.axes						= macro.plot.add_axes(d1.m2q.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q', 'X');

d1.m2q_hit1_hit2				= metadata.create.plot.signal_2_plot({signals.m2q, signals.m2q});
d1.m2q_hit1_hit2.hist.hitselect = [1, 2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
% d1.m2q_hit1_hit2.hist.saturation_limits = [0 5e-4]; % relative intensities. Everything above or below these limits will be set equal to the limit value.
d1.m2q_hit1_hit2.axes.axis		= 'equal';
d1.m2q_hit1_hit2.GraphObj.Type = 'imagesc';
d1.m2q_hit1_hit2.GraphObj.SizeData = 150;
d1.m2q_hit1_hit2.GraphObj.Marker = 'o';
d1.m2q_hit1_hit2.GraphObj.MarkerEdgeColor = 'r';
d1.m2q_hit1_hit2.figure.Position = [1200 1000 600 350];
%d1.m2q_hit1_hit2.cond			=exp_md.cond.CO2;

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

d1.TOF_Px						= metadata.create.plot.signal_2_plot({signals.TOF, signals.dp_x});
d1.TOF_Px.figure.Position		= plot.fig.Position('SE');
d1.TOF_Px.axes					= macro.plot.add_axes(d1.TOF_Px.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q','X');
d1.TOF_Px.hist.saturation_limits = [0 0.001];

d1.XY							= metadata.create.plot.signal_2_plot({signals.X, signals.Y});
d1.XY.figure.Position			= plot.fig.Position('full');
d1.XY.axes.axis					= 'equal';
%d1.XY.cond						= exp_md.cond.H;

d1.theta_R						= metadata.create.plot.signal_2_plot({signals.Theta, signals.R});
d1.theta_R.figure.Position		= plot.fig.Position('SE');
d1.theta_R.axes.YLim			= [20 45];
% d1.theta_R.cond					= exp_md.cond.H;

d1.m2q							= metadata.create.plot.signal_2_plot({signals.m2q});

d1.dp							= metadata.create.plot.signal_2_plot(signals.dp);
%d1.dp.cond						= exp_md.cond.H;

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
% d1.dp_norm.cond					= exp_md.cond.H;
d1.dp_norm.figure.Position		= [1500 1000 440 460];

d1.dp_normphi					= metadata.create.plot.signal_2_plot({signals.dp_phi signals.dp_norm});
% d1.dp_normphi.cond				= exp_md.cond.H;
d1.dp_normphi.figure.Position	= [1230  410 500 460];
d1.dp_normphi.axes.colormap		= plot.custom_RGB_colormap('w', 'r');
d1.dp_normphi.axes.Position		= [0.2 0.2 0.6 0.6];

d1.dp_sum_norm					= metadata.create.plot.signal_2_plot(signals.dp_sum_norm);
% d1.dp_sum_norm.cond				= exp_md.cond.NH_H;

d1.angle_p_corr_C2.axes.Type	= 'polaraxes';
d1.angle_p_corr_C2				= metadata.create.plot.signal_2_plot(signals.angle_p_corr_C2, d1.angle_p_corr_C2);
d1.angle_p_corr_C2.hist.Maximum_value = 1;
%d1.angle_p_corr_C2.cond			= exp_md.cond.CO2;
% d1.angle_p_corr_C2.cond			= exp_md.cond.angle_p_corr_C2;
% d1.angle_p_corr_C2.cond			= exp_md.cond.incompl;
% d1.angle_p_corr_C2.cond			= exp_md.cond.NH2_H;

d1.KER_sum							= metadata.create.plot.signal_2_plot({signals.KER_sum});
d1.KER_sum.hist.Integrated_value	= 1;
% d1.KER_sum.cond						= exp_md.calib.det1.momentum.cond;
d1.KER_sum.axes.YTick				= [];

d1.angle_p_corr_C2_KER_sum.axes.Type	= 'polaraxes';
d1.angle_p_corr_C2_KER_sum				= metadata.create.plot.signal_2_plot({signals.angle_p_corr_C2, signals.KER_sum}, d1.angle_p_corr_C2_KER_sum);

d1.angle_p_corr_C2_dp_sum_norm.axes.Type	= 'polaraxes';
d1.angle_p_corr_C2_dp_sum_norm				= metadata.create.plot.signal_2_plot({signals.angle_p_corr_C2, signals.dp_sum_norm}, d1.angle_p_corr_C2_dp_sum_norm);

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
% d1.m2q_l_sum_KER_sum.cond.label		= exp_md.cond.def.label;
% d1.m2q_l_sum_KER_sum.cond		= exp_md.cond.incompl;

% If a new signal needs to be converted to a signal metadata, this can be automized: 
% d1.XY					= metadata.create.plot.data_pointer_2_md(p_d.(exp_names{1}), {'h.det1.X', 'h.det1.Y'});

% Save to exp_md:
exp_md.plot.det1 = d1;

end
% 
% function [exp_md] = plot(exp_md)
% % This convenience funciton lists the default plotting metadata, and can be
% % read by other experiment-specific metadata files.
% 
% % Specify which plot to show:
% % d1.ifdo.BR_Ci						= true;
% % d1.ifdo.TOF							= true;
% % d1.ifdo.m2q							= true;
% % d1.ifdo.TOF_X						= true;
% % d1.ifdo.TOF_Px                      = true;
% % d1.ifdo.XY						= true;
% % d1.ifdo.theta_R					= true;
% % d1.ifdo.TOF_hit1_hit2				= true;
% % d1.ifdo.TOF_hit1_hit3				= true;
% % % d1.ifdo.TOF_hit1_hit2_hit3				= true;
% % d1.ifdo.m2q_hit1_hit2				= true;
% % d1.ifdo.m2q_hit2_hit3				= true;
% % d1.ifdo.dp						= true;
% % d1.ifdo.dp_xR						= true;
% % d1.ifdo.dp_normphi					= true;
% % d1.ifdo.dp_norm						= true;
% % d1.ifdo.dp_sum_norm				= true;
% % d1.ifdo.dp_sum			= true;
% d1.ifdo.angle_p_corr_C2			= true;
% % d1.ifdo.angle_p_corr_C3			= true;
% % d1.ifdo.angle_p_corr_C2_KER_sum	= true;
% % d1.ifdo.angle_p_corr_C2_dp_sum_norm = true;
% % d1.ifdo.KER_sum					= true;
% % d1.ifdo.m2q_l_sum_KER_sum			= true;
% % d1.ifdo.m2q_sum_CSD				= true;
% % d1.ifdo.kercluster_size                =true;
% % d1.ifdo.csdcluster_size                =true;
% % d1.ifdo.p_3d                =true;
% 
% % load the signal plotting metadata:
% exp_md = metadata.defaults.exp.Laksman_TOF.plot_signals(exp_md);%open this if you want to edit the plot mdata
% signals = exp_md.plot.signal;
% 
% %% %%%%%%%%%%%%%%%%%%%%%%% PLOTTYPE DEFAULTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% d1.BR_Ci						= metadata.create.plot.signal_2_plot({signals.mult});
% d1.BR_Ci.GraphObj.Type			= 'bar';
% d1.BR_Ci.hist.Integrated_value		= 1;
% d1.BR_Ci.cond.label                   = exp_md.cond.def.label;
% d1.BR_Ci.cond.label.value             = 28;
% d1.BR_Ci.cond.label.type              = 'discrete';
% d1.BR_Ci.cond.mult                      = macro.filter.write_coincidence_condition(1, 'det1');
% d1.BR_Ci.cond.mult.invert_filter        = true;
% 
% d1.TOF							= metadata.create.plot.signal_2_plot({signals.TOF});
% % d1.TOF.hist.Integrated_value	= 1;
% d1.TOF.GraphObj.ax_nr			= 1;
% % Axes properties:
% d1.TOF.axes(1).YTick			= linspace(0, 1000, 1e1); 
% % d1.TOF.axes(1).YTick			= linspace(0, 100, 1e1);
% % d1.TOF.axes(1).YLim				= [0 2e3];
% d1.TOF.axes(1).YLim				= [0 10000]; %y axis scale
% d1.TOF.axes						= macro.plot.add_axes(d1.TOF.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q', 'X');
% % d1.TOF.cond			=exp_md.cond.CO2;
% 
% d1.TOF_hit1_hit2				= metadata.create.plot.signal_2_plot({signals.TOF, signals.TOF});
% d1.TOF_hit1_hit2.hist.hitselect = [1, 2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
% d1.TOF_hit1_hit2.hist.binsize	= 2*d1.TOF_hit1_hit2.hist.binsize;
% d1.TOF_hit1_hit2.hist.saturation_limits = [0 5e-4]; % relative intensities. Everything above or below these limits will be set equal to the limit value.
% d1.TOF_hit1_hit2.axes.axis		= 'equal';
% d1.TOF_hit1_hit2.axes			= macro.plot.add_axes(d1.TOF_hit1_hit2.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q');
% % d1.TOF_hit1_hit2.cond			=exp_md.cond.CO2;
% 
% d1.TOF_hit1_hit3				= metadata.create.plot.signal_2_plot({signals.TOF, signals.TOF});
% d1.TOF_hit1_hit3.hist.hitselect = [1, 3]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
% d1.TOF_hit1_hit3.hist.binsize	= 2*d1.TOF_hit1_hit3.hist.binsize;
% % d1.TOF_hit1_hit2.hist.saturation_limits = [0 5e-4]; % relative intensities. Everything above or below these limits will be set equal to the limit value.
% d1.TOF_hit1_hit3.axes.axis		= 'equal';
% d1.TOF_hit1_hit3.axes			= macro.plot.add_axes(d1.TOF_hit1_hit3.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q');
% % d1.TOF_hit1_hit3.cond			=exp_md.cond.CO2;
% 
% d1.TOF_hit1_hit2_hit3				= metadata.create.plot.signal_2_plot({signals.TOF, signals.TOF});
% d1.TOF_hit1_hit2_hit3.hist.hitselect = [1, 2, 3]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
% d1.TOF_hit1_hit2_hit3.hist.binsize	= 2*d1.TOF_hit1_hit3.hist.binsize;
% % d1.TOF_hit1_hit2.hist.saturation_limits = [0 5e-1]; % relative intensities. Everything above or below these limits will be set equal to the limit value.
% d1.TOF_hit1_hit2_hit3.axes.axis		= 'equal';
% d1.TOF_hit1_hit2_hit3.axes			= macro.plot.add_axes(d1.TOF_hit1_hit2_hit3.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q');
% d1.TOF_hit1_hit2_hit3.GraphObj.Type = 'imagesc';
% d1.TOF_hit1_hit2_hit3.GraphObj.SizeData = 150;
% d1.TOF_hit1_hit2_hit3.GraphObj.Marker = 'o';
% d1.TOF_hit1_hit2_hit3.GraphObj.MarkerEdgeColor = 'r';
% d1.TOF_hit1_hit2_hit3.figure.Position = [1200 1000 600 350];
% % d1.TOF_hit1_hit2_hit3.cond			=exp_md.cond.CO2;
% 
% d1.m2q							= metadata.create.plot.signal_2_plot({signals.m2q});
% % d1.m2q.cond			=macro.filter.write_coincidence_condition(2, 'det1');
% % d1.m2q.GraphObj.ax_nr			= 1;
% % Axes properties:
% d1.m2q.axes(1).YTick			= linspace(0, 1, 101);
% d1.m2q.axes(1).YLim				= [0 0.1];
% d1.m2q.axes						= macro.plot.add_axes(d1.m2q.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q', 'X');
% 
% 
% d1.m2q_hit1_hit2				= metadata.create.plot.signal_2_plot({signals.m2q, signals.m2q});
% d1.m2q_hit1_hit2.hist.hitselect = [1, 2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
% % d1.m2q_hit1_hit2.hist.saturation_limits = [0 5e-5]; % relative intensities. Everything above or below these limits will be set equal to the limit value.
% % d1.m2q_hit1_hit2.hist.Integrated_value=1e5;
% % d1.m2q_hit1_hit2.hist.saturation_limits = [0 -1];
% d1.m2q_hit1_hit2.hist.Intensity_scaling = 'log';
% d1.m2q_hit1_hit2.axes.axis		= 'equal';
% d1.m2q_hit1_hit2.GraphObj.Type = 'imagesc';
% % d1.m2q_hit1_hit2.GraphObj.SizeData = 150;
% % d1.m2q_hit1_hit2.GraphObj.Marker = 'o';
% % d1.m2q_hit1_hit2.GraphObj.MarkerEdgeColor = 'k';
% % d1.m2q_hit1_hit2.axes.CLim=[0 1];
% d1.m2q_hit1_hit2.figure.Position = [1200 1000 600 350];
% % d1.m2q_hit1_hit2.axes			= macro.plot.add_axes(d1.m2q_hit1_hit2.axes(1), signals.add_cluster_size.axes, exp_md.conv.det1, 'm2q');
% % d1.m2q_hit1_hit2.cond			=macro.filter.write_coincidence_condition(2, 'det1');
% d1.m2q_hit1_hit2.cond			=exp_md.cond;%.dp_sum;
% 
% d1.m2q_hit2_hit3				= metadata.create.plot.signal_2_plot({signals.m2q, signals.m2q});
% d1.m2q_hit2_hit3.hist.hitselect = [2, 3]; %hitselect can be used to select only the first, second, etc hit of a hit variable.d1.m2q_hit2_hit3.axes.Title.String = 'PEPIPICO Mass spectrum';
% d1.m2q_hit2_hit3.axes.axis		= 'equal';
% d1.m2q_hit2_hit3.hist.binsize = [17 17];
% d1.m2q_hit2_hit3.GraphObj.Type = 'scatter';
% d1.m2q_hit2_hit3.GraphObj.SizeData = 150;
% d1.m2q_hit2_hit3.GraphObj.Marker = 'o';
% d1.m2q_hit2_hit3.GraphObj.MarkerEdgeColor = 'r';
% 
% d1.TOF_X						= metadata.create.plot.signal_2_plot({signals.TOF, signals.X});
% d1.TOF_X.figure.Position		= plot.fig.Position('SE');
% d1.TOF_X.axes					= macro.plot.add_axes(d1.TOF_X.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q','X');
% d1.TOF_X.hist.saturation_limits = [0 0.1];
% 
% d1.TOF_Px						= metadata.create.plot.signal_2_plot({signals.TOF, signals.dp_x});
% d1.TOF_Px.figure.Position		= plot.fig.Position('SE');
% d1.TOF_Px.axes					= macro.plot.add_axes(d1.TOF_Px.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q','X');
% d1.TOF_Px.hist.saturation_limits = [0 0.001];
% 
% d1.XY							= metadata.create.plot.signal_2_plot({signals.X, signals.Y});
% d1.XY.figure.Position			= plot.fig.Position('full');
% d1.XY.axes.axis					= 'equal';
% % d1.XY.cond						= exp_md.cond.H;
% 
% d1.theta_R						= metadata.create.plot.signal_2_plot({signals.Theta, signals.R});
% d1.theta_R.figure.Position		= plot.fig.Position('SE');
% d1.theta_R.axes.YLim			= [20 45];
% % d1.theta_R.cond					= exp_md.cond.H;
% 
% d1.m2q							= metadata.create.plot.signal_2_plot({signals.m2q});
% 
% d1.dp							= metadata.create.plot.signal_2_plot(signals.dp);
% % d1.dp.cond						= exp_md.cond.H;
% 
% d1.dp_xR						= metadata.create.plot.signal_2_plot({signals.dp_R, signals.dp_z});
% d1.dp_xR.axes.axis				= 'equal';
% d1.dp_xR.axes.colormap		= plot.custom_RGB_colormap('w', 'b');
% % d1.dp_xR.cond					= exp_md.cond.H;
% d1.dp_xR.figure.Position		= [1500 1000 440 460];
% % d1.dp_xR.axes.Position		= [0.2 0.2 0.3 0.6];
% % d1.dp_xR.axes.YTickLabel		= [];
% % d1.dp_xR.axes.YLabel.String		= [];
% d1.dp_xR.axes.XDir = 'reverse';
% 
% d1.dp_norm						= metadata.create.plot.signal_2_plot(signals.dp_norm); %hits
% % d1.dp_norm.cond					= exp_md.cond.CO2;
% d1.dp_norm.figure.Position		= [1500 1000 440 460];
% 
% d1.dp_normphi					= metadata.create.plot.signal_2_plot({signals.dp_phi signals.dp_norm});
% % d1.dp_normphi.cond				= exp_md.cond.H;
% d1.dp_normphi.figure.Position	= [1230  410 500 460];
% d1.dp_normphi.axes.colormap		= plot.custom_RGB_colormap('w', 'r');
% d1.dp_normphi.axes.Position		= [0.2 0.2 0.6 0.6];
% 
% d1.dp_sum_norm					= metadata.create.plot.signal_2_plot(signals.dp_sum_norm); %event
% % d1.dp_sum_norm.cond				= exp_md.cond; %macro.filter.write_coincidence_condition(2, 'det1'); %
% 
% % d1.dp_sum					= metadata.create.plot.signal_2_plot(signals.dp_sum);
% % d1.dp_sum.cond				= exp_md.cond;
% 
% d1.angle_p_corr_C2.axes.Type	= 'polaraxes';
% d1.angle_p_corr_C2				= metadata.create.plot.signal_2_plot(signals.angle_p_corr_C2, d1.angle_p_corr_C2);
% d1.angle_p_corr_C2.hist.Maximum_value = 1;
% % d1.angle_p_corr_C2.axes.colormap		= plot.custom_RGB_colormap('w', 'k');
% % d1.angle_p_corr_C2.cond			=macro.filter.write_coincidence_condition(2, 'det1');
% d1.angle_p_corr_C2.cond			= exp_md.cond;
% % d1.angle_p_corr_C2.cond			= exp_md.cond.angle_p_corr_C2;
% % d1.angle_p_corr_C2.cond			= exp_md.cond.incompl;
% % d1.angle_p_corr_C2.cond			= exp_md.cond.NH2_H;
% 
% %%%%
% d1.angle_p_corr_C3.axes.Type	= 'polaraxes';
% d1.angle_p_corr_C3				= metadata.create.plot.signal_2_plot(signals.angle_p_corr_C3, d1.angle_p_corr_C3);
% d1.angle_p_corr_C3.hist.Maximum_value = 1;
% % d1.angle_p_corr_C3.cond			=macro.filter.write_coincidence_condition(3, 'det1');
% % d1.angle_p_corr_C3.cond			= exp_md.cond;
% 
% d1.KER_sum							= metadata.create.plot.signal_2_plot({signals.KER_sum});
% d1.KER_sum.hist.Integrated_value	= 1;
% d1.KER_sum.cond						= exp_md.cond;%exp_md.calib.det1.momentum.cond;
% d1.KER_sum.axes.YTick				= [];
% 
% 
% d1.kercluster_size							= metadata.create.plot.signal_2_plot({signals.cluster_size_total,signals.KER_sum});
% d1.kercluster_size.GraphObj.Type	= 'Y_mean';
% d1.kercluster_size.GraphObj.show_FWHM='true';
% % d1.kercluster_size.GraphObj.medfilt_Y_radius=indexed;
% % d1.kercluster_size.Count=[1 0.3];
% % a=exp_md.cond.def.dp_sum;
% % b=macro.filter.write_coincidence_condition(2, 'det1');
% d1.kercluster_size.cond=exp_md.cond; 
% % d1.kercluster_size.cond					= exp_md.calib.det1.momentum.cond;
% % d1.kercluster_size.cond	=macro.filter.write_coincidence_condition(2, 'det1');
% % d1.kercluster_size.axes.YTick				= [];
% 
% d1.csdcluster_size							= metadata.create.plot.signal_2_plot({signals.cluster_size_total,signals.CSD});
% d1.csdcluster_size.GraphObj.Type	= 'Y_mean';
% d1.csdcluster_size.GraphObj.show_FWHM='true';
% % d1.kercluster_size.Count=[1 0.3];
% % a=exp_md.cond.def.dp_sum;
% % b=macro.filter.write_coincidence_condition(2, 'det1');
% d1.csdcluster_size.cond=exp_md.cond; 
% % d1.kercluster_size.cond					= exp_md.calib.det1.momentum.cond;
% % d1.kercluster_size.cond	=macro.filter.write_coincidence_condition(2, 'det1');
% % d1.kercluster_size.axes.YTick				= [];
% 
% d1.p_3d							= metadata.create.plot.signal_2_plot({signals.dp_x,signals.dp_y,signals.dp_z});
% d1.p_3d.GraphObj.Type	= 'patch';
% d1.p_3d.GraphObj.contourvalue=-.08;
% % d1.p_3d.cond=exp_md.cond; 
% 
% d1.angle_p_corr_C2_KER_sum.axes.Type	= 'polaraxes';
% d1.angle_p_corr_C2_KER_sum				= metadata.create.plot.signal_2_plot({signals.angle_p_corr_C2, signals.KER_sum}, d1.angle_p_corr_C2_KER_sum);
% 
% d1.angle_p_corr_C2_dp_sum_norm.axes.Type	= 'polaraxes';
% d1.angle_p_corr_C2_dp_sum_norm				= metadata.create.plot.signal_2_plot({signals.angle_p_corr_C2, signals.dp_sum_norm}, d1.angle_p_corr_C2_dp_sum_norm);
% d1.angle_p_corr_C2_dp_sum_norm.axes.RLim			= [0 150];
% d1.angle_p_corr_C2_dp_sum_norm.hist.Intensity_scaling = 'log';
% d1.angle_p_corr_C2_dp_sum_norm.hist.saturation_limits = [0 0.5e-0];%0.02
% d1.angle_p_corr_C2_dp_sum_norm.cond= exp_md.cond; %exp_md.plot.signal.dp_sum_norm.cond.co2;
% 
% d1.m2q_l_sum_KER_sum				= metadata.create.plot.signal_2_plot({signals.m2q_l_sum, signals.KER_sum});
% d1.m2q_l_sum_KER_sum.GraphObj.Type	= 'Y_mean';
% d1.m2q_l_sum_KER_sum.hist.binsize(1) = 1;
% % Axes properties:
% d1.m2q_l_sum_KER_sum.axes.XTick	= 2*exp_md.sample.fragment.masses; % [Da] Tick of the axis that shows the m2q variable. 
% % d1.m2q_l_sum_KER_sum.axes.XLim= [0 400]
% % d1.m2q_l_sum_KER_sum.axes.Position			= [0.2 0.25 0.6 0.55];
% % d1.m2q_l_sum_KER_sum.figure.Position		= [1390         569         531         405];
% % d1.m2q_l_sum_KER_sum.axes.XTickLabel = d1.m2q_l_sum_KER_sum.axes.XTick; % [Da] Tick of the axis that shows the m2q variable. 
% d1.m2q_l_sum_KER_sum.axes(2)		= general.struct.catstruct(d1.m2q_l_sum_KER_sum.axes(1), signals.add_cluster_size.axes);
% conv.eps_m = 1; conv.mult = 2; conv.charge = 1;
% d1.m2q_l_sum_KER_sum.axes = macro.plot.add_axes(d1.m2q_l_sum_KER_sum.axes(1), signals.add_CSD.axes, conv, 'CSD', 'Y');
% d1.m2q_l_sum_KER_sum.axes(2).XTickLabel = 2:2:22;
% % d1.m2q_l_sum_KER_sum.cond			= exp_md.cond.angle_p_corr_C3;
% % d1.m2q_l_sum_KER_sum.cond.label		= exp_md.cond.def.label;
% % d1.m2q_l_sum_KER_sum.cond		= exp_md.cond.incompl;
% 
% % If a new signal needs to be converted to a signal metadata, this can be automized: 
% % d1.XY					= metadata.create.plot.data_pointer_2_md(p_d.(exp_names{1}), {'h.det1.X', 'h.det1.Y'});
% 
% % Save to exp_md:
% exp_md.plot.det1 = d1;
% 
% end