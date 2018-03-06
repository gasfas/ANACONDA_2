function [ exp_md ] = sample ( exp_md )
% This convenience funciton lists the default sample metadata, and can be
% read by other experiment-specific metadata files.

exp_md.sample.name						= 'name'; % [a.m.u.] mass of constituents of sample
exp_md.sample.type						= 'Molecule'; %sample type, can be 'Molecule' or 'Cluster'.
exp_md.sample.T							= 273-11.3; %[K] The temperature of the nozzle.
exp_md.sample.constituent.masses		= [4]; % [a.m.u.] mass of constituents of sample
exp_md.sample.constituent.names 		= {'He'}; % [] names of constituents of sample
exp_md.sample.fragment.masses 	= [4]; % [a.m.u.] mass of fragments of sample
exp_md.sample.fragment.names 	= {'He'}; % [] names of fragments
exp_md.sample.fragment.nof 		= [1]; % [] number of fragment masses a single fragment can be composed of.
exp_md.sample.mass 				= 	sum(exp_md.sample.fragment.masses.*exp_md.sample.fragment.nof);% [a.m.u] mass of sample
exp_md.sample.e_mass            = [0.0005485799]; % [a.m.u.] rest mass of electron
exp_md.sample.oven.T 			= exp_md.sample.T; %[K] The temperature of the oven.

exp_md.sample.m_avg	 			= mean(exp_md.sample.constituent.masses); % [a.m.u.] The average mass of the incoming sample.
exp_md.sample.v_direction 						= [0 1 0]; % [] direction of the sample supply in X, Y, Z direction.
exp_md.sample.v_MB				= 1000; % [m/s] average speed of the molecular beam
exp_md.sample.permittivity 					= 22; % [] The dielectric constant/permittivity of the sample.
end