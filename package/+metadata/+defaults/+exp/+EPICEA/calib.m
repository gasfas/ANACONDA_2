function [ exp_md ] = calib ( exp_md )
% This convenience funciton lists the default calibration metadata, and can be
% read by other experiment-specific metadata files.

%% Preparation: We define the signals:
%%%%%% TOF:
signals.TOF.hist.pointer	= 'h.det2.raw(:,3)';% Data pointer, where the signal can be found. 
% Histogram metadata:
signals.TOF.hist.binsize	= 2;% [ns] binsize of the variable. 
signals.TOF.hist.Range	= [0 1.5e4];% [ns] range of the variable. 
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

%% Define the calibration metadata:

% The calibration procedure requires parameters.

d1.R_circle.isplotted			= true ;% Should the calibration procedure be visual (show plot)
d1.R_circle.ROI					= [17.6 20; 15.8 17.5; 14 15.5; 12.6 14];% [mm] the regions of interest to find the peaks. The first row defines the ROI that is used as global scaling.
d1.R_circle.filter_width		= 1; %[mm] width of the median filter applied before maximum finding.
d1.R_circle.plot.binsize       = [0.05 0.05]; %[rad, mm] binsize of the m2q variable. 
d1.R_circle.plot.x_range		= [-pi pi]; % [mm] x range of the data on x-axis.
d1.R_circle.plot.y_range		= [10 25]; % [mm] y range of the data on y-axis.
d1.R_circle.plot.x_label		= '$\theta$ [rad]'; % label on x-axis.
d1.R_circle.plot.y_label		= 'R [mm]'; % label on y-axis.
d1.R_circle.plot.colormap		= 'jet'; % type of colormap
d1.R_circle.plot.colorbar		= 'yes'; % Do we want to see a colorbar
d1.R_circle.plot.plottype		= '2D_y_1D';
d1.R_circle.plot.color			= 'r'; % type of colormap
d1.R_circle.plot.colormap		= 'custom'; % type of colormap
d1.R_circle.plot.colormap_r	= [1 1];
d1.R_circle.plot.colormap_g	= [1 0];
d1.R_circle.plot.colormap_b	= [1 0];

% TOF to m2q conversion
d2.TOF_2_m2q.TOF							= metadata.create.plot.signal_2_plot({signals.TOF});
d2.TOF_2_m2q.TOF.hist.Integrated_value	= 1;
d2.TOF_2_m2q.m2q							= metadata.create.plot.signal_2_plot({signals.m2q});
d2.TOF_2_m2q.findpeak.search_radius		= 10;% [ns] The search radius around the indicated point, where the algorithm will look for a peak.
d2.TOF_2_m2q.findpeak.binsize				= 0.05;% [ns] The search radius around the indicated point, where the algorithm will look for a peak.

% Plot style for 2D momentum histogram:
d2.momentum.labels_to_show = exp_md.conv.det2.m2q_label.labels;%(3:end);%general.fragment_masses(exp_md.sample.constituent.masses, exp_md.sample.constituent.nof); 
d2.momentum.binsize       	= [1, 1]*3e0; %[a.u.] binsize of the m2q variable. 
d2.momentum.x_range			= [-1 1]*1.1e2; % [a.u.] x range of the data on x-axis.
d2.momentum.y_range			= [-1 1]*1.1e2; % [a.u.] y range of the data on y-axis.
% d2.momentum.cond.type       = 'discrete';
% d2.momentum.cond.data_pointer = 'h.det2.m2q_l';
% d2.momentum.cond.value       = [14];
% d2.momentum.cond.translate_condition = 'AND';

% metadata for p_res minimization procedure:
d2.p_res_min.ub_offset 		= 0.2; % relative offset of the lower boundary of solution space
d2.p_res_min.lb_offset 		= 0.2; % relative offset of the upper boundary of solution space
d2.p_res_min.hit1.m2q_l		= 17; % The m2q hit label of the first of double coincidence
d2.p_res_min.hit2.m2q_l		= 41; % The m2q hit label of the second of double coincidence
d2.p_res_min.total.m2q_l 	= d2.p_res_min.hit1.m2q_l + d2.p_res_min.hit2.m2q_l ; % The total m2q of the double coincidence;

exp_md.calib.det1 = d1;
exp_md.calib.det2 = d2;
end

