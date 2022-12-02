function [ exp_md ] = corr ( exp_md )
% This convenience funciton lists the default correction metadata, and can be
% read by other experiment-specific metadata files.

%% Correction parameters:

% Detector 2 %% Detector 2 %% Detector 2 %% Detector 2 %% Detector 2 %% Detector 2 %% Detector 2 %% Detector 2 % (ION DETECTOR)

% Which corrections should be performed on the data:
exp_md.corr.det2.ifdo.dXdY 		    = true;% Does this data need detector image translation correction?
exp_md.corr.det2.ifdo.dTheta 		= true;%; % Does this data need detector image rotation correction?
exp_md.corr.det2.ifdo.dTOF  		= true;% Does this data need detector absolute TOF correction?
exp_md.corr.det2.ifdo.detectorabb	= false;% Does this data need detector-induced abberation correction?
exp_md.corr.det2.ifdo.lensabb 		= false;% Does this data need lens abberation correction?

% The detector image translation parameters:
exp_md.corr.det2.dX					= 4.5;   %[mm] distance the center of detection is displaced left of the origin of the raw image; 
exp_md.corr.det2.dY					= 0;   %[mm] distance the center of detection is displaced up the origin of the raw image;
% The detector image rotation parameters:
exp_md.corr.det2.dTheta				= 0;   %[deg] rotation of hits around the raw image centre (anticlockwise);
% The TOF deadtime correction parameter:
exp_md.corr.det2.dTOF 			 	=  0;% [ns] The difference between signal propagation times of trigger and hits.

% The detector abberation parameters:
exp_md.corr.det2.detectorabb.TOF_noKE.p_i	= [0.000023532412340   0.000085163157150  -0.001114418744338  -0.012416517247903                   0]; % The polynomial fit parameters for the TOF correction, making all zero-kinetic energy TOF's equal to the one without abberation.
exp_md.corr.det2.detectorabb.TOF_R.p_i		= [-0.001876121338436  -0.006322279070694                   0                   0];% The polynomial fit parameters for the radial TOF correction
exp_md.corr.det2.detectorabb.dR.p_i			= [0.278118318372887                   0];% The polynomial fit parameters for the radial correction

% The lens abberation parameters:
exp_md.corr.det2.lensabb.TOF_noKE.p_i 	= [.001131257122551   0.003476707189483   0.010406721559879 	0];%  % The polynomial fit parameters for the TOF correction, making all zero-kinetic energy TOF's equal to the one without abberation.
exp_md.corr.det2.lensabb.dR.p_i 			= [3.591547226568072   2.711873874269235   1.222350376192316   0.994428857836460];

% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 % (ELECTRON DETECTOR)
% Which corrections should be performed on the data:
exp_md.corr.det1.ifdo.dXdY 			= true;
% exp_md.corr.det1.ifdo.dY            = true; % Does this data need detector image translation correction?
exp_md.corr.det1.ifdo.dTheta 		= true;%; % Does this data need detector image rotation correction?
exp_md.corr.det1.ifdo.dTOF  		= true;% Does this data need detector absolute TOF correction?
exp_md.corr.det1.ifdo.ionization_position = false;

% The detector image translation parameters:
exp_md.corr.det1.dX					= 0.9;   %[mm] distance the center of detection is displaced left of the origin of the raw image; 
exp_md.corr.det1.dY					= 0.19;   %[mm] distance the center of detection is displaced up the origin of the raw image;
% The detector image rotation parameters:
exp_md.corr.det1.dTheta				= 40;   %[deg] rotation of hits around the raw image centre (anticlockwise);
% The TOF deadtime correction parameter:
exp_md.corr.det1.dTOF 			 	= 2.33;% [ns] The difference between signal propagation times of trigger and hits.

exp_md.corr.det1.ionization_position.source.detnr = 2;
exp_md.corr.det1.ionization_position.subject.detnr = 2;
exp_md.corr.det1.ionization_position.X_fraction   = 0.3;
exp_md.corr.det1.ionization_position.Y_fraction   = 0.5;
end

