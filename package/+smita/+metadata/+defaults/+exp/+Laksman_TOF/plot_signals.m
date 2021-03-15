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
% s.TOF.hist.binsize	= 5;% [ns] binsize of the variable. 
s.TOF.hist.binsize	= 3;% [ns] binsize of the variable. 
% s.TOF.hist.Range	= [3.74e3 8.2e3];% [ns] range of the variable. 
% s.TOF.hist.Range	= [5.4e3 20000];% [ns] range of the variable. 
% s.TOF.hist.binsize	= 0.5;% [ns] binsize of the variable. 
s.TOF.hist.Range	= [1000 20000];% [ns] range of the variable. 
% s.TOF.hist.binsize	= 0.09;% [ns] binsize of the variable. 
% Axes metadata:
s.TOF.axes.Lim		= s.TOF.hist.Range;% [ns] Lim of the axis that shows the variable. 
s.TOF.axes.Tick	= round(unique(convert.m2q_2_TOF(exp_md.conv.det1.m2q_label.labels, ...
								exp_md.conv.det1.m2q.factor, ...
								exp_md.conv.det1.m2q.t0)));% [ns] Tick of the axis that shows the variable.
s.TOF.axes.Label.String	= 'TOF [ns]'; %The label of the variable

%%%%%% X:
s.X.hist.pointer		= 'h.det1.X';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.X.hist.binsize		= 0.1;% [mm] binsize of the variable. 
s.X.hist.Range			= [-60 60];% [mm] range of the variable. 
% Axes metadata:
s.X.axes.Lim			= [-60 60];% [ns] Lim of the axis that shows the variable. 
s.X.axes.Tick			=  -60:10:60;% [ns] Ticks shown 
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
s.m2q.hist.binsize	=0.1; %0.005;% [Da] binsize of the variable. 
s.m2q.hist.Range	= [0 1000];% [Da] range of the variable. 
% s.m2q.hist.Range	= [0 150];% [Da] range of the variable. 
% s.m2q.hist.Range	= [40 90];% [Da] range of the variable. 
s.m2q.hist.Integrated_value	= 100;
% Axes metadata:
s.m2q.axes.Lim		= s.m2q.hist.Range;% [Da] Lim of the axis that shows the variable. 
s.m2q.axes.Tick	=  exp_md.conv.det1.m2q_label.labels; %[12 32 44 44.*(2:10)]; %; [Da] Tick of the axis that shows the variable.
% s.m2q.axes.Tick	= exp_md.sample.fragment.masses; % [Da] Tick of the axis that shows the variable.
% s.m2q.cond		=exp_md.cond.def.X;% macro.filter.write_coincidence_condition(2, 'det1');
s.m2q.axes.Label.String	= 'm/q [Da]'; %The label of the variable

%%%%%% Mass-to-charge:
s.m2q_l.hist.pointer	= 'h.det1.m2q_l';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.m2q_l.hist.binsize	=1; %0.005;% [Da] binsize of the variable. 
s.m2q_l.hist.Range	= [0 10*44];% [Da] range of the variable. 
% s.m2q.hist.Range	= [0 150];% [Da] range of the variable. 
% s.m2q.hist.Range	= [40 90];% [Da] range of the variable. 
% s.m2q_l.hist.Integrated_value	= 100;
% Axes metadata:
s.m2q_l.axes.Lim		= s.m2q_l.hist.Range;% [Da] Lim of the axis that shows the variable. 
s.m2q_l.axes.Tick	=  exp_md.conv.det1.m2q_label.labels; %[12 32 44 44.*(2:10)]; %; [Da] Tick of the axis that shows the variable.
% s.m2q_l.axes.Tick	= exp_md.sample.fragment.masses; % [Da] Tick of the axis that shows the variable.
% s.m2q_l.cond		=exp_md.cond.def.X;% macro.filter.write_coincidence_condition(2, 'det1');
s.m2q_l.axes.Label.String	= 'm/q [Da]'; %The label of the variable

%%%%%% Mass-to-charge sum:
s.m2q_l_sum.hist.pointer	= 'e.det1.m2q_l_sum';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.m2q_l_sum.hist.binsize	= 0.1;% [Da] binsize of the variable. 
s.m2q_l_sum.hist.Range	= [0 400];% [Da] range of the variable. 
% Axes metadata:
s.m2q_l_sum.axes.Lim		= [0 400];% [Da] Lim of the axis that shows the variable. 
s.m2q_l_sum.axes.Tick	= exp_md.conv.det1.m2q_label.labels; %exp_md.sample.fragment.masses; % [Da] Tick of the axis that shows the variable. 
s.m2q_l_sum.axes.Label.String	= 'm/q [Da]'; %The label of the variable

%%%%%% Mass-to-charge background:
s.m2q_bgr			= s.m2q;
s.m2q_bgr.hist.pointer	= 'h.det1.m2q_bgr';% Data pointer, where the signal can be found. 

%%%%%% Momentum:
s.dp.hist.pointer	= 'h.det1.dp';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.dp.hist.binsize	= [0.5 0.5 0.5];% [a.u.] binsize of the variable. 
s.dp.hist.Range	= [-200 200; -200 200; -200 200];% [au] range of the variable. 
% Axes metadata:
s.dp.axes.Lim	= s.dp.hist.Range;% [au] Lim of the axis that shows the variable. 
% s.dp.axes.Tick	= s.dp.hist.Range(1):10:s.dp.hist.Range(2);% [au] Ticks on the respective axes.
s.dp.axes.Label.String	= {'p_x [a.u.]', 'p_y [a.u.]', 'p_z [a.u.]'}; %The label of the variable

%%%%%% Momentum x:
s.dp_x.hist.pointer	= 'h.det1.dp(:,1)';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.dp_x.hist.binsize	= [1];% [a.u.] binsize of the variable. 
s.dp_x.hist.Range	= [-150 150];% [au] range of the variable. 
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

%%%%%% Momentum norm (hit):
s.dp_norm.hist.pointer	= 'h.det1.dp_norm';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.dp_norm.hist.binsize	= [5];% 0.4 [a.u.] binsize of the variable. 
s.dp_norm.hist.Range	= [-0.1 300];% [au] range of the variable. 
% Axes metadata:
s.dp_norm.axes.Lim	= s.dp_norm.hist.Range;% [au] Lim of the axis that shows the variable. 
s.dp_norm.axes.Tick	= s.dp_norm.hist.Range(1):50:s.dp_norm.hist.Range(2);% [au] Ticks on the respective axes.
s.dp_norm.axes.Label.String	= {'$|\vec{p}|$ [a.u.]','Interpreter','latex'}; %The label of the variable

%%%%%% Momentum sum norm (event):
s.dp_sum_norm.hist.pointer	= 'e.det1.dp_sum_norm';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.dp_sum_norm.hist.binsize	= [5];%0.75 2 0.5[a.u.] binsize of the variable. 
s.dp_sum_norm.hist.Range	= [0 300];% [au] range of the variable. 
% Axes metadata:
s.dp_sum_norm.axes.Lim	=[-0.1 300];% s.dp_sum_norm.hist.Range;% [au] Lim of the axis that shows the variable. 
s.dp_sum_norm.axes.Tick	= 0:50:300;% [au] Ticks on the respective axes.
s.dp_sum_norm.axes.Label.String	= {'|p_{sum}| [a.u.]'}; %The label of the variable
% Condition metadata:
% s.dp_sum_norm.cond= mdata.calib.det1.momentum.cond  ;
% s.dp_sum_norm.cond= mdata.calib.det1.momentum.cond  ;
% s.dp_sum_norm.cond.co2			= exp_md.cond.def.label;
% s.dp_sum_norm.cond.co2.type = 'continuous';
% s.dp_sum_norm.cond.co2.value= [0;60];


%%%%%% angular correlation of momenta p_corr_C2:
s.angle_p_corr_C2.hist.pointer	= 'e.det1.angle_p_corr_C2';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.angle_p_corr_C2.hist.binsize	= [5.0*pi/180];% pi/40[a.u.] binsize of the variable. 
s.angle_p_corr_C2.hist.Range	= [0.1 pi-0.01];%[0.1e-8 pi-0.1e-8];%0.1 pi-0.01 [au] range of the variable. 
s.angle_p_corr_C2.hist.ifdo.Solid_angle_correction	= true;% The binsize is equal for equal solid angle sizes (sin(theta)^-1)
% Axes metadata:
s.angle_p_corr_C2.axes.Lim	= [0 180];% [0 180] [au] Lim of the axis that shows the variable. 
s.angle_p_corr_C2.axes.Tick	= linspace(0, 180, 7);% [au] Ticks on the respective axes.
s.angle_p_corr_C2.axes.Label.String	= {'mutual angle [deg]'}; %The label of the variable

%%%%%% angular correlation of momenta p_corr_C3:
s.angle_p_corr_C3.hist.pointer	= 'e.det1.angle_p_corr_C3';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.angle_p_corr_C3.hist.binsize	= [0.5*pi/180];% [a.u.] binsize of the variable. 
s.angle_p_corr_C3.hist.Range	= [0 pi-0.01];%[0.1 pi-0.01] [au] range of the variable. 
s.angle_p_corr_C3.hist.ifdo.Solid_angle_correction	= true;% The binsize is equal for equal solid angle sizes (sin(theta)^-1)
% Axes metadata:
s.angle_p_corr_C3.axes.Lim	= [0 180];% [0 180] [au] Lim of the axis that shows the variable. 
s.angle_p_corr_C3.axes.Tick	= linspace(0, 180, 7);% [au] Ticks on the respective axes.
s.angle_p_corr_C3.axes.Label.String	= {'mutual angle [deg]'}; %The label of the variable

%%%%%% Kinetic Energy Release:
s.KER_sum.hist.pointer	= 'e.det1.KER_sum';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.KER_sum.hist.binsize	=  0.2;%0.01; 0.05 %[eV] binsize of the CSD variable. 
s.KER_sum.hist.Range	= [0 10]; %[eV] range of the variable. 
% s.KER_sum.cond= exp_md.cond.def.dp_sum  ;
% s.KER_sum.cond= exp_md.cond;
% Axes metadata:
s.KER_sum.axes.Lim	= s.KER_sum.hist.Range;% [eV] Lim of the axis that shows the variable. 
s.KER_sum.axes.Tick	= s.KER_sum.axes.Lim(1):1: s.KER_sum.axes.Lim(2);% [au] Ticks on the respective axes.
s.KER_sum.axes.Label.String	= {'Total ion KER [eV]'}; %The label of the variable

%%%ker hit
s.KER_hit.hist.pointer	= 'h.det1.KER';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.KER_hit.hist.binsize	=  0.1;%0.01; 0.05 %[eV] binsize of the CSD variable. 
% s.KER_hit.hist.Integrated_value	= 100;
s.KER_hit.hist.Range	= [0 10]; %[eV] range of the variable. 
s.KER_hit.axes.Lim	= s.KER_hit.hist.Range;% [eV] Lim of the axis that shows the variable. 
s.KER_hit.axes.Tick	= s.KER_hit.axes.Lim(1):1: s.KER_hit.axes.Lim(2);% [au] Ticks on the respective axes.
s.KER_hit.axes.Label.String	= {'Ion KER [eV]'}; %The label of the variable


%%%%%% Cluster size:
s.cluster_size_total.hist.pointer	= 'e.det1.cluster_size_total';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.cluster_size_total.hist.binsize	=  1; %[eV] binsize of the CSD variable. 
s.cluster_size_total.hist.Range	= [2 20]; % range of the variable. 
% s.cluster_size_total.cond= exp_md.cond.def.dp_sum  ;
% Axes metadata:
s.cluster_size_total.axes.Lim	= s.cluster_size_total.hist.Range;% [eV] Lim of the axis that shows the variable. 
s.cluster_size_total.axes.Tick	= [2:4:20];%2:5:20;% [au] Ticks on the respective axes.
s.cluster_size_total.axes.Label.String	= {'Cluster size (no. of molecules)'}; %The label of the variable


%%%%%% Charge Separation Distance (CSD):
s.CSD.hist.pointer	= 'e.det1.CSD';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.CSD.hist.binsize	= 1*1e0; %[?ngstr?m] binsize of the CSD variable. 
s.CSD.hist.Range	= [0 60]; %[?ngstr?m] range of the variable. 
% Axes metadata:
s.CSD.axes.Lim	= s.CSD.hist.Range;% [?ngstr?m] Lim of the axis that shows the variable. 
s.CSD.axes.Tick	= linspace(s.CSD.hist.Range(1), s.CSD.hist.Range(2), 7);% [au] Ticks on the respective axes.
s.CSD.axes.Label.String	= {['CSD (',char(197),')'],'Interpreter','tex'}; %The label of the variable

%% Dalitz plot signals

%%%%%% Momentum norm squared:
s.dp_norm_squared.hist.pointer	= '(exp.h.det1.dp_norm).^2';% Data pointer, where the signal can be found. 
% Histogram metadata:
% s.dp_norm_squared.hist.binsize	= [18^2]; %[2^2];%[3^2]; % [a.u.] binsize of the variable. 
s.dp_norm_squared.hist.binsize  = 300; %600; %[18^2]; %[2^2];%[3^2]; % [a.u.] binsize of the variable. 
s.dp_norm_squared.hist.Range	= [0 150^2];% [au] range of the variable. 
% Axes metadata:
s.dp_norm_squared.axes.Lim	= s.dp_norm_squared.hist.Range;% [au] Lim of the axis that shows the variable. 
s.dp_norm_squared.axes.Tick	= s.dp_norm_squared.hist.Range(1):4000:s.dp_norm_squared.hist.Range(2);% [au] Ticks on the respective axes.
s.dp_norm_squared.axes.Label.String	= {'$|p|^2$ [a.u.]'}; %The label of the variable


%%%%%% Momentum sum norm squared:
s.dp_sum_norm_squared.hist.pointer	= '(exp.e.det1.dp_sum_norm).^2';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.dp_sum_norm_squared.hist.binsize	= 300; %[25^2] ; %[250];%[1000][a.u.] binsize of the variable. 
s.dp_sum_norm_squared.hist.Range	= [0 150^2];% [au] range of the variable. 
% Axes metadata:
s.dp_sum_norm_squared.axes.Lim	= s.dp_sum_norm_squared.hist.Range;% [au] Lim of the axis that shows the variable. 
s.dp_sum_norm_squared.axes.Tick	= s.dp_sum_norm_squared.hist.Range(1):4000:s.dp_sum_norm_squared.hist.Range(2);% [au] Ticks on the respective axes.
s.dp_sum_norm_squared.axes.Label.String	= {'$|p_{sum}|^2$ [a.u.]'}; %The label of the variable
% Condition metadata:
% s.dp_sum_norm_squared.cond			= [];
%% 



%%%%%% Extra axes defaults:
s.add_m2q.axes.YLabel.String	= '';
s.add_m2q.axes.XLabel.String	= 'm2q';
s.add_m2q.axes.YTick			= [];
s.add_m2q.axes.XAxisLocation	= 'top';
s.add_m2q.axes.YAxisLocation	= 'right';

s.add_cluster_size.axes.YLabel.String	= 'Recorded cluster size';
s.add_cluster_size.axes.XLabel.String	= 'Recorded cluster size';
s.add_cluster_size.axes.XAxisLocation	= 'top';
s.add_cluster_size.axes.YAxisLocation	= 'right';

s.add_CSD.axes.YLabel.String	= 'CSD';
s.add_CSD.axes.XLabel.String	= 'Recorded cluster size';
s.add_CSD.axes.YTick			= [];
s.add_CSD.axes.XAxisLocation	= 'top';
s.add_CSD.axes.YAxisLocation	= 'right';

exp_md.plot.signal = s;