function [hLine] = line(h_axes, midpoints, count, GraphObj_md)
% Function used to plot a 1D histogram
% Input:
% h_axes		The axes handle
% midpoints:   array with linearly increasing values, around which the bins
%               are calculated
% count:		The number of counts that fell into the corresponding
%               container.
% Output:		
% hLine			The output handle (Graphical Object). 

if strcmpi(h_axes.Type, 'polaraxes') % Axes has to be a polarplot axes.
	hLine = polarplot (h_axes, midpoints, count);
else
	warning('polarplot could not be made: given axes is not polaraxes (only available from MATLAB 2016)')
end

end

