function [ exp_md ] = conv ( exp_md )
% This convenience funciton lists the default conversion metadata, and can be
% read by other experiment-specific metadata files.

%% Conversion factors:
% Detector 1: Electron detector, Detector 1: Electron detector, Detector 1:
exp_md.conv.det1.ifdo.m2q                       = true;
exp_md.conv.det1.ifdo.m2q_label                 = true;
exp_md.conv.det1.ifdo.momentum					= true;% Does the user want to convert to momentum?

exp_md.conv.det1.momentum.TOF_nominal           = 1; % [ns] 
exp_md.conv.det1.ifdo.KER 						= false;% Does the user want to convert to Kinetic energy?
exp_md.conv.det1.m2q_label.search_radius        = 0.4;

exp_md.conv.det1.mass_labels                    = [1]; % [amu]
exp_md.conv.det1.m2q_labels                     = exp_md.conv.det1.mass_labels;
% Time Of Flight to Mass to Charge calibration
exp_md.conv.det1.TOF_2_m2q.factor      	= 114;%Conversion factor from mass 2 charge to TOF
exp_md.conv.det1.TOF_2_m2q.t0          	= 10;%[ns] dead time correction


% Ion detector, Detector 2: Ion detector, Detector 2: Ion detector, Detector 2:
% Which conversions should be performed on the data:

exp_md.conv.det2.ifdo.m2q						= false;% Does the user want to convert to mass-over-charge?
exp_md.conv.det2.ifdo.m2q_label					= false; % Does the user want to convert to mass-2-charge labels?
exp_md.conv.det2.ifdo.m2q_group					= false; % Does the user want to convert to mass-2-charge groups?
exp_md.conv.det2.ifdo.m2q_label_Ci				= false; % Does the user want to convert to mass-2-charge labels?
exp_md.conv.det2.ifdo.cluster_size				= false;% Does the user want to convert to cluster size?
exp_md.conv.det2.ifdo.momentum					= false;% Does the user want to convert to momentum?
exp_md.conv.det2.ifdo.KER 						= false;% Does the user want to convert to Kinetic energy?
exp_md.conv.det2.ifdo.R_theta					= false;% Does the user want to convert to R-theta coordinates?
exp_md.conv.det2.ifdo.angle_p_corr_C2			= false;% Does the user want to calculate mutual momentum angles of double coindicence?
exp_md.conv.det2.ifdo.angle_p_corr_C3			= false;% Does the user want to calculate mutual momentum angles of triple coincidence?
exp_md.conv.det2.ifdo.q_label					= false;% Does the user want to convert to have q-labels defined?
exp_md.conv.det2.ifdo.CSD						= false;% Does the user want to convert to CSD?
% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1

% Time Of Flight to Mass to Charge values
exp_md.conv.det2.m2q_labels 			= [exp_md.sample.fragment.masses]; % the available m2q labels.

% Time Of Flight to Mass to Charge calibration
exp_md.conv.det2.TOF_2_m2q.factor      	= 1800;%Conversion factor from mass 2 charge to TOF
exp_md.conv.det2.TOF_2_m2q.t0          	= 20.5;%[ns] dead time correction

exp_md.conv.det2.mass_labels 			= exp_md.conv.det2.m2q_labels ; % the corresponding expected mass values in this experiment. If all expected particles are singly charged, this array is similar to exp_md.conv.det2.m2q_labels.
exp_md.conv.det2.m2q_label.signal 		= 'm2q';% The signal around which the m2q label serach radii are defined. 
exp_md.conv.det2.m2q_label.search_radius = 0.5; % search radius (in either m/q or nsec units, depending on the labelling_signal indicated), or searchwidth around the main expectation value (no-Kinetic energy point).


exp_md.conv.det2.m2q_label_Ci.method = 'circle';
exp_md.conv.det2.m2q_label_Ci.search_radius = 0.75;

exp_md.conv.det2.CSD.include_C1_as_C2 	= false; % This option can include the single coincidence (C1) as a double coincidence event (C2), assuming that all KER went to the detected particle.
end