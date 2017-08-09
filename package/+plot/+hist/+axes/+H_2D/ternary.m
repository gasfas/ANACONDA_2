% function [ C, containers, hParent ] = H_ternary(axhandle, C1, C2, C3, binsize, metadata)
function [ h_GraphObj ] = ternary(h_axes, midpoints, Count, GraphObj_md)
% Polar histogram plot, that takes the sin(theta) solid angle into account
% by varying the binsize.
% Input:
% axhandle:     The handle that the figure will be plotted into
% C1:           [n, 1], the coordinates along first axis
% C2:           [n, 1], the coordinates along second axis
% C3:           [n, 1], the coordinates along third axis
% binsizes      [2,1] The binsizes along the first and second axis.
% x_range       The maximum and minimum to include in the histogram
% linestyle     The linestyle to be plotted into.
% The total (C1 + C2 + C3) is normalized to one for every datapoint.

%% Plot ternary surface
[h_GraphObj] = plot.hist.axes.H_2D.imagesc(h_axes, midpoints, Count, GraphObj_md);
uistack(h_GraphObj, 'bottom')
end