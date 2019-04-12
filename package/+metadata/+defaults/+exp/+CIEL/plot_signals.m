function [exp_md] = plot_signals(exp_md)
% This metadata file describes the signal plotting preferences.
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SIGNALS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Each signal has its own configuration metadata:

%%%%%%%%%%%%%%%% ELECTRON (DET1) SIGNALS

%%%%%% mult: (multiplicity of the event)
s.e_mult.hist.pointer	= 'e.det1.mult';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.e_mult.hist.binsize	= 1;% [-] binsize of the variable. 
s.e_mult.hist.Range	= [0 4];% [-] range of the variable. 
% Axes metadata:
s.e_mult.axes.Lim		= [s.e_mult.hist.Range(1)-0.5 s.e_mult.hist.Range(2)+0.5];% [-] Lim of the axis that shows the variable. 
s.e_mult.axes.Tick		= s.e_mult.hist.Range(1):1:s.e_mult.hist.Range(2);
s.e_mult.axes.Label.String	= 'Number of hits'; %The label of the variable

%%%%%% electron Radius:
s.e_R.hist.pointer		= 'h.det1.R';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.e_R.hist.binsize		= 0.05;% [mm] binsize of the variable. 
s.e_R.hist.Range			= [0 40];% [mm] range of the variable. 
% Axes metadata:
s.e_R.axes.Lim			= [0 40];% [mm] Lim of the axis that shows the variable. 
s.e_R.axes.Tick			=  linspace(-40, 40, 41);% [mm] Ticks shown 
s.e_R.axes.Label.String	= 'R [mm]'; %The label of the variable

%%%%% electron Theta:
s.e_Theta.hist.pointer		= 'h.det1.theta';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.e_Theta.hist.binsize		= 0.05;% [rad] binsize of the variable. 
s.e_Theta.hist.Range		= [-pi pi];% [rad] range of the variable. 
% Axes metadata:
s.e_Theta.axes.Lim			= s.e_Theta.hist.Range;% [rad] Lim of the axis that shows the variable. 
s.e_Theta.axes.Tick			=  linspace(-3, 3, 7);% [rad] Ticks shown 
s.e_Theta.axes.Label.String	= 'Theta [rad]'; %The label of the variable

%%%%%% electron TOF:
s.e_TOF.hist.pointer		= 'h.det1.TOF';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.e_TOF.hist.binsize		= 0.1;% 
s.e_TOF.hist.Range			= [0 300];% 
% Axes metadata:
s.e_TOF.axes.Lim			= s.e_TOF.hist.Range;% [mm] Lim of the axis that shows the variable. 
%s.e_TOF.axes.Tick			=  linspace(-40, 40, 11);% [mm] Ticks shown 
s.e_TOF.axes.Label.String	= 'TOF [ns]'; %The label of the variable


%%%%%% electron X:
s.e_X.hist.pointer		= 'h.det1.X';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.e_X.hist.binsize		= 0.4;% [mm] binsize of the variable. 
 s.e_X.hist.Range			= [-50 50];% [mm] range of the variable. 
% Axes metadata:
%s.e_X.axes.Lim			= s.e_X.hist.Range;% [mm] Lim of the axis that shows the variable. 
%s.e_X.axes.Tick			=  linspace(s.e_X.hist.Range(1), s.e_X.hist.Range(2), 11);% [mm] Ticks shown 
s.e_X.axes.Label.String	= 'X [mm]'; %The label of the variable

%%%%%% electron Y:
s.e_Y					= s.e_X;
s.e_Y.hist.pointer		= 'h.det1.Y';% Data pointer, where the signal can be found. 
% Axes metadata:
s.e_Y.axes.Label.String	= 'Y [mm]'; %The label of the variable

%%%%%% electron dpx:
s.e_dpx.hist.pointer		= 'h.det1.dp(:,1)';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.e_dpx.hist.binsize		= 0.007;% [mm] binsize of the variable. 
 s.e_dpx.hist.Range			= [-1 1];% [mm] range of the variable. 
% Axes metadata:
s.e_dpx.axes.Lim			= s.e_dpx.hist.Range;% [mm] Lim of the axis that shows the variable. 
%s.e_dpx.axes.Tick			=  linspace(s.e_dpx.axes.Lim(1), s.e_dpx.axes.Lim(2), 7);% [mm] Ticks shown 
s.e_dpx.axes.Label.String	= 'p_x [a.u.]'; %The label of the variable

%%%%%% electron dpy:
s.e_dpy						= s.e_dpx;
s.e_dpy.hist.pointer		= 'h.det1.dp(:,2)';% Data pointer, where the signal can be found. 
% s.e_dpy.hist.Range			= [-3 3];
s.e_dpy.hist.binsize		= 0.007;
% Axes metadata:
s.e_dpy.axes.Label.String	= 'p_y [a.u.]'; %The label of the variable

%%%%%% electron dpz:
s.e_dpz                     = s.e_dpx;
s.e_dpz.hist.pointer		= 'h.det1.dp(:,3)';% Data pointer, where the signal can be found.
s.e_dpz.axes.Label.String	= 'p_z[a.u.]'; %The label of the variable
s.e_dpz.hist.binsize		= 0.007;
 s.e_dpz.hist.Range			= [-1 1];
 s.e_dpz.axes.Lim			= s.e_dpz.hist.Range;

 
%%%%%% Momentum:
s.e_dp.hist.pointer	= 'h.det1.dp';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.e_dp.hist.binsize	= [0.05 0.05 0.05];% [a.u.] binsize of the variable. 
s.e_dp.hist.Range	= [-5 5; -5 5; -5 5];% [au] range of the variable. 
% Axes metadata:
s.e_dp.axes.Lim	= s.e_dp.hist.Range;% [au] Lim of the axis that shows the variable. 
s.e_dp.axes.Tick	= s.e_dp.hist.Range;% [au] Ticks on the respective axes.
s.e_dp.axes.Label.String	= {'$p_x$ [a.u.]', '$p_y$ [a.u.]', '$p_z$ [a.u.]'}; %The label of the variable

%%%%% Polar and Spherical Angles

s.e_PolAngleXYZ.hist.pointer        = 'h.det1.AzAngle3D';
s.e_PolAngleXYZ.hist.binsize        = 0.0349;% [a.u.] binsize of the variable. 
s.e_PolAngleXYZ.hist.Range          = [0 2*pi];% [au] range of the variable. 
% Axes metadata:
s.e_PolAngleXYZ.axes.Lim            = s.e_PolAngleXYZ.hist.Range;% [au] Lim of the axis that shows the variable. 
s.e_PolAngleXYZ.axes.Label.String	= {'Theta [rad]'};
s.e_PolAngleXYZ.axes.FontSize       = 18;


s.e_PolAngleYZ.hist.pointer         = 'h.det1.PolarPyPz';
s.e_PolAngleYZ.hist.binsize         = 0.0349;% [a.u.] binsize of the variable. 
s.e_PolAngleYZ.hist.Range           = [0 2*pi];% [au] range of the variable. 
% Axes metadata:
s.e_PolAngleYZ.axes.Lim             = s.e_PolAngleYZ.hist.Range;% [au] Lim of the axis that shows the variable. 
s.e_PolAngleYZ.axes.Label.String	= {'Theta [rad]'};

s.e_PolAngleXZ.hist.pointer         = 'h.det1.PolarPxPz';
s.e_PolAngleXZ.hist.binsize         =   0.0349;% [a.u.] binsize of the variable. 
s.e_PolAngleXZ.hist.Range           = [0 2*pi];% [au] range of the variable. 
% Axes metadata:
s.e_PolAngleXZ.axes.Lim             = s.e_PolAngleXZ.hist.Range;% [au] Lim of the axis that shows the variable. 
s.e_PolAngleXZ.axes.Label.String	= {'Theta [rad]'};


 %%%%%% Kinetic Energy Release:
s.e_KER_sum.hist.pointer	= 'h.det1.KER';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.e_KER_sum.hist.binsize	=  0.05; %[eV] binsize of the CSD variable. 
s.e_KER_sum.hist.Range	= [0 12]; %[eV] range of the variable. 
% Axes metadata:
s.e_KER_sum.axes.Lim	= [0 12];% [eV] Lim of the axis that shows the variable. 
s.e_KER_sum.axes.Tick	= linspace(s.e_KER_sum.hist.Range(1), s.e_KER_sum.hist.Range(2), 11);
s.e_KER_sum.axes.Label.String	= {'electron KE [eV]'}; 

s.KERoverAngleUp.hist.pointer         = 'h.det1.KERoverAngleUp';
s.KERoverAngleUp.hist.binsize         =  0.1; %[eV] binsize of the CSD variable. 
s.KERoverAngleUp.hist.Range           = [0 15]; %[eV] range of the variable. 
% Axes metadata:
s.KERoverAngleUp.axes.Lim             = [0 15];% [eV] Lim of the axis that shows the variable. 
%s.KERoverAngleUp.axes.Tick            = linspace(s.KERoverAngleUp.hist.Range(1), s.KERoverAngleUp.hist.Range(2), 11);
s.KERoverAngleUp.axes.Label.String	= {'electron KER [eV]'}; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% ION (DET2) SIGNALS

%%%%%% mult: (multiplicity of the event)
s.i_mult.hist.pointer	= 'e.det2.mult';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.i_mult.hist.binsize	= 1;% [-] binsize of the variable. 
s.i_mult.hist.Range	= [0 4];% [-] range of the variable. 
% Axes metadata:
s.i_mult.axes.Lim		= [s.i_mult.hist.Range(1)-0.5 s.i_mult.hist.Range(2)+0.5];% [-] Lim of the axis that shows the variable. 
s.i_mult.axes.Tick		= s.i_mult.hist.Range(1):1:s.i_mult.hist.Range(2);
s.i_mult.axes.Label.String	= 'Number of hits'; %The label of the variable


%%%%%%%% Polar angles of 
%%%%%% TOF:
s.i_TOF.hist.pointer	= 'h.det2.TOF';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.i_TOF.hist.binsize	= 10;% [ns] binsize of the variable. 
s.i_TOF.hist.Range	= [0 2e4];% [ns] range of the variable. 
% Axes metadata:
s.i_TOF.axes.Lim		= s.i_TOF.hist.Range;% [ns] Lim of the axis that shows the variable. 
s.i_TOF.axes.Tick	= round(unique(convert.m2q_2_TOF(exp_md.conv.det2.m2q_label.labels, ...
								exp_md.conv.det2.m2q.factor, ...
								exp_md.conv.det2.m2q.t0)));% [ns] Tick of the axis that shows the variable.
s.i_TOF.axes.Label.String	= 'TOF [ns]'; %The label of the variable

%%%%%% X:
s.i_X.hist.pointer		= 'h.det2.X';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.i_X.hist.binsize		= 0.5;% [mm] binsize of the variable. 
s.i_X.hist.Range			= [-30 30];% [mm] range of the variable. 
% Axes metadata:
s.i_X.axes.Lim			= s.i_X.hist.Range	;% [ns] Lim of the axis that shows the variable. 
s.i_X.axes.Tick			=  linspace(-40, 40, 11);% [ns] Ticks shown 
s.i_X.axes.Label.String	= 'X [mm]'; %The label of the variable

%%%%%% Y:
s.i_Y					= s.i_X; % This has the same properties as X-coordinate.
s.i_Y.hist.pointer		= 'h.det2.Y';% Data pointer, where the signal can be found. 
s.i_Y.axes.Label.String	= 'Y [mm]'; %The label of the variable

%%%%%% R:
s.i_R						= s.i_X; % This has the same properties as X-coordinate.
s.i_R.hist.Range			= [0 20];% [mm] range of the variable. 
s.i_X.hist.binsize		= 0.25;% [mm] binsize of the variable. 
s.i_R.axes.Lim			= [0 20];% [ns] Lim of the axis that shows the variable. 
s.i_R.hist.pointer		= 'h.det2.R';% Data pointer, where the signal can be found. 
s.i_R.axes.Label.String	= 'R [mm]'; %The label of the variable

%%%%%% Mass-to-charge:
s.i_m2q.hist.pointer	= 'h.det2.m2q';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.i_m2q.hist.binsize	= 1;% [Da] binsize of the variable. 
s.i_m2q.hist.Range	= [17.5 200];% [Da] range of the variable. 
% Axes metadata:
s.i_m2q.axes.Lim		= [0 100];% [Da] Lim of the axis that shows the variable. 
s.i_m2q.axes.Tick	= exp_md.sample.fragment.masses; % [Da] Tick of the axis that shows the variable. 
s.i_m2q.axes.Label.String	= 'm/q [Da]'; %The label of the variable

%%%%%% Mass-to-charge sum:
s.i_m2q_l_sum.hist.pointer	= 'e.det2.m2q_l_sum';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.i_m2q_l_sum.hist.binsize	= 1;% [Da] binsize of the variable. 
s.i_m2q_l_sum.hist.Range	= [0 400];% [Da] range of the variable. 
% Axes metadata:
s.i_m2q_l_sum.axes.Lim		= [0 400];% [Da] Lim of the axis that shows the variable. 
s.i_m2q_l_sum.axes.Tick	= exp_md.sample.fragment.masses; % [Da] Tick of the axis that shows the variable. 
s.i_m2q_l_sum.axes.Label.String	= 'm/q [Da]'; %The label of the variable

%%%%%% Momentum:
s.i_dp.hist.pointer	= 'h.det2.dp';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.i_dp.hist.binsize	= [1 1 1];% [a.u.] binsize of the variable. 
s.i_dp.hist.Range	= [-200 200; -199 300; -100 100];% [au] range of the variable. 
% Axes metadata:
s.i_dp.axes.Lim	= s.i_dp.hist.Range;% [au] Lim of the axis that shows the variable. 
s.i_dp.axes.Tick	= s.i_dp.hist.Range;% [au] Ticks on the respective axes.
s.i_dp.axes.Label.String	= {'$p_x$ [a.u.]', '$p_y$ [a.u.]', '$p_z$ [a.u.]'}; %The label of the variable

%%%%%% Momentum norm:
s.i_p_norm.hist.pointer	= 'h.det2.p_norm';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.i_p_norm.hist.binsize	= [1];% [a.u.] binsize of the variable. 
s.i_p_norm.hist.Range	= [0 100];% [au] range of the variable. 
% Axes metadata:
s.i_p_norm.axes.Lim	= s.i_p_norm.hist.Range;% [au] Lim of the axis that shows the variable. 
s.i_p_norm.axes.Tick	= s.i_p_norm.hist.Range;% [au] Ticks on the respective axes.
s.i_p_norm.axes.Label.String	= {'$|p|$ [a.u.]'}; %The label of the variable

%%%%%% Momentum sum:
s.i_p_sum.hist.pointer	= 'e.det2.p_sum';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.i_p_sum.hist.binsize	= [2 2 2];% [a.u.] binsize of the variable. 
s.i_p_sum.hist.Range	= [-50 50; -50 50; -50 50];% [au] range of the variable. 
% Axes metadata:
s.i_p_sum.axes.Lim	= s.i_p_sum.hist.Range;% [au] Lim of the axis that shows the variable. 
s.i_p_sum.axes.Tick	= 0:50:150;% [au] Ticks on the respective axes.
s.i_p_sum.axes.Label.String	= {'$p_{sum, x}$ [a.u.]', '$p_{sum, y}$ [a.u.]', '$p_{sum, z}$ [a.u.]'}; %The label of the variable
% Condition metadata:
s.i_p_sum.cond			= [];

%%%%%% Momentum sum norm:
s.i_p_sum_norm.hist.pointer	= 'e.det2.p_sum_norm';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.i_p_sum_norm.hist.binsize	= [1];% [a.u.] binsize of the variable. 
s.i_p_sum_norm.hist.Range	= [0 100];% [au] range of the variable. 
% Axes metadata:
s.i_p_sum_norm.axes.Lim	= s.i_p_sum_norm.hist.Range;% [au] Lim of the axis that shows the variable. 
s.i_p_sum_norm.axes.Tick	= 0:20:300;% [au] Ticks on the respective axes.
s.i_p_sum_norm.axes.Label.String	= {'$|p_{sum}|$ [a.u.]'}; %The label of the variable
% Condition metadata:
s.i_p_sum_norm.cond			= [];

s.i_dpx.hist.pointer		= 'h.det2.dp(:,1)';% Data pointer, where the signal can be found. 
s.i_dpx.hist.binsize		= 0.05;
s.i_dpx.hist.Range			= [-100 100];% [mm] range of the variable. 
s.i_dpx.axes.Lim			= s.i_dpx.hist.Range;
% Axes metadata:
s.i_dpx.axes.Label.String	= 'p_x [a.u.]'; %The label of the variable

s.i_dpy.hist.pointer		= 'h.det2.dp(:,2)';% Data pointer, where the signal can be found. 
s.i_dpy.hist.binsize		= 0.05;
s.i_dpy.hist.Range			= [-100 100];% [mm] range of the variable. 
s.i_dpy.axes.Lim			= s.i_dpy.hist.Range;
% Axes metadata:
s.i_dpy.axes.Label.String	= 'p_y [a.u.]'; %The label of the variable

%%%%%% electron dpz:

s.i_dpz.hist.pointer		= 'h.det2.dp(:,3)';% Data pointer, where the signal can be found.
s.i_dpz.axes.Label.String	= 'p_z[a.u.]'; %The label of the variable
s.i_dpz.hist.binsize		= 0.05;
s.i_dpz.hist.Range			= [-100 100];
s.i_dpz.axes.Lim			= s.i_dpz.hist.Range;

%%%%%% angular correlation of momenta p_corr_C2:
s.i_angle_p_corr_C2.hist.pointer	= 'e.det2.angle_p_corr_C2';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.i_angle_p_corr_C2.hist.binsize	= [pi/40];% [a.u.] binsize of the variable. 
s.i_angle_p_corr_C2.hist.Range	= [0.1 pi-0.01];% [au] range of the variable. 
s.i_angle_p_corr_C2.hist.ifdo.Solid_angle_correction	= true;% The binsize is equal for equal solid angle sizes (sin(theta)^-1)
% Axes metadata:
s.i_angle_p_corr_C2.axes.Lim	= [0 180];% [au] Lim of the axis that shows the variable. 
s.i_angle_p_corr_C2.axes.Tick	= linspace(0, 180, 7);% [au] Ticks on the respective axes.
s.i_angle_p_corr_C2.axes.Label.String	= {'mutual angle [deg]'}; %The label of the variable

%%%%%% Kinetic Energy Release:
s.i_KER_sum.hist.pointer	= 'e.det2.KER_sum';% Data pointer, where the signal can be found. 
% Histogram metadata:
s.i_KER_sum.hist.binsize	=  0.05; %[eV] binsize of the CSD variable. 
s.i_KER_sum.hist.Range	= [0 15]; %[eV] range of the variable. 
% Axes metadata:
s.i_KER_sum.axes.Lim	= [0 3];% [eV] Lim of the axis that shows the variable. 
s.i_KER_sum.axes.Tick	= linspace(s.i_KER_sum.hist.Range(1), s.i_KER_sum.hist.Range(2), 11);% [au] Ticks on the respective axes.
s.i_KER_sum.axes.Label.String	= {'Total ion KER [eV]'}; %The label of the variable

%%%%%% Extra axes defaults:
s.add_m2q.axes.YLabel.String	= '';
s.add_m2q.axes.XLabel.String	= 'm/q';
s.add_m2q.axes.YTick			= [];
s.add_m2q.axes.XAxisLocation	= 'top';
s.add_m2q.axes.YAxisLocation	= 'right';

s.add_cluster_size.axes.YLabel.String	= '';
s.add_cluster_size.axes.XLabel.String	= 'Recorded cluster size';
s.add_cluster_size.axes.YTick			= [];
s.add_cluster_size.axes.XAxisLocation	= 'top';
s.add_cluster_size.axes.YAxisLocation	= 'right';

exp_md.plot.signal	= s;