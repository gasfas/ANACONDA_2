function [isax] = isaxes(ax)
% This convenience function checks whether an input variable is an axes
% handle:

if ~isnumeric(ax)
	try
		isax = strcmp(get(ax, 'type'), 'axes');
	catch
		isax = false;
	end
else
	isax = false;
end
