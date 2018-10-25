function [ fragment_masses, nof_occurences ] = fragment_masses(constituent_weights, constituent_max_occurence_numbers, constituent_min_occurence_numbers, combination_freedom)
% function [ output_args ] = fragment_masses_2(constituent_weights, constituent_max_occurence_numbers, constituent_min_occurence_numbers, combination_freedom)
%Function to calculate the masses of mixed clusters in all their possible
%mixtures.
% Input:
% constituent_weights:      [n, 1] array with the masses of constituents of the
%                           parent particle. [a.m.u.]
% occurence_max_numbers     [n, 1]; the maximum amount of times the constituent
%                           occurs in the sample
% occurence_max_numbers     [n, 1]; (Optional) the minimum amount of times the constituent
%                           occurs in the sample. If not given 0 is assumed
% combination_freedom       String (Optional), the way the algorithm can combine the number of occurences.
%                           'all' means that all combinations from min to
%                           max are possible
%                           'paired' only the paired combinations given are
%                           possible: 
%                           cluster_min_occurences(1,1) and cluster_min_occurences(1,2)
%                           cluster_min_occurences(2,1) and cluster_min_occurences(2,2)
%                           TO BE IMPLEMENTED
%                           if no input given, 'all' is assumed.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% overhead:
if ~exist('constituent_min_occurence_numbers', 'var')
    % if the minimum is not defined, it is set to zero:
    constituent_min_occurence_numbers = zeros(size(constituent_max_occurence_numbers));
end
if ~exist('combination_freedom', 'var')
    % if the combinations allowed are not specified, all combinations are
    % assumed allowed.
    combination_freedom = 'all';
end

if size(constituent_weights,2) > 1
    constituent_weights = constituent_weights';
end
if size(constituent_max_occurence_numbers,2) > 1
    constituent_max_occurence_numbers =constituent_max_occurence_numbers';
end
if size(constituent_min_occurence_numbers,2) > 1
    constituent_min_occurence_numbers =constituent_min_occurence_numbers';
end

if length(constituent_max_occurence_numbers) ~= length(constituent_weights)
    % If there is a different number of maxima then the number of
    % constituent weights, they are all set equal to the first given value:
    constituent_max_occurence_numbers = constituent_max_occurence_numbers(1,1) * ones(size(constituent_weights));
    constituent_min_occurence_numbers = constituent_min_occurence_numbers(1,1) * ones(size(constituent_weights));
end

%%

if strcmpi(combination_freedom, 'all')
	% preparing the separate mass vector arrays:
	for i = 1:size(constituent_weights, 1)
		nofs{i} = (constituent_min_occurence_numbers(i):1:constituent_max_occurence_numbers(i));
		masses{i} = constituent_weights(i) * nofs{i};
	end
	% calculating all possible combinations:
	fragment_masses = sum(general.matrix.combvec_vardim(masses),1)';
	nof_occurences	= general.matrix.combvec_vardim(nofs)';
elseif strcmpi(combination_freedom, 'paired')
    error('TODO'); 
end
end

