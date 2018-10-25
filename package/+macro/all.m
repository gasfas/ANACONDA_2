function [data, md] = all(data, md, procedure_spec)
%This function runs all macros for an experiment.
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

for j = 1:length(procedure_spec)
	data				= macro.(procedure_spec{j})(data, md);
end

end

