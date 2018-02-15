function [ exp_md ] = spec ( exp_md )
% This convenience funciton lists the default spectrometer metadata, and can be
% read by other experiment-specific metadata files.

exp_md.spec.name = 'CIEL';

% Voltages
exp_md.spec.volt.Ve2s			= 300; %[V] Voltage of grid separating electron side and source region,'pusher'
exp_md.spec.volt.Vs2a			= 0;     %[V] Voltage of grid separating source and acceleration region;  for NH3:0
exp_md.spec.volt.Va2d			= -200; %[V] Voltage of grid separating acceleration region and drift tube;  for NH3: -3994
exp_md.spec.volt.ion_lens1		= -2526; %-3270 [V] Voltage of ion lens (Laksman ion Drift tube)   for NH3: -3251

% Distances:
exp_md.spec.dist.s0 		= 0.007;% [m] source to ion acceleration region grid 
exp_md.spec.dist.s 			= 0.030;% [m] electron to ion grid. 
exp_md.spec.dist.d 			= 0.094;% [m] length of accelation region
exp_md.spec.dist.D 			= 0.650;% [m] length of drift tube

% detection modes:
exp_md.spec.det_modes = {'electron', 'ion'}; % The detection mode for detector 1, 2, etc.
% Magnetic field applied:
exp_md.spec.is_B_field			= false; % Is there a magnetic field applied in this spectrometer?
exp_md.spec.B_field			= 0.001; %[T]

exp_md.spec.volt.V_created 		= exp_md.spec.volt.Ve2s + exp_md.spec.dist.s0/exp_md.spec.dist.s * (exp_md.spec.volt.Vs2a - exp_md.spec.volt.Ve2s); % [V]The voltage at light interaction point

end
