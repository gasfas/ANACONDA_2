function [ exp_md ] = det ( exp_md )
% This convenience funciton lists the default detector metadata, and can be
% read by other experiment-specific metadata files.

% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %% Detector 1 %
exp_md.det.det1.name	 		= 'Roentdek DLD X,Y,T detector';
exp_md.det.det1.max_radius 		= 40 ; % [mm] Radius of the detector
exp_md.det.det1.signals			= {'X [mm]', 'Y [mm]', 'TOF [ns]'} ; %name of output signals of the detector.
exp_md.det.det1.Front_Voltage  	= -2100; %[V]  Detector front potential.
exp_md.det.det1.pol_direction	= [1 0 0]; %[-] The polarization direction in this detector.
exp_md.det.det1.Eff.Gilmore.m_0			= 0.38; % Detection efficiency for particles of mass 0 (calibration point).
exp_md.det.det1.Eff.Gilmore.Age_factor	= 1.5; % Correction of the detection efficiency curve from Gilmore, increases with MCP age.
end

