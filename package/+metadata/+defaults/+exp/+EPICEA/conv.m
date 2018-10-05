function [ exp_md ] = conv ( exp_md )
% This convenience funciton lists the default conversion metadata, and can be
% read by other experiment-specific metadata files.

% DETECTOR 1 DETECTOR 1 DETECTOR 1 DETECTOR 1 DETECTOR 1 DETECTOR 1 DETECTOR 1
exp_md.conv.det1.ifdo.R_theta				= true;% Does the user want to convert to R-theta coordinates?


% DETECTOR 2 DETECTOR 2 DETECTOR 2 DETECTOR 2 DETECTOR 2 DETECTOR 2 DETECTOR 2

% Which conversions should be performed on the data:
exp_md.conv.det2.ifdo.m2q		= true;% Does the user want to convert to mass-over-charge?
exp_md.conv.det2.ifdo.m2q_label		= true; % Does the user want to convert to mass-2-charge labels?
exp_md.conv.det2.ifdo.m2q_group_label		= false; % Does the user want to convert to mass-2-charge groups?
exp_md.conv.det2.ifdo.m2q_Ci_label	= false; % Does the user want to convert to mass-2-charge groups?
exp_md.conv.det2.ifdo.momentum 		= true;% Does the user want to convert to momentum?
exp_md.conv.det2.ifdo.KER 		= true;% Does the user want to convert to Kinetic energy?
exp_md.conv.det2.ifdo.R_theta				= true;% Does the user want to convert to R-theta coordinates?
exp_md.conv.det2.ifdo.angle_p_corr_C2	= true;% Does the user want to calculate mutual momentum angles of double coindicence?
exp_md.conv.det2.ifdo.angle_p_corr_C3	= false;% Does the user want to calculate mutual momentum angles of triple coincidence?
exp_md.conv.det2.ifdo.q_label		= false;% Does the user want to convert to R-theta coordinates?
exp_md.conv.det2.ifdo.bgr		= true;% Does the user want to convert multi-coincidence signal to background coordinates?

% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1
% Time Of Flight to Mass to Charge values

exp_md.conv.det2.m2q.factor      	=   890.3;%Conversion factor from mass 2 charge to TOF
exp_md.conv.det2.m2q.factor      	=   891;

exp_md.conv.det2.m2q.t0          		= 140.1702;%16.3755; %15.0021; % [ns] time correction
exp_md.conv.det2.m2q.t0          		= 94.9547;%16.3755; %15.0021; % [ns] time correction

exp_md.conv.det2.m2q_label.labels 			= [1 12 15 27 31 44 50 69 142]'; % the

exp_md.conv.det2.m2q_label.mass 			= exp_md.conv.det2.m2q_label.labels ; % the corresponding expected mass values in this experiment. If all expected particles are singly charged, this array is similar to exp_md.conv.det2.m2q_label.labels.

exp_md.conv.det2.m2q_label.search_radius		= 2; % search radius (in m/q units), or searchwidth around the main expectation value (m2q_label.labels).
exp_md.conv.det2.m2q_group_label.search_radius = 0.5 + exp_md.conv.det2.m2q_label.labels*2/10;

exp_md.conv.det2.m2q_Ci_label.method 		= 'line';
exp_md.conv.det2.m2q_Ci_label.search_radius = 0.6;
exp_md.conv.det2.m2q_Ci_label.length  		= 1;
exp_md.conv.det2.m2q_Ci_label.C_nr 			= [2];

exp_md.conv.det2.bgr.signal_name			= {'TOF'};

end
