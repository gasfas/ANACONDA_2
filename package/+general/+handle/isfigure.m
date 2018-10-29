function [isfig] = isfigure(fig)
% This convenience function checks whether an input variable is a figure
% handle:

if ~isnumeric(fig)
	try
		isfig = strcmp(get(fig, 'type'), 'figure');
	catch
		isfig = false;
	end
else
	isfig = false;
end

end
