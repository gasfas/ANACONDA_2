function [ legendhandle ] = legendtitle( legendhandle, textstring )
%Add title text on top of the legend
% Inputs: 
% legendhandle	The handle of the existing legend
% textstring	The string that will be placed as a title above the legend
% Outputs:
% legendhandle	The handle of the existing legend, now with title
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

hlt = text(...
    'Parent', legendhandle.DecorationContainer, ...
    'String', textstring, ...
    'HorizontalAlignment', 'Center', ...
    'VerticalAlignment', 'bottom', ...
    'Position', [0.5, 1.05, 0], ...
    'Units', 'normalized');
legendhandle.Interpreter = 'Latex';
legend boxoff;
end

