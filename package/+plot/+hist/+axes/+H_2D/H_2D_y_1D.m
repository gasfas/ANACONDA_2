function [containers, Count, hLine] = H_2D_y_1D(axhandle, x_data, y_data, binsizes, x_lims, y_lims, scale)
%This function plots a two-dimensional histogram with a one-dimensional
%histogram on the side.
% Input:
% axhandle:    Cell containing the axis handles to plot the figure into. Has to contain two
%				fields, the first one (axhandle{1}) will contain the 2D histogram, the
%				second the y histogram (axhandle{2}).
% x-data:         the data to plot. Assumed to be a 1D array [n, 1]. 
%               if it is a 2D array [n, m], it will be formed into a 
%               1D array and plotted.
% y-data:         the data to plot. Assumed to be a 1D array [n, 1]. 
%               if it is a 2D array [n, m], it will be formed into a 
%               1D array and plotted. make sure numel(y_data) = numel(x_data)
% binsizes:     the width of one container in x and y [1,2].
% x_lims        the limits in x-direction [2,1]
% y_lims        the limits in y-direction [2,1]
% scale         optional: the scale type of the color, can be 'linear' or
%               'log'
% Output:
% containers:   array with linearly increasing values, around which the bins
%               are calculated
% histogram:    The number of counts that fell into the corresponding
%               container.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

%% Plot the 2D histogram in handle 1:
[containers, Count, hLine] = plot.hist.H_2D(axhandle{1}, x_data, y_data, binsizes, x_lims, y_lims, scale);

%% Plot the 1D histogram in handle 2:
plot.hist.H_1D_flipped(axhandle{2}, y_data, binsizes(2), y_lims, scale);
yticks(axhandle{2}, [])

% set(axhandle{2},'Xdir','Reverse')
end