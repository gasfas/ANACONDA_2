function [hLine] = bar(axhandle, midpoints, count, GraphObj_md)
% Function used to plot a 1D histogram
% Input:
% h_axes		The axes handle
% midpoints:   array with linearly increasing values, around which the bins
%               are calculated
% count:		The number of counts that fell into the corresponding
%               container.
% Output:		
% hLine			The output handle (Graphical Object). 
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

hLine = bar(axhandle, midpoints, count);

end