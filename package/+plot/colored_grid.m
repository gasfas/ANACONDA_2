function [ ax ] = colored_grid(color, XTick, YTick )
%This function creates a colored grid, shamelessly missing in the MATLAB
%plotting options
% Inputs: 
% color		the preferred color of the grid
% XTick		The X Tick values at which the gridlines should lie
% YTick		The Y Tick values at which the gridlines should lie
% Outputs:
% ax		struct of axes handles of the vertical and horizontal lines.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if ~exist('XTick', 'var')
    XTick = get(gca, 'XTick');
end
if ~exist('YTick', 'var')
    YTick = get(gca, 'YTick');
end

ax.vlines = plot.vline(XTick, color);
ax.hlines = plot.hline(YTick, color);

end

