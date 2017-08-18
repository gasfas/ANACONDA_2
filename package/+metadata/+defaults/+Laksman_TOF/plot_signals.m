function [exp_md] = plot_signals(exp_md)
% This metadata file describes the signal plotting preferences.
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SIGNALS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Each signal has its own configuration metadata:
%%%%%% mult: (multiplicity of the event)
s.mult.hist.pointer	= 'e.det1.mult';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.mult.hist.binsize	= 1;% [-] binsize of the variable. 
s.mult.hist.Range	= [0 4];% [-] range of the variable. 
% Axes metadata:
s.mult.axes.Lim		= [s.mult.hist.Range(1)-0.5 s.mult.hist.Range(2)+0.5];% [-] Lim of the axis that shows the variable. 
s.mult.axes.Tick		= s.mult.hist.Range(1):1:s.mult.hist.Range(2);
s.mult.axes.Label.String	= 'Number of hits'; %The label of the variable

%%%%%% TOF:
s.TOF.hist.pointer	= 'h.det1.TOF';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.TOF.hist.binsize	= 5;% [ns] binsize of the variable. 
s.TOF.hist.Range	= [3.74e3 8.2e3];% [ns] range of the variable. 
s.TOF.hist.binsize	= 0.5;% [ns] binsize of the variable. 
s.TOF.hist.Range	= [0 1.3e4];% [ns] range of the variable. 
s.TOF.hist.binsize	= 5;% [ns] binsize of the variable. 
% Axes metadata:
s.TOF.axes.Lim		= s.TOF.hist.Range;% [ns] Lim of the axis that shows the variable. 
s.TOF.axes.Tick	= round(unique(convert.m2q_2_TOF(exp_md.conv.det1.m2q_labels, ...
								exp_md.conv.det1.TOF_2_m2q.factor, ...
								exp_md.conv.det1.TOF_2_m2q.t0)));% [ns] Tick of the axis that shows the variable.
s.TOF.axes.Label.String	= 'TOF [ns]'; %The label of the variable

%%%%%% X:
s.X.hist.pointer		= 'h.det1.X';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.X.hist.binsize		= 1;% [mm] binsize of the variable. 
s.X.hist.Range			= [-40 40];% [mm] range of the variable. 
% Axes metadata:
s.X.axes.Lim			= [-40 40];% [ns] Lim of the axis that shows the variable. 
s.X.axes.Tick			=  linspace(-40, 40, 41);% [ns] Ticks shown 
s.X.axes.Label.String	= 'X [mm]'; %The label of the variable

%%%%%% Y:
s.Y						= s.X; % This has the same properties as X-coordinate.
s.Y.hist.pointer		= 'h.det1.Y';% Data pointer, where the signal can be found. 
s.Y.axes.Label.String	= 'Y [mm]'; %The label of the variable

%%%%%% Radius:
s.R.hist.pointer		= 'h.det1.R';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.R.hist.binsize		= 0.1;% [mm] binsize of the variable. 
s.R.hist.Range			= [0 40];% [mm] range of the variable. 
% Axes metadata:
s.R.axes.Lim			= [0 40];% [mm] Lim of the axis that shows the variable. 
s.R.axes.Tick			=  linspace(-40, 40, 41);% [mm] Ticks shown 
s.R.axes.Label.String	= 'R [mm]'; %The label of the variable

%%%%% Theta:
s.Theta.hist.pointer		= 'h.det1.theta';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.Theta.hist.binsize		= 0.1;% [rad] binsize of the variable. 
s.Theta.hist.Range		= [-pi pi];% [rad] range of the variable. 
% Axes metadata:
s.Theta.axes.Lim			= s.Theta.hist.Range;% [rad] Lim of the axis that shows the variable. 
s.Theta.axes.Tick			=  linspace(-3, 3, 7);% [rad] Ticks shown 
s.Theta.axes.Label.String	= 'Theta [rad]'; %The label of the variable

%%%%%% Mass-to-charge:
s.m2q.hist.pointer	= 'h.det1.m2q';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.m2q.hist.binsize	= 0.09;% [Da] binsize of the variable. 
s.m2q.hist.Range	= [17.5 171];% [Da] range of the variable. 
s.m2q.hist.Range	= [0 171];% [Da] range of the variable. 
% Axes metadata:
s.m2q.axes.Lim		= s.m2q.hist.Range;% [Da] Lim of the axis that shows the variable. 
s.m2q.axes.Tick	= exp_md.sample.fragment.masses; % [Da] Tick of the axis that shows the variable. 
s.m2q.axes.Label.String	= 'm/q [Da]'; %The label of the variable

%%%%%% Mass-to-charge sum:
s.m2q_l_sum.hist.pointer	= 'e.det1.m2q_l_sum';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.m2q_l_sum.hist.binsize	= 1;% [Da] binsize of the variable. 
s.m2q_l_sum.hist.Range	= [0 400];% [Da] range of the variable. 
% Axes metadata:
s.m2q_l_sum.axes.Lim		= [0 400];% [Da] Lim of the axis that shows the variable. 
s.m2q_l_sum.axes.Tick	= exp_md.sample.fragment.masses; % [Da] Tick of the axis that shows the variable. 
s.m2q_l_sum.axes.Label.String	= 'm/q [Da]'; %The label of the variable

%%%%%% Mass-to-charge background:
s.m2q_bgr			= s.m2q;
s.m2q_bgr.hist.pointer	= 'h.det1.m2q_bgr';% Data pointer, where the signal can be found. 

%%%%%% Momentum:
s.dp.hist.pointer	= 'h.det1.dp';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.dp.hist.binsize	= [1 1 1];% [a.u.] binsize of the variable. 
s.dp.hist.Range	= [-50 50; -50 50; -50 50];% [au] range of the variable. 
% Axes metadata:
s.dp.axes.Lim	= s.dp.hist.Range;% [au] Lim of the axis that shows the variable. 
s.dp.axes.Tick	= s.dp.hist.Range(1):10:s.dp.hist.Range(2);% [au] Ticks on the respective axes.
s.dp.axes.Label.String	= {'$p_x$ [a.u.]', '$p_y$ [a.u.]', '$p_z$ [a.u.]'}; %The label of the variable

%%%%%% Momentum x:
s.dp_x.hist.pointer	= 'h.det1.dp(:,1)';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.dp_x.hist.binsize	= [0.5];% [a.u.] binsize of the variable. 
s.dp_x.hist.Range	= [-50 50];% [au] range of the variable. 
% Axes metadata:
s.dp_x.axes.Lim	= s.dp_x.hist.Range;% [au] Lim of the axis that shows the variable. 
s.dp_x.axes.Tick	= s.dp_x.hist.Range(1):10:s.dp_x.hist.Range(2);% [au] Ticks on the respective axes.
s.dp_x.axes.Label.String	= {'$p_x$ [a.u.]'}; %The label of the variable

%%%%%% Momentum y:
s.dp_y				= s.dp_x;
s.dp_y.hist.pointer	= 'h.det1.dp(:,2)';% Data pointer, where the signal can be found. 
s.dp_y.axes.Label.String	= {'$p_y$ [a.u.]'}; %The label of the variable

%%%%%% Momentum z:
s.dp_z				= s.dp_x;
s.dp_z.hist.pointer	= 'h.det1.dp(:,3)';% Data pointer, where the signal can be found. 
s.dp_z.axes.Label.String	= {'$p_z$ [a.u.]'}; %The label of the variable

%%%%%% Radial Momentum (R):
s.dp_R				= s.dp_x;
s.dp_R.hist.pointer	= 'h.det1.dp_R';% Data pointer, where the signal can be found. 
s.dp_R.hist.Range(1)= 0;% [au] range of the variable. 
s.dp_R.axes.Lim(1)= 0;% [au] range of the variable. 
s.dp_R.axes.Label.String	= {'$p_R$ [a.u.]'}; %The label of the variable

%%%%%% Momentum elevation (Phi):
% Histogram metadata:
s.dp_phi.hist.pointer	= 'h.det1.dp_phi';% Data pointer, where the signal can be found. 
s.dp_phi.hist.binsize	= 0.1;% [a.u.] binsize of the variable. 
s.dp_phi.hist.Range		= [-pi/2 pi/2];% [au] range of the variable. 
% Axes metadata:
s.dp_phi.axes.Lim	= s.dp_phi.hist.Range;% [au] Lim of the axis that shows the variable. 
s.dp_phi.axes.Tick	= -3:0.5:3;% [au] Ticks on the respective axes.
s.dp_phi.axes.Label.String	= {'$p_{\phi}$ [rad]'}; %The label of the variable

%%%%%% Momentum norm:
s.dp_norm.hist.pointer	= 'h.det1.dp_norm';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.dp_norm.hist.binsize	= [0.4];% [a.u.] binsize of the variable. 
s.dp_norm.hist.Range	= [15 50];% [au] range of the variable. 
% Axes metadata:
s.dp_norm.axes.Lim	= s.dp_norm.hist.Range;% [au] Lim of the axis that shows the variable. 
s.dp_norm.axes.Tick	= s.dp_norm.hist.Range(1):5:s.dp_norm.hist.Range(2);% [au] Ticks on the respective axes.
s.dp_norm.axes.Label.String	= {'$|\vec{p}|$ [a.u.]'}; %The label of the variable

%%%%%% Momentum sum norm:
s.dp_sum_norm.hist.pointer	= 'e.det1.dp_sum_norm';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.dp_sum_norm.hist.binsize	= [2];% [a.u.] binsize of the variable. 
s.dp_sum_norm.hist.Range	= [0 200];% [au] range of the variable. 
% Axes metadata:
s.dp_sum_norm.axes.Lim	= s.dp_sum_norm.hist.Range;% [au] Lim of the axis that shows the variable. 
s.dp_sum_norm.axes.Tick	= 0:50:150;% [au] Ticks on the respective axes.
s.dp_sum_norm.axes.Label.String	= {'$|p_{sum}|$ [a.u.]'}; %The label of the variable
% Condition metadata:
s.dp_sum_norm.cond			= [];

%%%%%% angular correlation of momenta p_corr_C2:
s.angle_p_corr_C2.hist.pointer	= 'e.det1.angle_p_corr_C2';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.angle_p_corr_C2.hist.binsize	= [pi/40];% [a.u.] binsize of the variable. 
s.angle_p_corr_C2.hist.Range	= [0.1 pi-0.01];% [au] range of the variable. 
s.angle_p_corr_C2.hist.ifdo.Solid_angle_correction	= true;% The binsize is equal for equal solid angle sizes (sin(theta)^-1)
% Axes metadata:
s.angle_p_corr_C2.axes.Lim	= [0 180];% [au] Lim of the axis that shows the variable. 
s.angle_p_corr_C2.axes.Tick	= linspace(0, 180, 7);% [au] Ticks on the respective axes.
s.angle_p_corr_C2.axes.Label.String	= {'mutual angle [deg]'}; %The label of the variable
% Condition metadata:
s.angle_p_corr_C2.cond			= exp_md.cond.angle_p_corr_C2;

%%%%%% Kinetic Energy Release:
s.KER_sum.hist.pointer	= 'e.det1.KER_sum';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.KER_sum.hist.binsize	=  0.5; %[eV] binsize of the CSD variable. 
s.KER_sum.hist.Range	= [0 15]; %[eV] range of the variable. 
% Axes metadata:
s.KER_sum.axes.Lim	= s.KER_sum.hist.Range;% [eV] Lim of the axis that shows the variable. 
s.KER_sum.axes.Tick	= linspace(s.KER_sum.axes.Lim(1), s.KER_sum.axes.Lim(2), 6);% [au] Ticks on the respective axes.
s.KER_sum.axes.Label.String	= {'Total ion KER [eV]'}; %The label of the variable
% Condition metadata:
s.KER_sum.cond			= exp_md.cond.angle_p_corr_C2;

%%%%%% Charge Separation Distance (CSD):
s.CSD.hist.pointer	= 'e.det1.CSD';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.CSD.hist.binsize	= 1*1e0; %[Ångström] binsize of the CSD variable. 
s.CSD.hist.Range	= [0 1]*1e2; %[Ångström] range of the variable. 
% Axes metadata:
s.CSD.axes.Lim	= s.CSD.hist.Range;% [Ångström] Lim of the axis that shows the variable. 
s.CSD.axes.Tick	= linspace(s.CSD.hist.Range(1), s.CSD.hist.Range(2), 11);% [au] Ticks on the respective axes.
s.CSD.axes.Label.String	= {'CSD [\AA]'}; %The label of the variable
% Condition metadata:
s.CSD.cond			= exp_md.cond.angle_p_corr_C2;

%%%%%% Extra axes defaults:
s.add_m2q.axes.YLabel.String	= '';
s.add_m2q.axes.XLabel.String	= 'm2q';
s.add_m2q.axes.YTick			= [];
s.add_m2q.axes.XAxisLocation	= 'top';
s.add_m2q.axes.YAxisLocation	= 'right';

s.add_cluster_size_X.axes.XLabel.String	= 'Recorded cluster size';
s.add_cluster_size_X.axes.XAxisLocation	= 'top';
s.add_cluster_size_X.axes.YAxisLocation	= 'right';
s.add_cluster_size_X.axes.YTick			= [];
s.add_cluster_size_X.axes.YLabel.String	= [];

s.add_CSD.axes.YLabel.String	= 'CSD';
s.add_CSD.axes.XLabel.String	= 'Recorded cluster size';
s.add_CSD.axes.YTick			= [];
s.add_CSD.axes.XAxisLocation	= 'top';
s.add_CSD.axes.YAxisLocation	= 'right';

exp_md.plot.signal	= s;