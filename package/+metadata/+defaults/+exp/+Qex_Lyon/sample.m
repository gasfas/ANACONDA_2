function [ exp_md ] = sample ( exp_md )
% This convenience funciton lists the default sample metadata, and can be
% read by other experiment-specific metadata files.

exp_md.sample.name						= 'RWG2MG5'; % [a.m.u.] mass of constituents of sample
exp_md.sample.type						= 'Peptide'; %sample type, can be 'Molecule' or 'Cluster'.
exp_md.sample.T							= 273; %[K] The temperature of the sample.
exp_md.sample.fragment.masses 	= [83.6]; % [a.m.u.] mass of fragments of sample
exp_md.sample.fragment.names 	= {'He'}; % [] names of fragments
exp_md.sample.fragment.nof 		= [1]; % [] number of fragment masses a single fragment can be composed of.
exp_md.sample.mass 				= 	sum(exp_md.sample.fragment.masses.*exp_md.sample.fragment.nof);% [a.m.u] mass of sample
exp_md.sample.e_mass            = [0.0005485799]; % [a.m.u.] rest mass of electron
exp_md.sample.oven.T 			= exp_md.sample.T; %[K] The temperature of the oven.

end