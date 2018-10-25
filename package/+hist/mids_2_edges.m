function [edges] = mids_2_edges(mids)
% This function takes in midpoints, and converts them to edges, as part of 
% a preparation for the production of a histogram:
% input:
% mids			[N-1,1] midpoints in between the given edges.
% Output:
% edges			[N,1]; edges of the histogram
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

dmids_half = diff(mids)/2;

edges = [mids(1)+dmids_half(1); mids(1:end-1)+dmids_half; mids(end)+dmids_half(end)];
end