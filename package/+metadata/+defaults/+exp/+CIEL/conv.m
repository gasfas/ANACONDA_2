function [ exp_md ] = conv ( exp_md )
% This convenience funciton lists the default conversion metadata, and can be
% read by other experiment-specific metadata files.

%% Conversion factors:
% Detector 1: Electron detector, Detector 1: Electron detector, Detector 1:
exp_md.conv.det1.ifdo.momentum					= true;% Does the user want to convert to momentum?
exp_md.conv.det1.ifdo.m2q                 = true;
exp_md.conv.det1.ifdo.m2q_label					= true;
exp_md.conv.det1.ifdo.KER                       = true;
exp_md.conv.det1.ifdo.R_theta					= true;
exp_md.conv.det1.ifdo.PolarPxPz                 = true;
exp_md.conv.det1.ifdo.PolarPyPz                 = true;
exp_md.conv.det1.ifdo.PolarPxPyPz               = true;
exp_md.conv.det1.ifdo.KERoverAngle              = false;

% Time Of Flight to Mass to Charge values
exp_md.conv.det1.m2q_label.labels 			= [0.00055]; % the available m2q labels.

% Time Of Flight to Mass to Charge calibration
exp_md.conv.det1.m2q.factor      	= 2515.8;%Conversion factor from mass 2 charge to TOF
exp_md.conv.det1.m2q.t0          	= sqrt(2 * 9.1e-31* exp_md.spec.dist.d 	/(1.6e-19*exp_md.spec.Efield))*((2* exp_md.spec.dist.d  + exp_md.spec.dist.l)/(2* exp_md.spec.dist.d ));%[ns] dead time correction

exp_md.conv.det1.m2q_label.mass 			= exp_md.conv.det1.m2q_label.labels ; % the corresponding expected mass values in this experiment. If all expected particles are singly charged, this array is similar to exp_md.conv.det2.m2q_label.labels. 
exp_md.conv.det1.m2q_label.search_radius= 0.001; % search radius (in either m/q or nsec units, depending on the labelling_signal indicated), or searchwidth around the main expectation value (no-Kinetic energy point).

% Ion detector, Detector 2: Ion detector, Detector 2: Ion detector, Detector 2:
% Which conversions should be performed on the data:

exp_md.conv.det2.ifdo.m2q					= true;% Does the user want to convert to mass-over-charge?
exp_md.conv.det2.ifdo.m2q_label					= true; % Does the user want to convert to mass-2-charge labels?
exp_md.conv.det2.ifdo.m2q_group_label			= false; % Does the user want to convert to mass-2-charge groups?
exp_md.conv.det2.ifdo.m2q_Ci_label				= false; % Does the user want to convert to mass-2-charge labels?
exp_md.conv.det2.ifdo.cluster_size				= false;% Does the user want to convert to cluster size?
exp_md.conv.det2.ifdo.momentum					= true;% Does the user want to convert to momentum?
exp_md.conv.det2.ifdo.KER 						= true;% Does the user want to convert to Kinetic energy?
exp_md.conv.det2.ifdo.R_theta					= false;% Does the user want to convert to R-theta coordinates?
exp_md.conv.det2.ifdo.angle_p_corr_C2			= false;% Does the user want to calculate mutual momentum angles of double coindicence?
exp_md.conv.det2.ifdo.angle_p_corr_C3			= false;% Does the user want to calculate mutual momentum angles of triple coincidence?
exp_md.conv.det2.ifdo.q_label					= false;% Does the user want to convert to have q-labels defined?
exp_md.conv.det2.ifdo.CSD						= false;% Does the user want to convert to CSD?
exp_md.conv.det2.ifdo.PolarPyPz                 = false;
% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1

% Time Of Flight to Mass to Charge calibration
exp_md.conv.det2.m2q.factor      	= 1300;%Conversion factor from mass 2 charge to TOF
exp_md.conv.det2.m2q.t0          	=  0;%[ns] dead time correction%formula: see Mathieus paper

% Time Of Flight to Mass to Charge values
exp_md.conv.det2.m2q_label.labels 			= [exp_md.sample.fragment.masses]; % the available m2q labels.
exp_md.conv.det2.m2q_label.mass 			= exp_md.conv.det2.m2q_label.labels ; % the corresponding expected mass values in this experiment. If all expected particles are singly charged, this array is similar to exp_md.conv.det2.m2q_label.labels.
exp_md.conv.det2.m2q_label.signal 		= 'm2q';% The signal around which the m2q label serach radii are defined. 
exp_md.conv.det2.m2q_label.search_radius= 15; % search radius (in either m/q or nsec units, depending on the labelling_signal indicated), or searchwidth around the main expectation value (no-Kinetic energy point).

% mass-2-charge group labels
% A mass-2-charge group is  a set of particles close in mass, collected in one 'group'
exp_md.conv.det2.m2q_group_labels.min = min(exp_md.sample.fragment.masses, [], 2);
exp_md.conv.det2.m2q_group_labels.max = max(exp_md.sample.fragment.masses, [], 2);
%exp_md.conv.det2.m2q_group_labels.name = exp_md.sample.fragment.sizes;
exp_md.conv.det2.m2q_group_labels.search_radius = 0.5 + mean([exp_md.conv.det2.m2q_group_labels.max, exp_md.conv.det2.m2q_group_labels.min], 2)*2/10;

exp_md.conv.det2.m2q_Ci_label.method = 'circle';
exp_md.conv.det2.m2q_Ci_label.search_radius = 0.75;

exp_md.conv.det2.CSD.include_C1_as_C2 	= false; % This option can include the single coincidence (C1) as a double coincidence event (C2), assuming that all KER went to the detected particle.
end