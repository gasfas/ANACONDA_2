function [ hLine ] = invisible_in_legend( hLine )
%This function makes a line invisible for the legend.
set(get(get(hLine,'Annotation'),'LegendInformation'), 'IconDisplayStyle','off')
end

