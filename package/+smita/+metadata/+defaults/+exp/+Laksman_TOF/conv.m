function [ exp_md ] = conv ( exp_md )
% This convenience funciton lists the default conversion metadata, and can be
% read by other experiment-specific metadata files.

%% Conversion factors:
% Which conversions should be performed on the data:

exp_md.conv.det1.ifdo.m2q						= true;% Does the user want to convert to mass-over-charge?
exp_md.conv.det1.ifdo.m2q_label					= true; % Does the user want to convert to mass-2-charge labels?
exp_md.conv.det1.ifdo.m2q_group_label			= false; % Does the user want to convert to mass-2-charge groups?
exp_md.conv.det1.ifdo.cluster_size				= true;% Does the user want to convert to cluster size?
exp_md.conv.det1.ifdo.momentum					= true;% Does the user want to convert to momentum?
exp_md.conv.det1.ifdo.KER 						= true;% Does the user want to convert to Kinetic energy?
exp_md.conv.det1.ifdo.R_theta					= true;% Does the user want to convert to R-theta coordinates?
exp_md.conv.det1.ifdo.angle_p_corr_C2			= true;% Does the user want to calculate mutual momentum angles of double coindicence?
exp_md.conv.det1.ifdo.angle_p_corr_C3			= true;% Does the user want to calculate mutual momentum angles of triple coincidence?
exp_md.conv.det1.ifdo.q_label					= false;% Does the user want to convert to have q-labels defined?
exp_md.conv.det1.ifdo.CSD						= false;% Does the user want to convert to CSD?
% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1

% Time Of Flight to Mass to Charge calibration
exp_md.conv.det1.m2q.factor      	= 962.3;%Conversion factor from mass 2 charge to TOF
exp_md.conv.det1.m2q.t0          	= 20.5;%[ns] dead time correction

% Time Of Flight to Mass to Charge labels
exp_md.conv.det1.m2q_label.labels 		= [exp_md.sample.fragment.masses]; % the available m2q labels.
exp_md.conv.det1.m2q_label.masses		= exp_md.conv.det1.m2q_label.labels ; % the corresponding expected mass values in this experiment. If all expected particles are singly charged, this array is similar to exp_md.conv.det1.m2q_label.labels.
exp_md.conv.det1.m2q_label.signal 		= 'm2q';% The signal around which the m2q label serach radii are defined. 
exp_md.conv.det1.m2q_label.search_radius= 0.5; % search radius (in either m/q or nsec units, depending on the labelling_signal indicated), or searchwidth around the main expectation value (no-Kinetic energy point).
exp_md.conv.det1.m2q_label.C_nr 		= [1 2]; % The coincidence numbers the user wants to convert (1 converts all, [1, 2] converts all, and overwrites double coincidence)
exp_md.conv.det1.m2q_label.method	= 'circle';
exp_md.conv.det1.m2q_label.length	= 0.75;

% mass-2-charge group labels
% A mass-2-charge group is  a set of particles close in mass, collected in one 'group'
exp_md.conv.det1.m2q_group_label.min = min(exp_md.sample.fragment.pure.masses, [], 2);
exp_md.conv.det1.m2q_group_label.max = max(exp_md.sample.fragment.pure.masses, [], 2);
exp_md.conv.det1.m2q_group_label.name = exp_md.sample.fragment.sizes;
exp_md.conv.det1.m2q_group_label.search_radius = 0.5;


exp_md.conv.det1.CSD.include_C1_as_C2 	= false; % This option can include the single coincidence (C1) as a double coincidence event (C2), assuming that all KER went to the detected particle.
end