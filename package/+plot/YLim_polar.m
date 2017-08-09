function [ output_args ] = YLim_polar( YLim )
% Sets the Y Limits of a polar plot through a trick, because MATLAB does
% not handle this well by default.

if length(YLim) == 1
    YLim = [0 YLim];
end
theta = zeros(size(YLim));
%plot a dummy line:
line = polar(theta, YLim, 'w'); hold on; 
% make it invisible:
line.Visible = 'off'
% also invisible for the legend:
set(get(get(line,'Annotation'),'LegendInformation'), 'IconDisplayStyle','off');
end

