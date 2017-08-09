function [ exp_md ] = sample ( exp_md )
% This convenience funciton lists the default sample metadata, and can be
% read by other experiment-specific metadata files.

exp_md.sample.name						= 'NH$_3$	'; % [a.m.u.] mass of constituents of sample
exp_md.sample.type						= 'Cluster'; %sample type, can be 'Molecule' or 'Cluster'.
exp_md.sample.T							= 273-11.3; %[K] The temperature of the nozzle.
exp_md.sample.constituent.masses		= [17]; % [a.m.u.] mass of constituents of sample
exp_md.sample.constituent.names 		= {'NH$_3$'}; % [] names of constituents of sample
exp_md.sample.monomer.fragment.masses 	= [14 1]; % [a.m.u.] mass of fragments of sample
exp_md.sample.monomer.fragment.names 	= {'N' 'H'}; % [] names of fragments
exp_md.sample.monomer.fragment.nof 		= [1 3]; % [] number of fragment masses a single fragment can be composed of.
exp_md.sample.monomer.mass 				= 	sum(exp_md.sample.monomer.fragment.masses.*exp_md.sample.monomer.fragment.nof);% [a.m.u] mass of sample
exp_md.sample.fragment.protonation= 1;%[-] Protonation of fragments; 1 means 1 proton attached. 
exp_md.sample.fragment.sizes 			= (1:20)'; % size is defined as the number of monomer units.
exp_md.sample.fragment.pure.masses 		= exp_md.sample.fragment.sizes * exp_md.sample.constituent.masses + exp_md.sample.fragment.protonation*1; % The masses of the pure fragments.
exp_md.sample.fragment.masses 			= macro.convert.cluster_fragment_masses(exp_md.sample);

exp_md.sample.oven.T 			= exp_md.sample.T; %[K] The temperature of the oven.

exp_md.sample.m_avg	 			= mean(exp_md.sample.constituent.masses); % [a.m.u.] The average mass of the incoming sample.
exp_md.sample.v_direction 						= [3 0 0]; % [] direction of the sample supply in X, Y, Z direction.
exp_md.sample.Mach_number 				= 1; % The factor of the local speed of sound and actual speed.
exp_md.sample.permittivity 					= 22; % [] The dielectric constant/permittivity of the sample.
end