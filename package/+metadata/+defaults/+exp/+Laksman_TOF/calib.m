function [ exp_md ] = calib ( exp_md )
% This convenience funciton lists the default calibration metadata, and can be
% read by other experiment-specific metadata files.

%% Preparation: We define the signals:
%%%%%% TOF:
signals.TOF.hist.pointer	= 'h.det1.raw(:,3)';% Data pointer, where the signal can be found. 
% Histogram metadata:
signals.TOF.hist.binsize	= 2;% [ns] binsize of the variable. 
signals.TOF.hist.Range	= [3.74e3 8.2e3];% [ns] range of the variable. 
signals.TOF.hist.Range	= [0e3 8.2e3];% [ns] range of the variable. 
% Axes metadata:
signals.TOF.axes.Lim		= signals.TOF.hist.Range;% [ns] Lim of the axis that shows the variable. 
signals.TOF.axes.Tick		= 0:1e3:1e5;% [ns] Tick of the axis that shows the variable.
signals.TOF.axes.Label.String	= 'TOF [ns]'; %The label of the variable

%%%%%% Mass-to-charge:
% Histogram metadata:
signals.m2q.hist.binsize	= 0.5;% [Da] binsize of the variable. 
signals.m2q.hist.Range	= [1 400];% [Da] range of the variable. 
% Axes metadata:
signals.m2q.axes.Lim		= [0 100];% [Da] Lim of the axis that shows the variable. 
signals.m2q.axes.Tick	= sort(exp_md.sample.fragment.masses); % [Da] Tick of the axis that shows the variable. 
signals.m2q.axes.Label.String	= 'm/q [Da]'; %The label of the variable

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

%% Define the calibration metadata:

% TOF to m2q conversion
cd1.TOF_2_m2q.TOF							= metadata.create.plot.signal_2_plot({signals.TOF});
cd1.TOF_2_m2q.TOF.hist.Integrated_value	= 1;
cd1.TOF_2_m2q.m2q							= metadata.create.plot.signal_2_plot({signals.m2q});
cd1.TOF_2_m2q.findpeak.search_radius		= 10;% [ns] The search radius around the indicated point, where the algorithm will look for a peak.
cd1.TOF_2_m2q.findpeak.binsize				= 0.05;% [ns] The search radius around the indicated point, where the algorithm will look for a peak.
% 
cd1.momentum.hist.binsize       = [1, 1]*5e0; %[a.u.] binsize of the m2q variable. 
cd1.momentum.hist.Range			= [-1 1]*3e2; % [a.u.] x range of the data on x-axis.
cd1.momentum.hist.pointer		= 'h.det1.raw';

% Plot style for 2D momentum histogram:
cd1.momentum.labels_to_show = [1 16];% exp_md.sample.fragment.masses;%(3:end);%general.fragment_masses(exp_md.sample.constituent.masses, exp_md.sample.constituent.nof); 
cd1.momentum.binsize       	= [1, 1]*2e0; %[a.u.] binsize of the m2q variable. 
cd1.momentum.x_range		= [-1 1]*5e1; % [a.u.] x range of the data on x-axis.
cd1.momentum.y_range		= [-1 1]*5e1; % [a.u.] y range of the data on y-axis.


exp_md.calib.det1 = cd1;
end

