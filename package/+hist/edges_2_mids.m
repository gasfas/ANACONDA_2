function [mids] = edges_2_mids(edges)
% This function takes in edges, and converts them to midpoints:
% input:
% edges			[N,1]; edges of the histogram
% Output:
% mids			[N-1,1] midpoints in between the given edges.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

mids = edges(1:end-1) + diff(edges)./2;
end