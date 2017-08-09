function [mids] = edges_2_mids(edges)
% This function takes in edges, and converts them to midpoints:
% input:
% edges			[N,1]; edges of the histogram
% Output:
% mids			[N-1,1] midpoints in between the given edges.

mids = edges(1:end-1) + diff(edges)./2;
end