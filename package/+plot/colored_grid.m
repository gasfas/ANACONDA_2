function [ output_args ] = colored_grid(color, XTick, YTick )
%This function creates a colored grid, shamelessly missing in the MATLAB
%plotting options

if ~exist('XTick', 'var')
    XTick = get(gca, 'XTick');
end
if ~exist('YTick', 'var')
    YTick = get(gca, 'YTick');
end

plot.vline(XTick, color)
plot.hline(YTick, color)

end

