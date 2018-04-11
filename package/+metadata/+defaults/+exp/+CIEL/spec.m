function [ exp_md ] = spec ( exp_md )
% This convenience funciton lists the default spectrometer metadata, and can be
% read by other experiment-specific metadata files.

exp_md.spec.name = 'CIEL';
% If do in this case means that the parameters are used for calibration,
% this is a quick short term idea and probably not a good one, but it is to
% facilitate the GUI for now, things can be improved
exp_md.spec.ifdo.Bfield = true;


% Voltages
exp_md.spec.volt.Ve2s			= 300; %[V] Voltage of grid separating electron side and source region,'pusher'
exp_md.spec.volt.Vs2a			= 0;     %[V] Voltage of grid separating source and acceleration region; 
exp_md.spec.volt.Va2d			= -3000; %[V] Voltage of grid separating acceleration region and drift tube;  
exp_md.spec.volt.ion_lens1		= -2526; %-3270 [V] Voltage of ion lens (CIEL ion Drift tube)   

% Distances:
exp_md.spec.dist.s0 		= 0.007;% [m] source to ion acceleration region grid 
exp_md.spec.dist.s 			= 0.030;% [m] electron to ion grid. 
exp_md.spec.dist.d 			= 0.094;% [m] length of accelation region
exp_md.spec.dist.D 			= 0.650;% [m] length of drift tube

% detection modes:
exp_md.spec.det_modes = {'electron', 'ion'}; % The detection mode for detector 1, 2, etc.
% Magnetic field applied:

exp_md.spec.Bfield              = 0.00055; % [T]

exp_md.spec.Efield              = 450; % [V]The voltage at light interaction point

end
