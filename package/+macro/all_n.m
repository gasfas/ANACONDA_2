function [ds, exp_names] = all_n(ds, mds, procedure_spec)
%This function runs all macros for a set of experiments, stored in 'ds',
%with the corresponding metadata in 'mds'
% Inputs:
% ds	struct with different experiment data as fields
% mds	struct with different experiment metadata as fields
% procedure_spec (optional) cell with strings that specify which procedure to execute.
%	Default: procedure_spec = {'correct', 'convert', 'filter'}
% Output:
% ds	struct with different experiment data as fields, now after the 
%		procedures have been applied.

if ~exist('procedure_spec', 'var')
	procedure_spec = {'correct', 'convert', 'filter'};
end

exp_names		 = ds.info.foi;


for i = 1:ds.info.numexps
    exp_name			= exp_names{i};
	data(i)				= ds.(exp_name);
	md{i}				= mds.(exp_name);
end

for i = 1:ds.info.numexps
	data(i) = macro.all(data(i), md{i}, procedure_spec);
end

for i = 1:ds.info.numexps
    exp_name			= exp_names{i};
	ds.(exp_name)		= data(i); 
end

end

