function [ exp_md ] = spec ( exp_md )
% This convenience funciton lists the default spectrometer metadata, and can be
% read by other experiment-specific metadata files.

exp_md.spec.name = 'EPICEA';

% Voltages
exp_md.spec.volt.Ve2s			= 112.1; %[V] Voltage of grid separating electron side and source region,'pusher'
exp_md.spec.volt.Vs2a			= 87.2; %[V] Voltage of grid separating source and acceleration region;
exp_md.spec.volt.Va2d			= 00; %[V] Voltage of grid separating acceleration region and drift tube;

% Distances:
exp_md.spec.dist.s0 			= 0.001;% [m] source to ion acceleration region grid 
exp_md.spec.dist.s 				= 0.002;% [m] electron to ion grid. 
exp_md.spec.dist.D 				= 0.02;% [m] length of drift tube

% detection modes:
exp_md.spec.det_modes = {'ion'}; % The detection mode for detector 1, 2, etc.

exp_md.spec.volt.V_created 		= exp_md.spec.volt.Ve2s + exp_md.spec.dist.s0/exp_md.spec.dist.s * (exp_md.spec.volt.Vs2a - exp_md.spec.volt.Ve2s); % [V]The voltage at light interaction point

end
