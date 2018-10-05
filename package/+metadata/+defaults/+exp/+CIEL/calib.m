function [ exp_md ] = calib ( exp_md )
% This convenience funciton lists the default correction metadata, and can be
% read by other experiment-specific metadata files.

%% Condition: We define whether the calibration should be done or not

cd1.ifdo.R_circle           = false;
cd1.ifdo.TOF_2_m2q          = true;
cd1.ifdo.momentum           = false;





%% Preparation: We define the signals:
%%%%%% TOF:
signals.i_TOF.hist.pointer	= 'h.det2.raw(:,3)';% Data pointer, where the signal can be found. 
% Histogram metadata:
signals.i_TOF.hist.binsize	= 1;% [ns] binsize of the variable. 
signals.i_TOF.hist.Range	= [0 2.5e4];% [ns] range of the variable. 
% Axes metadata:
signals.i_TOF.axes.Lim		= signals.i_TOF.hist.Range;% [ns] Lim of the axis that shows the variable. 
signals.i_TOF.axes.Tick		= 0:1e3:1e5;% [ns] Tick of the axis that shows the variable.
signals.i_TOF.axes.Label.String	= 'TOF [ns]'; %The label of the variable

signals.e_TOF = signals.i_TOF;
signals.e_TOF.hist.pointer	= 'h.det1.TOF';
signals.e_TOF.hist.binsize	= 1;
signals.e_TOF.hist.Range	= [0 1000];
signals.e_TOF.axes.Lim		= signals.e_TOF.hist.Range;
%%%%%% Mass-to-charge:
% Histogram metadata:
signals.i_m2q.hist.binsize	= 0.5;% [Da] binsize of the variable. 
signals.i_m2q.hist.Range	= [1 400];% [Da] range of the variable. 
% Axes metadata:
signals.i_m2q.axes.Lim		= [0 100];% [Da] Lim of the axis that shows the variable. 
%signals.i_m2q.axes.Tick	= exp_md.sample.mass; % [Da] Tick of the axis that shows the variable. 
signals.i_m2q.axes.Label.String	= 'm/q [Da]'; %The label of the variable

signals.e_m2q = signals.i_m2q;


%%%%%% Momentum:
p_Lim				= [-1 1]*1e2;% [au] range of the variable. 
p_binsize			= 3e0; % [au] binsize of the variable. 

signals.px.hist.pointer	= 'h.det1.dp(:,1)';% Data pointer, where the signal can be found. 
% Histogram metadata:
signals.px.hist.binsize	= p_binsize;% [a.u.] binsize of the variable. 
signals.px.hist.Range		= p_Lim;
% Axes metadata:
signals.px.axes.Lim	= signals.px.hist.Range;% [au] Lim of the axis that shows the variable. 
signals.px.axes.Tick	= hist.bins(p_Lim, 30);% [au] Ticks on the respective axes.
signals.px.axes.Label.String	= {'$p_x$ [a.u.]'}; %The label of the variable

[signals.py, signals.pz, signals.pnorm] = deal(signals.px, signals.px, signals.px);
[signals.py.hist.pointer, signals.pz.hist.pointer, signals.pnorm.hist.pointer]				= deal('h.det1.dp(:,2)', 'h.det1.dp(:,3)', 'h.det1.p_norm');
[signals.py.axes.Label.String, signals.pz.axes.Label.String, signals.pnorm.axes.Label.String]	= deal({'$p_y$ [a.u.]'}, {'$p_z$ [a.u.]'}, {'$|p|$ [a.u.]'});

% The calibration procedure requires parameters.

cd1.R_circle.isplotted			= true ;% Should the calibration procedure be visual (show plot)
cd1.R_circle.ROI					= [26 32];% [mm] the regions of interest to find the peaks. The first row defines the ROI that is used as global scaling.
cd1.R_circle.filter_width		= 1; %[mm] width of the median filter applied before maximum finding.
cd1.R_circle.plot.hist.binsize       = [0.1 0.05]; %[rad, mm] binsize of the m2q variable. 
cd1.R_circle.plot.hist.Range		= [-pi pi; 20 35]; % [rad, mm] x,y range of the data on y-axis.
cd1.R_circle.plot.axes.XLabel		= '$\theta$ [rad]'; % label on x-axis.
cd1.R_circle.plot.axes.YLabel		= 'R [mm]'; % label on y-axis.
cd1.R_circle.plot.axes.colormap		= plot.custom_RGB_colormap(); % type of colormap
cd1.R_circle.plot.axes.hold			= 'on'; % type of colormap
cd1.R_circle.plot.axes.Type			= 'axes';

%% Define the calibration metadata:
cd1.TOF_2_m2q.name = 'electron';
% TOF to m2q conversion (e)
cd1.TOF_2_m2q.TOF							= metadata.create.plot.signal_2_plot({signals.e_TOF});
cd1.TOF_2_m2q.TOF.hist.Integrated_value	= 1;
cd1.TOF_2_m2q.m2q							= metadata.create.plot.signal_2_plot({signals.e_m2q});
cd1.TOF_2_m2q.findpeak.search_radius		= 10;% [ns] The search radius around the indicated point, where the algorithm will look for a peak.
cd1.TOF_2_m2q.findpeak.binsize				= 0.05;% [ns] The search radius around the indicated point, where the algorithm will look for a peak.


% Plot style for 2D momentum histogram:
cd1.momentum.labels_to_show = 5.5e-4 ;%(3:end);%general.fragment_masses(exp_md.sample.constituent.masses, exp_md.sample.constituent.nof); 
cd1.momentum.binsize       	= [0.007, 0.007]*1e0; %[a.u.] binsize of the m2q variable. 
cd1.momentum.x_range		= [-1 1]*1e0; % [a.u.] x range of the data on x-axis.
cd1.momentum.y_range		= [-1 1]*1e0; % [a.u.] y range of the data on y-axis.
              
cd1.momentum.cond.elec.type               = 'continuous';
cd1.momentum.cond.elec.data_pointer       = 'h.det1.R';
cd1.momentum.cond.elec.value              = [0;20];
cd1.momentum.cond.elec.translate_condition = 'AND';
cd1.momentum.cond.ion.y.type                 = 'continuous';
cd1.momentum.cond.ion.y.data_pointer       = 'h.det2.Y';
cd1.momentum.cond.ion.y.value              = [-0.5;0.5];
cd1.momentum.cond.ion.y.translate_condition = 'AND';
cd1.momentum.cond.ion.x.type                 = 'continuous';
cd1.momentum.cond.ion.x.data_pointer       = 'h.det2.X';
cd1.momentum.cond.ion.x.value              = [-0.5;0.5];
cd1.momentum.cond.ion.x.translate_condition = 'AND';


%%%%%%%%%%%%%DETECTOR 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOF to m2q conversion (i)
cd2.TOF_2_m2q.name = 'ion';
cd2.TOF_2_m2q.TOF							= metadata.create.plot.signal_2_plot({signals.i_TOF});
cd2.TOF_2_m2q.TOF.hist.Integrated_value	= 1;
cd2.TOF_2_m2q.m2q							= metadata.create.plot.signal_2_plot({signals.i_m2q});
cd2.TOF_2_m2q.findpeak.search_radius		= 10;% [ns] The search radius around the indicated point, where the algorithm will look for a peak.
cd2.TOF_2_m2q.findpeak.binsize				= 0.05;% [ns] The search radius around the indicated point, where the algorithm will look for a peak.
% 
cd2.momentum.hist.binsize       = [0.007, 0.007]*1e0; %[a.u.] binsize of the m2q variable. 
cd2.momentum.hist.Range			= [-1 1]*3e2; % [a.u.] x range of the data on x-axis.
cd2.momentum.hist.pointer		= 'h.det1.raw';

% Plot style for 2D momentum histogram:
cd2.momentum.labels_to_show = exp_md.sample.fragment.masses;%(3:end);%general.fragment_masses(exp_md.sample.constituent.masses, exp_md.sample.constituent.nof); 
cd2.momentum.binsize       	= [1, 1]*4e0; %[a.u.] binsize of the m2q variable. 
cd2.momentum.x_range		= [-1 1]*1e2; % [a.u.] x range of the data on x-axis.
cd2.momentum.y_range		= [-1 1]*1e2; % [a.u.] y range of the data on y-axis.

% 
cd2.momentum.cond.eRiXY.y.type               = 'continuous';
cd2.momentum.cond.eRiXY.y.data_pointer       = 'h.det2.Y';
cd2.momentum.cond.eRiXY.y.value              = [-1;1];
cd2.momentum.cond.eRiXY.y.translate_condition = 'AND';
cd2.momentum.cond.eRiXY.x1.type               = 'continuous';
cd2.momentum.cond.eRiXY.x1.data_pointer       = 'h.det2.X';
cd2.momentum.cond.eRiXY.x1.value              = [-1;1];
cd2.momentum.cond.eRiXY.x1.translate_condition = 'AND';
cd2.momentum.cond.eRiXY.eR.type               = 'continuous';
cd2.momentum.cond.eRiXY.eR.data_pointer       = 'h.det1.R';
cd2.momentum.cond.eRiXY.eR.value              = [0;24.5];
cd2.momentum.cond.eRiXY.eR.translate_condition = 'AND';




exp_md.calib.det1 = cd1;
exp_md.calib.det2 = cd2;
end

