function [histw, x_centres] = H_1D(hits, weight, x_edges)
% This function generates a vector of cumulative weights for data
% histogram. It creates a one-dimensional histogram of unstructured data.
% Inputs:
%	x_range:	[n, 1] column array with the values at which the 
%				user wants to see the counts.
%	weight:		[n, 1] column array with the weight for each given hit.
%	x_edges:	[m, 1] column array with the edges of the bins.
% Output: 
%   Count:		[m, 1] column array with the elements giving the number of points from
%				x_data within the specified x_edges.
%
% example:
% vv = [5	4 1.1 6 5 1 7]; % values
% ww = [7 1 1 12 8 5 0.1]; % weights
% x_edges = 0.5:1:9.5;
% [histw, centres] = hist.weighted.H_1D(vv', ww', x_edges')
% Example Visualise:
% bar(centres, histw)

% remove hits out of range:
f_rm = hits > max(x_edges) | hits < min(x_edges);
hits = hits(~f_rm); weight = weight(~f_rm);
% find bin centres
x_centres = x_edges(1:end-1) + diff(x_edges)/2;
% Add a few zero-weight hits, so that each bin gets a hit:
hits = [hits; x_centres]; weight = [weight; zeros(size(x_centres))];
	
% Sort the hits in terms of their values:
[hits_s, idx] = sort(hits);
weight_s = weight(idx);

% find the nearest bin centre of each hit:
hits_s_nearest_bin		= interp1(x_centres, x_centres, hits_s, 'nearest', 'extrap'); 
% unique(hits_s_centres) for the start index
[~, idx] = unique(hits_s_nearest_bin);
% Cumulative sum of weights:
CS_weight_s = cumsum(weight_s);
% calculate the histograms:
histw = diff([0; CS_weight_s(idx(2:end)-1); CS_weight_s(end)]);
end