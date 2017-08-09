function [ containers, Count, hLine] = hist(ax, data, md, name, value)
%Convenience function for the easy plotting of a histogram, be it 1-, 2-, 3-
%Dimensional or polar histograms.
%
% If no histogram metadata is given, default values are assumed of 100 bins
% and the data range the same as the minimum and maximum of the given data.
%
% Additionally, a name value pair can be given, that allows changing a
% histogram value without changing it in the metadata.
%
% Inputs:
% ax        axis handle.
% data      [n, hist_dim], array of data to be plotted in histogram. n_dims
%           represents the histogram dimension, hist_dim <= 3.
% md(optional)  struct, containing the metadata: fieldnames: binsize, x_range (1,2,3 D), 
%           y_range (1,2,3 D), z_range (2,3 D), contourvalue (3D).
% name (optional) The name of the value to quick-change. Possibilities:
%           'binsize', 'x_range', y_range', 'contourvalue'
% value (optional) The value belonging to the above 'name'
TODO