%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EXPERIMENT % METADATA %  EXPERIMENT % METADATA % EXPERIMENT % METADATA %
% This m-file defines the default metadata.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Sample info:
exp_md.sample.name 				= 'Argon'; % [a.m.u.] name of sample
exp_md.sample.type	 			= 'Cluster'; %sample type, can be 'Molecule' or 'Cluster'.
exp_md.sample.fragment.sizes 			= [1:10]';
exp_md.sample.fragment.pure.masses 		= 40; % [a.m.u.] mass of fragments of sample
exp_md.sample.constituent.masses		= [40];
exp_md.sample.fragment.names 			= {'Ar'}; % [] names of fragments
exp_md.sample.fragment.nof 			= [1:10]'; % [] number of fragment masses a single fragment can be composed of.
exp_md.sample.mass 				= sum(exp_md.sample.fragment.pure.masses.*exp_md.sample.fragment.nof);% [a.m.u] mass of sample
exp_md.sample.T 				= 300; %[K] The temperature of the nozzle.
exp_md.sample.p					= 0;
exp_md.sample.v_direction 			= [1 0 0]; % [] direction of the sample supply in X, Y, Z direction.
exp_md.sample.m_avg 				= exp_md.sample.mass; 
exp_md.sample.Mach_number 			= 2.6112; % The factor of the local speed of sound and actual speed. nov
exp_md.sample.Heat_capac_ratio 			= 1.76;% Heat capacity ratio. 1.67 for monoatomic gases, 1.4 for diatomics, 1.33 for water, etc.
exp_md.sample.fragment.masses 			= convert.cluster_fragment_masses(exp_md.sample);

exp_md.photon.energy = 0;

%% Spectrometer info:
exp_md.spec.name = 'Laksman';

% Voltages
exp_md.spec.volt.Ve2s			= 450; %[V] Voltage of grid separating electron side and source region,'pusher'
exp_md.spec.volt.Vs2a			= 0;     %[V] Voltage of grid separating source and acceleration region;  for NH3:0
exp_md.spec.volt.Va2d			= -4000; %[V] Voltage of grid separating acceleration region and drift tube;  for NH3: -3994
exp_md.spec.volt.ion_lens1		= -3250; %-3270 [V] Voltage of ion lens (Laksman ion Drift tube)   for NH3: -3251

% Distances:
exp_md.spec.dist.s0 				= 0.007;% [m] source to ion acceleration region grid 
exp_md.spec.dist.s 				= 0.014;% [m] electron to ion grid. 
exp_md.spec.dist.d 				= 0.093;% [m] length of accelation region
exp_md.spec.dist.D 				= 0.652;% [m] length of drift tube

% detection modes:
exp_md.spec.det_modes = {'ion'}; % The detection mode for detector 1, 2, etc.

exp_md.spec.volt.V_created 		= exp_md.spec.volt.Ve2s + exp_md.spec.dist.s0/exp_md.spec.dist.s * (exp_md.spec.volt.Vs2a - exp_md.spec.volt.Ve2s); % [V]The voltage at light interaction point

exp_md.spec.volt.Ve2s			= 480; %[V] Voltage of grid separating electron side and source region,'pusher'
exp_md.spec.volt.ion_lens1		= -3260; %-3270 [V] Voltage of ion lens (Laksman ion Drift tube)   for NH3: -3251

%% Detector info:
exp_md = my_md.Laksman_TOF.det( exp_md );
exp_md.det.det1.Front_Voltage  	= -2250;%[V]  Detector front potential.


%% Correction parameters:
% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %
% Which corrections should be performed on the data:
exp_md.corr.det1.ifdo.dXdY 			= true;% Does this data need detector image translation correction?
exp_md.corr.det1.ifdo.dTheta 		= true;%; % Does this data need detector image rotation correction?
exp_md.corr.det1.ifdo.dTOF  		= true;% Does this data need detector absolute TOF correction?
exp_md.corr.det1.ifdo.detectorabb	= true;% Does this data need detector-induced abberation correction?
exp_md.corr.det1.ifdo.lensabb 		= true;% Does this data need lens abberation correction?

% The detector image translation parameters:
exp_md.corr.det1.dX					= 0.0;   %[mm] distance the center of detection is displaced left of the origin of the raw image; 
exp_md.corr.det1.dY					= 0.5;   %[mm] distance the center of detection is displaced up the origin of the raw image;
% The detector image rotation parameters:
exp_md.corr.det1.dTheta				= 35;   %[deg] rotation of hits around the raw image centre (anticlockwise);
% The TOF deadtime correction parameter:
exp_md.corr.det1.dTOF 			 	=  0;% [ns] The difference between signal propagation times of trigger and hits.

% The detector abberation parameters:
exp_md.corr.det1.detectorabb.TOF_noKE.p_i	= [0.000023532412340   0.000085163157150  -0.001114418744338  -0.012416517247903                   0]; % The polynomial fit parameters for the TOF correction, making all zero-kinetic energy TOF's equal to the one without abberation.
exp_md.corr.det1.detectorabb.TOF_R.p_i		= [-0.001876121338436  -0.006322279070694                   0                   0];% The polynomial fit parameters for the radial TOF correction
exp_md.corr.det1.detectorabb.dR.p_i			= [0.278118318372887                   0];% The polynomial fit parameters for the radial correction

% The lens abberation parameters:
exp_md.corr.det1.lensabb.TOF_noKE.p_i 	= [.001131257122551   0.003476707189483   0.010406721559879 	0];%  % The polynomial fit parameters for the TOF correction, making all zero-kinetic energy TOF's equal to the one without abberation.
exp_md.corr.det1.lensabb.dR.p_i 			= [3.591547226568072   2.711873874269235   1.222350376192316   0.994428857836460];

% The detector image translation parameters:
exp_md.corr.det1.dX					= 1.5;   %[mm] distance the center of detection is displaced left of the origin of the raw image; 
%exp_md.corr.det1.dX					= 1;   %[mm] distance the center of detection is displaced left of the origin of the raw image; 

exp_md.corr.det1.dY					= 2;   %[mm] distance the center of detection is displaced up the origin of the raw image;
%exp_md.corr.det1.dY					= 0;   %[mm] distance the center of detection is displaced up the origin of the raw image;
% The detector image rotation parameters:
exp_md.corr.det1.dTheta				= 180+35;   %[deg] rotation of hits around the raw image centre (anticlockwise);

% The TOF deadtime correction parameter:
exp_md.corr.det1.dTOF 			 	=  0;%16.95;% [ns] The difference between signal propagation times of trigger and hits for NH3(2009):5 

%% Conversion factors:
% Which conversions should be performed on the data:% Which conversions should be performed on the data:

exp_md.conv.det1.ifdo.m2q						= true;% Does the user want to convert to mass-over-charge?
exp_md.conv.det1.ifdo.m2q_label					= true; % Does the user want to convert to mass-2-charge labels?
exp_md.conv.det1.ifdo.m2q_group_label           = false; % Does the user want to convert to mass-2-charge groups?
exp_md.conv.det1.ifdo.cluster_size				= true;% Does the user want to convert to cluster size?
exp_md.conv.det1.ifdo.momentum					= true;% Does the user want to convert to momentum?
exp_md.conv.det1.ifdo.KER 						= true;% Does the user want to convert to Kinetic energy?
exp_md.conv.det1.ifdo.R_theta					= true;% Does the user want to convert to R-theta coordinates?
exp_md.conv.det1.ifdo.angle_p_corr_C2			= true;% Does the user want to calculate mutual momentum angles of double coindicence?
exp_md.conv.det1.ifdo.angle_p_corr_C3			= true;% Does the user want to calculate mutual momentum angles of triple coincidence?
exp_md.conv.det1.ifdo.q_group_hist					= false;% Does the user want to convert to have q-labels defined?
exp_md.conv.det1.ifdo.CSD						= true;% Does the user want to convert to CSD?
% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1

% Time Of Flight to Mass to Charge calibration
exp_md.conv.det1.m2q.factor      	= 962.3;%Conversion factor from mass 2 charge to TOF
exp_md.conv.det1.m2q.t0          	= 20.5;%[ns] dead time correction

% Time Of Flight to Mass to Charge values
exp_md.conv.det1.m2q_label.labels 		= [exp_md.sample.fragment.masses]; % the available m2q labels.
exp_md.conv.det1.m2q_label.mass 		= exp_md.conv.det1.m2q_label.labels ; % the corresponding expected mass values in this experiment. If all expected particles are singly charged, this array is similar to exp_md.conv.det1.m2q_label.labels.
exp_md.conv.det1.m2q_label.signal 		= 'm2q';% The signal around which the m2q label serach radii are defined. 
exp_md.conv.det1.m2q_label.search_radius= exp_md.conv.det1.m2q_label.labels.^.5*1/10; % search radius (in either m/q or nsec units, depending on the labelling_signal indicated), or searchwidth around the main expectation value (no-Kinetic energy point).

% mass-2-charge group labels
% A mass-2-charge group is  a set of particles close in mass, collected in one 'group'
try
	exp_md.conv.det1.m2q_group_label_label.min = min(exp_md.sample.fragment.pure.masses, [], 2);
	exp_md.conv.det1.m2q_group_label_label.max = max(exp_md.sample.fragment.pure.masses, [], 2);
	exp_md.conv.det1.m2q_group_label_label.name = exp_md.sample.fragment.sizes;
	exp_md.conv.det1.m2q_group_label_label.search_radius = 0.5 + mean([exp_md.conv.det1.m2q_group_label.max, exp_md.conv.det1.m2q_group_label.min], 2)*2/10;
end

exp_md.conv.det1.m2q_label.method = 'circle';
exp_md.conv.det1.m2q_Ci_label.search_radius = 0.75;

exp_md.conv.det1.CSD.include_C1_as_C2 	= false; % This option can include the single coincidence (C1) as a double coincidence event (C2), assuming that all KER went to the detected particle.

exp_md.conv.det1.ifdo.m2q						= true;% Does the user want to convert to mass-over-charge?
exp_md.conv.det1.ifdo.m2q_label			= true; % Does the user want to convert to mass-2-charge labels?
exp_md.conv.det1.ifdo.m2q_group_label		= true; % Does the user want to convert to mass-2-charge groups?

exp_md.conv.det1.ifdo.cluster_size 		= true;% Does the user want to convert to cluster size?
exp_md.conv.det1.ifdo.momentum          = true;% Does the user want to convert to momentum?
exp_md.conv.det1.ifdo.KER 				= true;% Does the user want to convert to Kinetic energy?
exp_md.conv.det1.ifdo.R_theta			= true;% Does the user want to convert to R-theta coordinates?
exp_md.conv.det1.ifdo.angle_p_corr_C2	= false;% Does the user want to calculate mutual momentum angles of double coindicence?
exp_md.conv.det1.ifdo.angle_p_corr_C3	= false;% Does the user want to calculate mutual momentum angles of triple coincidence?
exp_md.conv.det1.ifdo.angle_p_corr_C4	= false;% Does the user want to calculate mutual momentum angles of triple coincidence?
exp_md.conv.det1.ifdo.q_group_hist					= false;% Does the user want to convert to have q-labels defined?
exp_md.conv.det1.ifdo.CSD							= false;% Does the user want to convert to CSD?
exp_md.conv.det1.ifdo.fragment_asymmetry	= false;% Does the user want to convert to fragment asymmetry?
% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1

% Time Of Flight to Mass to Charge values
exp_md.conv.det1.m2q.factor      	= 963.2;%Conversion factor from mass 2 charge to TOF
exp_md.conv.det1.m2q.factor      	= 962.8;%Conversion factor from mass 2 charge to TOF
exp_md.conv.det1.m2q.t0          	= 10;%[ns] time correction

%exp_md.conv.det1.m2q.factor      	= 969;%Conversion factor from mass 2 charge to TOF
%exp_md.conv.det1.m2q.t0          	= 19.4;%[ns] time correction

% When no correction is applied:
%exp_md.conv.det1.m2q.factor      	= 971;%Conversion factor from mass 2 charge to TOF
%exp_md.conv.det1.m2q.t0          	= 10;%[ns] time correction

exp_md.conv.det1.m2q_label.labels 			= [1; 6; 12; 13; 14; 20; 24; 25; exp_md.sample.fragment.masses]; % Including non-protonated clusters.

exp_md.conv.det1.m2q_label.mass 			= exp_md.conv.det1.m2q_label.labels ; % the corresponding expected mass values in this experiment. If all expected particles are singly charged, this array is similar to exp_md.conv.det1.m2q_label.labels.
exp_md.conv.det1.m2q_label.signal 		= 'm2q';% The signal around which the m2q label serach radii are defined. 
exp_md.conv.det1.m2q_label.search_radius		= exp_md.conv.det1.m2q_label.labels.^.5*1/10; % search radius (in either m/q or nsec units, depending on the labelling_signal indicated), or searchwidth around the main expectation value (no-Kinetic energy point).

% mass-2-charge group labels
% A mass-2-charge group is  a set of particles close in mass, collected in one 'group'
exp_md.conv.det1.m2q_group_label.min = min(exp_md.sample.fragment.pure.masses, [], 2);
exp_md.conv.det1.m2q_group_label.max = max(exp_md.sample.fragment.pure.masses, [], 2);
exp_md.conv.det1.m2q_group_label.name = exp_md.sample.fragment.sizes;
exp_md.conv.det1.m2q_group_label.search_radius = 0.5 + mean([exp_md.conv.det1.m2q_group_label.max, exp_md.conv.det1.m2q_group_label.min], 2)*2/10;

exp_md.conv.det1.m2q_label.method = 'circle';
exp_md.conv.det1.m2q_Ci_label.search_radius = 0.75;

%exp_md.conv.det1.m2q_label.method = 'line';
%exp_md.conv.det1.m2q_Ci_label.search_radius = 0.2;

exp_md.conv.det1.angle_p_corr_C3.ifdo.angle_p3_to_p1p2 = true;

%% Condition parameters:
%% Condition defaults
% Some commonly used ones, to refer to later:
% Events:
% Filter the total KER:
exp_md.cond.def.KER_sum.type             = 'continuous';
exp_md.cond.def.KER_sum.data_pointer     = 'e.det1.KER_sum';
exp_md.cond.def.KER_sum.value            = [2.4; 3];
exp_md.cond.def.KER_sum.value            = [0; 80];

% Hits:
% Filter the 'oil peaks' out:
exp_md.cond.def.oil.type                   = 'discrete';
exp_md.cond.def.oil.data_pointer           = 'h.det1.m2q_l';
exp_md.cond.def.oil.value                  = [72; 73];
exp_md.cond.def.oil.translate_condition    = 'AND';
exp_md.cond.def.oil.invert_filter          = true;

% Get rid of large momenta:
exp_md.cond.def.dp_sum.type             = 'continuous';
exp_md.cond.def.dp_sum.data_pointer     = 'e.det1.dp_sum_norm';
exp_md.cond.def.dp_sum.value            = [0; 110];
exp_md.cond.def.dp_sum.translate_condition = 'AND';
exp_md.cond.def.dp_sum.invert_filter     = false;

% make sure one only takes the labeled hits:
exp_md.cond.def.label.type             = 'continuous';
exp_md.cond.def.label.data_pointer     = 'h.det1.m2q_l';
exp_md.cond.def.label.value            = [min(exp_md.conv.det1.m2q_label.labels); max(exp_md.conv.det1.m2q_label.labels)];
exp_md.cond.def.label.translate_condition = 'AND';

%% Conditions
%% Conditions: Labeled hits only

% % Make sure we are looking at labeled hits:
exp_md.cond.label.labeled_hits        = exp_md.cond.def.label;

if isfield(exp_md.sample, 'mass')
	exp_md.cond.label.total_masses.type			= 'continuous';
	exp_md.cond.label.total_masses.data_pointer	= 'e.det1.m2q_l_sum';
	exp_md.cond.label.total_masses.value		= [0; exp_md.sample.mass];
end

% exp_md.cond.label.KER_sum			= exp_md.cond.def.KER_sum;
% exp_md.cond.label.KER_sum.value	= [0; 80];

%%
exp_md.cond.label2.labeled_events        = exp_md.cond.def.label;
exp_md.cond.label2.labeled_events.data_pointer   = 'e.det1.m2q_sum';
exp_md.cond.label2.labeled_events.value	= [0; 146];
exp_md.cond.label2.labeled_events.invert_filter = true;


%% Conditions: BR

% Make a branching ratio filter, for the Ci branching ratio's:
exp_md.cond.BR.label1.type             = 'discrete';
exp_md.cond.BR.label1.data_pointer     = 'h.det1.m2q_l';
exp_md.cond.BR.label1.value            = [34]';
exp_md.cond.BR.label1.translate_condition = 'OR';

exp_md.cond.BR.label2					= exp_md.cond.BR.label1;
exp_md.cond.BR.label2.value           = [18]';

exp_md.cond.BR.C2				= macro.filter.write_coincidence_condition(2, 'det1');


%% Condition: Select only proton:
exp_md.cond.H.l = exp_md.cond.def.label;
exp_md.cond.H.l.type	= 'discrete';
exp_md.cond.H.l.value	= [1];
exp_md.cond.H.l.translate_condition	= 'AND';
% 
% exp_md.cond.H.dpY.data_pointer	= 'h.det1.Y';
% exp_md.cond.H.dpY.type	= 'continuous';
% exp_md.cond.H.dpY.value	= [-12; 12];
% exp_md.cond.H.dpY.translate_condition = 'AND';

exp_md.cond.H.dp_norm.data_pointer	= 'h.det1.dp_norm';
exp_md.cond.H.dp_norm.type			= 'continuous';
exp_md.cond.H.dp_norm.value			= [13; 100];
exp_md.cond.H.dp_norm.translate_condition = 'AND';


%% Conditions: Momentum angle correlations (double coincidence):
% Select labels:
exp_md.cond.angle_p_corr_C2.label1			= exp_md.cond.def.label;
exp_md.cond.angle_p_corr_C2.label1.type		= 'discrete';
exp_md.cond.angle_p_corr_C2.label1.value		= 12;
% exp_md.cond.angle_p_corr_C2.label1.value		= 13;
exp_md.cond.angle_p_corr_C2.label1.translate_condition = 'hit1';

exp_md.cond.angle_p_corr_C2.label2			= exp_md.cond.angle_p_corr_C2.label1;
exp_md.cond.angle_p_corr_C2.label2.value		= 16;
exp_md.cond.angle_p_corr_C2.label2.translate_condition = 'hit2';

% Hits:
% Filter the 'oil peaks' out:
exp_md.cond.angle_p_corr_C2.oil                   = exp_md.cond.def.oil;

% Filter out only double coincidence:
exp_md.cond.angle_p_corr_C2.C2				= macro.filter.write_coincidence_condition(2, 'det1');

% Filter the total KER, such that noise goes out:
exp_md.cond.angle_p_corr_C2.KER_sum            = exp_md.cond.def.KER_sum;
exp_md.cond.angle_p_corr_C2.KER_sum.value		= [0.1; 80]; 
%  
% Get rid of large momenta:
exp_md.cond.angle_p_corr_C2.dp_sum              = exp_md.cond.def.dp_sum;
exp_md.cond.angle_p_corr_C2.dp_sum.value		= [0; 41];

                                               
%% Plot Styles are defined in this file.
% Specify which plot to show:
% exp_md.plot.det1.ifdo.BR_Ci						= true;
% exp_md.plot.det1.ifdo.TOF							= true;
exp_md.plot.det1.ifdo.m2q							= true;
% exp_md.plot.det1.ifdo.TOF_X						= true;
% exp_md.plot.det1.ifdo.XY						= true;
% exp_md.plot.det1.ifdo.theta_R					= true;
% exp_md.plot.det1.ifdo.TOF_hit1_hit2				= true;
% exp_md.plot.det1.ifdo.m2q_hit1_hit2				= true;
% exp_md.plot.det1.ifdo.m2q_hit2_hit3				= true;
% exp_md.plot.det1.ifdo.dp						= true;
% exp_md.plot.det1.ifdo.dp_xR						= true;
% exp_md.plot.det1.ifdo.dp_normphi					= true;
% exp_md.plot.det1.ifdo.dp_norm						= true;
% exp_md.plot.det1.ifdo.dp_sum_norm				= true;
% exp_md.plot.det1.ifdo.angle_p_corr_C2			= true;
% exp_md.plot.det1.ifdo.angle_p_corr_C2_KER_sum	= true;
% exp_md.plot.det1.ifdo.angle_p_corr_C2_dp_sum_norm = true;
exp_md.plot.det1.ifdo.KER						= true;
% exp_md.plot.det1.ifdo.KER_sum					= true;
% exp_md.plot.det1.ifdo.m2q_l_sum_KER_sum			= true;
% exp_md.plot.det1.ifdo.m2q_sum_CSD				= true;

% load the signal plotting metadata:
exp_md = my_md.Laksman_TOF.plot_signals(exp_md);
signals = exp_md.plot.signal;

%% %%%%%%%%%%%%%%%%%%%%%%% PLOTTYPE DEFAULTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
exp_md.plot.det1.BR_Ci						= metadata.create.plot.signal_2_plot({signals.mult});
exp_md.plot.det1.BR_Ci.GraphObj.Type			= 'bar';
exp_md.plot.det1.BR_Ci.hist.Integrated_value		= 1;

exp_md.plot.det1.TOF							= metadata.create.plot.signal_2_plot({signals.TOF});
% exp_md.plot.det1.TOF.hist.Integrated_value	= 1;
exp_md.plot.det1.TOF.hist.binsize				= 4;
exp_md.plot.det1.TOF.hist.Maximum_value		= 1;
exp_md.plot.det1.TOF.GraphObj.ax_nr			= 1;

% Axes properties:
exp_md.plot.det1.TOF.figure.Position			= plot.fig.Position('N');
exp_md.plot.det1.TOF.axes(1).YTick			= linspace(0, 1e3, 11);
exp_md.plot.det1.TOF.axes(1).YLim				= [0 exp_md.plot.det1.TOF.hist.Maximum_value];
exp_md.plot.det1.TOF.axes						= macro.plot.add_axes(exp_md.plot.det1.TOF.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q', 'X');
% exp_md.plot.det1.TOF.cond			= exp_md.cond.H;

exp_md.plot.det1.TOF_hit1_hit2				= metadata.create.plot.signal_2_plot({signals.TOF, signals.TOF});
exp_md.plot.det1.TOF_hit1_hit2.hist.hitselect = [1, 2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
exp_md.plot.det1.TOF_hit1_hit2.hist.binsize	= 2*exp_md.plot.det1.TOF_hit1_hit2.hist.binsize;
exp_md.plot.det1.TOF_hit1_hit2.axes.axis		= 'equal';
exp_md.plot.det1.TOF_hit1_hit2.axes			= macro.plot.add_axes(exp_md.plot.det1.TOF_hit1_hit2.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q');
% Condition metadata:

exp_md.plot.det1.m2q							= metadata.create.plot.signal_2_plot({signals.m2q});
exp_md.plot.det1.m2q.hist.Integrated_value	= 1;
exp_md.plot.det1.m2q.GraphObj.ax_nr			= 1;
% Axes properties:
exp_md.plot.det1.m2q.axes(1).YTick			= linspace(0, 1, 101);
exp_md.plot.det1.m2q.axes(1).YLim				= [0 0.1];
exp_md.plot.det1.m2q.axes						= macro.plot.add_axes(exp_md.plot.det1.m2q.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q', 'X');

exp_md.plot.det1.m2q_hit1_hit2				= metadata.create.plot.signal_2_plot({signals.m2q, signals.m2q});
exp_md.plot.det1.m2q_hit1_hit2.hist.hitselect = [1, 2]; %hitselect can be used to select only the first, second, etc hit of a hit variable.
exp_md.plot.det1.m2q_hit1_hit2.hist.binsize	= [0.1 0.1];
% exp_md.plot.det1.m2q_hit1_hit2.hist.saturation_limits = [0 5e-4]; % relative intensities. Everything above or below these limits will be set equal to the limit value.
exp_md.plot.det1.m2q_hit1_hit2.axes.axis		= 'equal';
% exp_md.plot.det1.m2q_hit1_hit2.hist.binsize = [17 17];

exp_md.plot.det1.m2q_hit1_hit2.GraphObj.Type = 'imagesc';
exp_md.plot.det1.m2q_hit1_hit2.GraphObj.SizeData = 150;
exp_md.plot.det1.m2q_hit1_hit2.GraphObj.Marker = 'o';
exp_md.plot.det1.m2q_hit1_hit2.GraphObj.MarkerEdgeColor = 'r';
exp_md.plot.det1.m2q_hit1_hit2.axes.XLim		= [0 5];
exp_md.plot.det1.m2q_hit1_hit2.axes.YLim		= [0 5];
exp_md.plot.det1.m2q_hit1_hit2.figure.Position = [1200 1000 600 350];

exp_md.plot.det1.m2q_hit2_hit3				= metadata.create.plot.signal_2_plot({signals.m2q, signals.m2q});
exp_md.plot.det1.m2q_hit2_hit3.hist.hitselect = [2, 3]; %hitselect can be used to select only the first, second, etc hit of a hit
exp_md.plot.det1.m2q_hit2_hit3.axes.axis		= 'equal';
exp_md.plot.det1.m2q_hit2_hit3.hist.binsize = [17 17];
exp_md.plot.det1.m2q_hit2_hit3.GraphObj.Type = 'scatter';
exp_md.plot.det1.m2q_hit2_hit3.GraphObj.SizeData = 150;
exp_md.plot.det1.m2q_hit2_hit3.GraphObj.Marker = 'o';
exp_md.plot.det1.m2q_hit2_hit3.GraphObj.MarkerEdgeColor = 'r';

exp_md.plot.det1.TOF_X						= metadata.create.plot.signal_2_plot({signals.TOF, signals.X});
exp_md.plot.det1.TOF_X.figure.Position		= plot.fig.Position('SE');
exp_md.plot.det1.TOF_X.axes					= macro.plot.add_axes(exp_md.plot.det1.TOF_X.axes(1), signals.add_m2q.axes, exp_md.conv.det1, 'm2q','X');
exp_md.plot.det1.TOF_X.hist.binsize(1)		= 0.1;

exp_md.plot.det1.XY							= metadata.create.plot.signal_2_plot({signals.X, signals.Y});
exp_md.plot.det1.XY.figure.Position			= plot.fig.Position('full');
exp_md.plot.det1.XY.axes.axis					= 'equal';
% exp_md.plot.det1.XY.cond						= exp_md.cond.H;

exp_md.plot.det1.theta_R						= metadata.create.plot.signal_2_plot({signals.Theta, signals.R});
exp_md.plot.det1.theta_R.figure.Position		= plot.fig.Position('SE');
exp_md.plot.det1.theta_R.axes.YLim			= [20 45];
% exp_md.plot.det1.theta_R.cond					= exp_md.cond.H;

exp_md.plot.det1.dp							= metadata.create.plot.signal_2_plot(signals.dp);
exp_md.plot.det1.dp.cond						= exp_md.cond.H;

exp_md.plot.det1.dp_xR						= metadata.create.plot.signal_2_plot({signals.dp_R, signals.dp_z});
exp_md.plot.det1.dp_xR.axes.axis				= 'equal';
exp_md.plot.det1.dp_xR.axes.colormap		= plot.custom_RGB_colormap('w', 'b');
exp_md.plot.det1.dp_xR.cond					= exp_md.cond.H;
exp_md.plot.det1.dp_xR.figure.Position		= [1500 1000 440 460];
% exp_md.plot.det1.dp_xR.axes.Position		= [0.2 0.2 0.3 0.6];
% exp_md.plot.det1.dp_xR.axes.YTickLabel		= [];
% exp_md.plot.det1.dp_xR.axes.YLabel.String		= [];
exp_md.plot.det1.dp_xR.axes.XDir = 'reverse';

exp_md.plot.det1.dp_norm						= metadata.create.plot.signal_2_plot(signals.dp_norm);
% exp_md.plot.det1.dp_norm.cond					= exp_md.cond.H;
exp_md.plot.det1.dp_norm.figure.Position		= [1500 1000 440 460];

exp_md.plot.det1.dp_normphi					= metadata.create.plot.signal_2_plot({signals.dp_phi signals.dp_norm});
% exp_md.plot.det1.dp_normphi.cond				= exp_md.cond.H;
exp_md.plot.det1.dp_normphi.figure.Position	= [1230  410 500 460];
exp_md.plot.det1.dp_normphi.axes.colormap		= plot.custom_RGB_colormap('w', 'r');
exp_md.plot.det1.dp_normphi.axes.Position		= [0.2 0.2 0.6 0.6];

exp_md.plot.det1.dp_sum_norm					= metadata.create.plot.signal_2_plot(signals.dp_sum_norm);
% exp_md.plot.det1.dp_sum_norm.cond				= exp_md.cond.NH_H;

exp_md.plot.det1.angle_p_corr_C2.axes.Type	= 'polaraxes';
exp_md.plot.det1.angle_p_corr_C2				= metadata.create.plot.signal_2_plot(signals.angle_p_corr_C2, exp_md.plot.det1.angle_p_corr_C2);
exp_md.plot.det1.angle_p_corr_C2.hist.Maximum_value = 1;

exp_md.plot.det1.KER							= metadata.create.plot.signal_2_plot({signals.KER});
exp_md.plot.det1.KER.hist.Integrated_value	= 1;

exp_md.plot.det1.KER_sum							= metadata.create.plot.signal_2_plot({signals.KER_sum});
exp_md.plot.det1.KER_sum.hist.Integrated_value	= 1;

exp_md.plot.det1.KER_sum.axes.YTick				= [];

exp_md.plot.det1.angle_p_corr_C2_KER_sum.axes.Type	= 'polaraxes';
exp_md.plot.det1.angle_p_corr_C2_KER_sum				= metadata.create.plot.signal_2_plot({signals.angle_p_corr_C2, signals.KER_sum}, exp_md.plot.det1.angle_p_corr_C2_KER_sum);
exp_md.plot.det1.angle_p_corr_C2_KER_sum.GraphObj.Type = 'surfcn';

exp_md.plot.det1.angle_p_corr_C2_dp_sum_norm.axes.Type	= 'polaraxes';
exp_md.plot.det1.angle_p_corr_C2_dp_sum_norm				= metadata.create.plot.signal_2_plot({signals.angle_p_corr_C2, signals.dp_sum_norm}, exp_md.plot.det1.angle_p_corr_C2_dp_sum_norm);
exp_md.plot.det1.angle_p_corr_C2_dp_sum_norm.GraphObj.Type = 'surfcn';

exp_md.plot.det1.m2q_l_sum_KER_sum				= metadata.create.plot.signal_2_plot({signals.m2q_l_sum, signals.KER_sum});
exp_md.plot.det1.m2q_l_sum_KER_sum.GraphObj.Type	= 'Y_mean';
% exp_md.plot.det1.m2q_l_sum_KER_sum.GraphObj.Type	= 'imagesc';
exp_md.plot.det1.m2q_l_sum_KER_sum.hist.binsize(1) = 1;
% Axes properties:
exp_md.plot.det1.m2q_l_sum_KER_sum.axes.XTick	= 2*exp_md.sample.fragment.masses; % [a.m.u.] Tick of the axis that shows the m2q variable. 
exp_md.plot.det1.m2q_l_sum_KER_sum.axes.Position			= [0.2 0.25 0.6 0.55];
exp_md.plot.det1.m2q_l_sum_KER_sum.figure.Position		= [1390         569         531         405];
exp_md.plot.det1.m2q_l_sum_KER_sum.axes.XTickLabel = exp_md.plot.det1.m2q_l_sum_KER_sum.axes.XTick; % [a.m.u.] Tick of the axis that shows the m2q variable. 
exp_md.plot.det1.m2q_l_sum_KER_sum.axes(2)		= general.struct.catstruct(exp_md.plot.det1.m2q_l_sum_KER_sum.axes(1), signals.add_cluster_size.axes);
conv.eps_m = 1; conv.mult = 2; conv.charge = 1;
exp_md.plot.det1.m2q_l_sum_KER_sum.axes = macro.plot.add_axes(exp_md.plot.det1.m2q_l_sum_KER_sum.axes(1), signals.add_CSD.axes, conv, 'CSD', 'Y');
exp_md.plot.det1.m2q_l_sum_KER_sum.axes(2).XTickLabel = 2:2:22;


%% Calibration parameters:
% Preparation: We define the signals:
%%%%%% TOF:
signals.TOF.hist.pointer	= 'h.det1.TOF';% Data pointer, where the signal can be found. 
% Histogram metadata:
signals.TOF.hist.binsize	= 2;% [ns] binsize of the variable. 
signals.TOF.hist.Range		= [0 1e4];% [ns] range of the variable. 

% Axes metadata:
signals.TOF.axes.Lim		= signals.TOF.hist.Range;% [ns] Lim of the axis that shows the variable. 
signals.TOF.axes.Tick		= 0:1e3:1e5;% [ns] Tick of the axis that shows the variable.
signals.TOF.axes.Label.String	= 'TOF [ns]'; %The label of the variable

%%%%%% Mass-to-charge:
% Histogram metadata:
signals.m2q.hist.binsize	= 0.1;% [Da] binsize of the variable. 
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
exp_md.calib.det1.TOF_2_m2q.name							= 'ion';
exp_md.calib.det1.TOF_2_m2q.TOF							= metadata.create.plot.signal_2_plot({signals.TOF});
exp_md.calib.det1.TOF_2_m2q.TOF.hist.Integrated_value	= 1;
exp_md.calib.det1.TOF_2_m2q.m2q							= metadata.create.plot.signal_2_plot({signals.m2q});
exp_md.calib.det1.TOF_2_m2q.findpeak.search_radius		= 10;% [ns] The search radius around the indicated point, where the algorithm will look for a peak.
exp_md.calib.det1.TOF_2_m2q.findpeak.binsize				= 0.05;% [ns] The search radius around the indicated point, where the algorithm will look for a peak.
% 
exp_md.calib.det1.momentum.hist.binsize       = [1, 1]*5e0; %[a.u.] binsize of the m2q variable. 
exp_md.calib.det1.momentum.hist.Range			= [-1 1]*3e2; % [a.u.] x range of the data on x-axis.
exp_md.calib.det1.momentum.hist.pointer		= 'h.det1.raw';

% Plot style for 2D momentum histogram:
exp_md.calib.det1.momentum.labels_to_show = 1;%exp_md.sample.fragment.masses;%(3:end);%general.fragment_masses(exp_md.sample.constituent.masses, exp_md.sample.constituent.nof); 
exp_md.calib.det1.momentum.binsize       	= [1, 1]*2e0; %[a.u.] binsize of the m2q variable. 
exp_md.calib.det1.momentum.x_range		= [-1 1]*5e1; % [a.u.] x range of the data on x-axis.
exp_md.calib.det1.momentum.y_range		= [-1 1]*5e1; % [a.u.] y range of the data on y-axis.

exp_md.calib.signal_shuffle.detnr				= [1];
exp_md.calib.signal_shuffle.shuffle.method		= 'rand'; % shuffling method. Possibilities: 'rand' or 'rotation'
exp_md.calib.signal_shuffle.shuffle.shift		= 1; % rotation shift in the case 'rotation' method is chosen.
exp_md.calib.signal_shuffle.cond					= exp_md.cond.angle_p_corr_C2; % The condition to test how many events are approved.
