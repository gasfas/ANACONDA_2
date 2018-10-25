function [Count_w, x_midpoints, y_midpoints] = H_2D(x_data, y_data, weight, x_midpoints, y_midpoints)
% Weighted 2D histogram
% function H = H_2D(X,W,y,z,C)
%
% Inputs: 
% x_data		[n,1] data along x-coordinate
% y_data		[n,1] data along y-coordinate
% weight		[n,1] weights of each {x,y}-combination
% x_midpoints	[m,1] vector of m bin centers along 1st dim of X
% y_midpoints	[l,1] vector of l bin centers along 2nd dim of X
% Output: 
% Count			[m, l] histogram matrix
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% divide the x_data and y_data in 'locations':
[Count, edges, mid, loc]= hist.histcn([x_data y_data], x_midpoints, y_midpoints);
x_midpoints = cell2mat(mid(1));
y_midpoints = cell2mat(mid(2));
Count_w				= zeros(size(Count)); 
% clear Count;

% Remove the rows that are outside one of the ranges (Region Of Interest):
to_remove			= any(loc==0, 2);
loc_ROI 				= loc(~to_remove,:);
weight_ROI			= weight(~to_remove);	
% Sort the locations and weights, so that they can be summed:
[locsorted, loc_idx]= sortrows(loc_ROI); % Sort the locations
weight_sorted		= weight_ROI(loc_idx);% Sort the weights
% Calculate the cumulative sum:
CS_weights			= cumsum(weight_sorted, 1);
% Define indeces where the last weight of a location can be found:
is_lastloc			= [any(diff(locsorted, 1), 2); true];
% Add up all the weight contributions that go to one location:
loc_fill_X = locsorted(is_lastloc,1);
loc_fill_Y = locsorted(is_lastloc,2);
fill_value = diff([0; CS_weights(is_lastloc)]);
Count_w(sub2ind(size(Count_w), loc_fill_X, loc_fill_Y)) = fill_value;

end