function [ hLine ] = invisible_in_legend( hLine )
%This function makes a line invisible for the legend.
% Inputs:
% hLine		The handle of the line
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

set(get(get(hLine,'Annotation'),'LegendInformation'), 'IconDisplayStyle','off')
end

