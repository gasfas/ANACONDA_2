function [ds, exp_names] = all_n(ds, mds, procedure_spec)
%This function runs all macros for a set of experiments, stored in 'ds',
%with the corresponding metadata in 'mds'
% Inputs:
% ds	struct with different experiment data as fields
% mds	struct with different experiment metadata as fields
% procedure_spec (optional) cell with strings that specify which procedure to execute.
%	Default: procedure_spec = {'correct', 'convert', 'filter', 'fit'}
% Output:
% ds	struct with different experiment data as fields, now after the 
%		procedures have been applied.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if ~exist('procedure_spec', 'var')
	procedure_spec = {'correct', 'convert', 'filter'};
end

try 
	exp_names		= ds.info.foi;
	numexps			= ds.info.numexps;
catch
	exp_names		= fieldnames(ds);
	numexps			= length(exp_names);
end

for i = 1:numexps
	exp_name			= exp_names{i};
	disp(['Treating experiment: ' exp_name])
	if ~strcmp(exp_name, 'info')
		ds.(exp_name)		= macro.all(ds.(exp_name), mds.(exp_name), procedure_spec);
	end
end

end

