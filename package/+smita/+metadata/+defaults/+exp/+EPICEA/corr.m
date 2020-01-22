function [ exp_md ] = corr ( exp_md )
% This convenience funciton lists the default correction metadata, and can be
% read by other experiment-specific metadata files.
%% Correction parameters:

% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %
% Which corrections should be performed on the data:
exp_md.corr.det1.ifdo.dXdY 			= true;% Does this data need detector image translation correction?
exp_md.corr.det1.ifdo.dTheta 		= true;%; % Does this data need detector image rotation correction?
exp_md.corr.det1.ifdo.R_circle		= true;%; % Does this data need detector radial non-circularity correction?
exp_md.corr.det1.ifdo.detectorabb = false;% Does this data need detector-induced abberation correction?
exp_md.corr.det1.ifdo.dE			= true;%; % Does this data need Energy correction?
exp_md.corr.det1.ifdo.lensabb 		= false;% Does this data need lens abberation correction?

% The detector image translation parameters:
exp_md.corr.det1.dX					= 0.0;   %[mm] distance the center of detection is displaced left of the origin of the raw image; 
exp_md.corr.det1.dY					= 0.0;   %[mm] distance the center of detection is displaced up the origin of the raw image;
exp_md.corr.det1.dE					= 0.0;   %[mm] distance the center of detection is displaced up the origin of the raw image;
% The detector image rotation parameters:
exp_md.corr.det1.dTheta				= 0;   %[deg] rotation of hits around the raw image centre (anticlockwise);
% The detector image non-roundness parameters:
exp_md.corr.det1.R_circle			= load(fullfile(fileparts(mfilename('fullpath')), 'R_circle_param.mat'));  % scaling factor [] and the corresponding angle [rad].
% The TOF deadtime correction parameter:
exp_md.corr.det1.dTOF 			 	=  0;% [ns] The difference between signal propagation times of trigger and hits.

% Detector 2 %% Detector 2 %% Detector 2 %% Detector 2 %% Detector 2 %% Detector 2 %% Detector 2 %% Detector 2 %
% Which corrections should be performed on the data:
exp_md.corr.det2.ifdo.dXdY 			= true;% Does this data need detector image translation correction?
exp_md.corr.det2.ifdo.dTheta 		= true;%; % Does this data need detector image rotation correction?
exp_md.corr.det2.ifdo.dTOF  			= true;% Does this data need detector absolute TOF correction?
exp_md.corr.det2.ifdo.detectorabb = false;% Does this data need detector-induced abberation correction?
exp_md.corr.det2.ifdo.lensabb 		= false;% Does this data need lens abberation correction?

% The detector image translation parameters:
exp_md.corr.det2.dX					= 0.0;   %[mm] distance the center of detection is displaced left of the origin of the raw image; 
exp_md.corr.det2.dY					= 0.0;   %[mm] distance the center of detection is displaced up the origin of the raw image;
% The detector image rotation parameters:
exp_md.corr.det2.dTheta				= 0;   %[deg] rotation of hits around the raw image centre (anticlockwise);
% The TOF deadtime correction parameter:
exp_md.corr.det2.dTOF 			 	=  0;% [ns] The difference between signal propagation times of trigger and hits.
end

