function [ exp_md ] = ICE_calib ( exp_md )
% This convenience funciton lists the default calibration metadata, and can be
% read by other experiment-specific metadata files.

%% Preparation: We define the signals:
% %%%%%% TOF:
% signals.TOF.hist.pointer	= 'h.det1.raw(:,3)';% Data pointer, where the signal can be found. 
% % Histogram metadata:
% signals.TOF.hist.binsize	= 1;% [ns] binsize of the variable. 
% signals.TOF.hist.Range	= [0 2.5e4];% [ns] range of the variable. 
% % Axes metadata:
% signals.TOF.axes.Lim		= signals.TOF.hist.Range;% [ns] Lim of the axis that shows the variable. 
% signals.TOF.axes.Tick		= 0:1e3:1e5;% [ns] Tick of the axis that shows the variable.
% signals.TOF.axes.Label.String	= 'TOF [ns]'; %The label of the variable
% 
% %%%%%% Mass-to-charge:
% % Histogram metadata:
% signals.m2q.hist.binsize	= 0.05;% [Da] binsize of the variable. 
% signals.m2q.hist.Range	    = [1 400];% [Da] range of the variable. 
% % Axes metadata:
% signals.m2q.axes.Lim		= [0 100];% [Da] Lim of the axis that shows the variable. 
% signals.m2q.axes.Tick	= exp_md.sample.fragment.masses; % [Da] Tick of the axis that shows the variable. 
% signals.m2q.axes.Label.String	= 'm/q [Da]'; %The label of the variable
exp_md.plot.signal.i_m2q

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
% 
cd1.momentum.hist.binsize       = [1, 1]*5e0; %[a.u.] binsize of the m2q variable. 
cd1.momentum.hist.Range			= [-1 1]*3e2; % [a.u.] x range of the data on x-axis.
cd1.momentum.hist.pointer		= 'h.det1.raw';
cd1.momentum.labels_to_show     = [2.33];%12;%exp_md.sample.fragment.masses; %exp_md.conv.det1.m2q_label.labels;%(3:end);%general.fragment_masses(exp_md.sample.constituent.masses, exp_md.sample.constituent.nof); 
% cd1.momentum.binsize       	= [1, 1]*1e-1;%0.25e1; %[a.u.] binsize of the m2q variable. 
% cd1.momentum.x_range		= [-1 1]*5; % [a.u.] x range of the data on x-axis.
% cd1.momentum.y_range		= [-1 1]*5; % [a.u.] y range of the data on y-axis.
cd1.momentum.binsize       	= [1, 1]*5;%0.25e1; %[a.u.] binsize of the m2q variable. 
cd1.momentum.x_range		= [-1 1]*60; % [a.u.] x range of the data on x-axis.
cd1.momentum.y_range		= [-1 1]*60; % [a.u.] y range of the data on y-axis.

% TOF to m2q conversion
cd1.TOF_2_m2q.TOF							= metadata.create.plot.signal_2_plot({exp_md.plot.signal.i_TOF});
cd1.TOF_2_m2q.TOF.hist.Integrated_value	    = 1;
cd1.TOF_2_m2q.TOF.hist.Range	            = [0 20000];
cd1.TOF_2_m2q.TOF.axes.XLim                 = cd1.TOF_2_m2q.TOF.hist.Range;
cd1.TOF_2_m2q.m2q							= metadata.create.plot.signal_2_plot({exp_md.plot.signal.i_m2q});
cd1.TOF_2_m2q.findpeak.search_radius		= 10;% [ns] The search radius around the indicated point, where the algorithm will look for a peak.
cd1.TOF_2_m2q.findpeak.binsize				= 0.05;% [ns] The search radius around the indicated point, where the algorithm will look for a peak.
%% Define the calibration metadata:

cd2.momentum.hist.binsize       = [1, 1]*5e0; %[a.u.] binsize of the m2q variable. 
cd2.momentum.hist.Range			= [-1 1]*3e2; % [a.u.] x range of the data on x-axis.
cd2.momentum.hist.pointer		= 'h.det1.raw';

% Plot style for 2D momentum histogram:
cd2.momentum.labels_to_show = exp_md.sample.fragment.masses;%(3:end);%general.fragment_masses(exp_md.sample.constituent.masses, exp_md.sample.constituent.nof); 
cd2.momentum.binsize       	= [1, 1]*4e0; %[a.u.] binsize of the m2q variable. 
cd2.momentum.x_range		= [-1 1]*1e2; % [a.u.] x range of the data on x-axis.
cd2.momentum.y_range		= [-1 1]*1e2; % [a.u.] y range of the data on y-axis.

exp_md.calib.det1 = cd1;
exp_md.calib.det2 = cd2;
end

