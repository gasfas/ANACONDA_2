function [ output_args ] = colored_minor_grid(color, XTick, YTick )
%This function creates a colored minor grid, shamelessly missing in the MATLAB
%plotting options
% Inputs: 
% color		the preferred color of the grid
% XTick		The X Tick values at which the gridlines should lie
% YTick		The Y Tick values at which the gridlines should lie
% Outputs:
% -
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if ~exist('XTick', 'var')
    XTick = get(gca, 'XTick');
end
if ~exist('YTick', 'var')
    YTick = get(gca, 'YTick');
end

plot.vline(XTick, color)
plot.hline(YTick, color)

XTick_minor = linspace(min(XTick), max(XTick), (length(XTick)-1)*5+1);
YTick_minor = linspace(min(YTick), max(YTick), (length(YTick)-1)*5+1);

plot.colored_grid([color '-.'], XTick_minor, YTick_minor)

end

