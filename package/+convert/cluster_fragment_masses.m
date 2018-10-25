function [ fragment_masses ] = cluster_fragment_masses ( sample_md )
% This convenience function calculates the cluster fragment masses from the
% metadata given. 
% Input:
% sample_md     struct containing the sample metadata. Must contain the
%               fields:
%                   sample_md.constituent.masses    The masses of the
%                   constituents from which the cluster is built up.
%                   sample_md.fragment.sizes        The sizes of the
%                   fragments expected to be seen (size is defined as the
%                   number of monomer units)
%                   sample_md.fragment.protonation; [-] Protonation of
%                   fragments; 1 means 1 proton attached.
% Output:
% fragment_masses
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if general.struct.issubfield(sample_md, 'fragment.protonation')
	fragment_masses 			= general.fragment_masses(sample_md.constituent.masses, max(sample_md.fragment.sizes), ...
								min(sample_md.fragment.sizes)) + sample_md.fragment.protonation;
else
	fragment_masses 			= general.fragment_masses(sample_md.constituent.masses, max(sample_md.fragment.sizes), ...
								min(sample_md.fragment.sizes));
end
end

