function [uislider_low, uislider_high] = double_uislider(hParent, Min, Max, LowValue, HighValue, ....
    Position, MinorTickSpacing, StateChangedCallback)
% This function creates two single-runner uisliders that together form an
% improvised rangeslider. from MATLAB R2023b, the rangeslider is available,
% but as of now we have no license for that version.
Position_High   = Position;
Position_High(2) = Position_High(2) + 10; % Place the second bar a bit higher, so the runner remains accessible.

uislider_low    = uislider(hParent, "Limits",[Min, Max],"Value",LowValue, 'MinorTicks', Min:MinorTickSpacing:Max, ...
    'ValueChangedFcn', StateChangedCallback, 'Position', Position, 'MajorTickLabels', {}, 'MinorTicks', [], 'MajorTicks', []);

uislider_high   = uislider(hParent, "Limits",[Min, Max],"Value",HighValue, 'MinorTicks', Min:MinorTickSpacing:Max, ...
    'ValueChangedFcn', StateChangedCallback, 'Position', Position_High, 'MajorTickLabels', {}, 'MinorTicks', [], 'MajorTicks', []);
end