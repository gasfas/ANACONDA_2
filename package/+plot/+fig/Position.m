function [Pos] = Position(pos_code)
% This convenience function automizes the screen position, by fetching the
% monitor's size and allowing placement in different corners;
% Inputs:
% pos_code	(optional)There are two posible ways of denoting the position of the figure.
%			The first option is a string. Posibilities are: 
%				'se' or 'SouthEast' to place the figure in the bottom right.
%				'full' : Fullscreen figure (default value)
%			The second option are relative numbers: [x_start, y_end, width, height]
% Outputs:
% Pos		the position in pixels.
if ~exist('pos_code', 'var')
	pos_code = 'F';
end

% fetch the screensize of the monitor:
set(groot, 'Units', 'pixels');
screensize = get( groot, 'Screensize' );

if isnumeric(pos_code) && length(pos_code) == 4
	Pos = pos_code./screensize([3 4 3 4]);
elseif ischar(pos_code)
	if		any(strcmpi(pos_code, {'NW', 'NorthWest'}))
		Pos = [screensize(1)  screensize(4)/2 screensize(3)/2 screensize(4)/2];
	elseif	any(strcmpi(pos_code, {'NE', 'NorthEast'}))
		Pos = [screensize(3)/2  screensize(4)/2 screensize(3)/2 screensize(4)/2];
	elseif	any(strcmpi(pos_code, {'SE', 'SouthEast'}))
		Pos = [screensize(3)/2  screensize(2)/2 screensize(3)/2 screensize(4)/2];
	elseif	any(strcmpi(pos_code, {'SW', 'SouthWest'}))
		Pos = [screensize(1)  screensize(2) screensize(3)/2 screensize(4)/2];
	elseif	any(strcmpi(pos_code, {'S', 'South'}))
		Pos = [screensize(1)  screensize(2) screensize(3) screensize(4)/2];
	elseif	any(strcmpi(pos_code, {'N', 'North'}))
		Pos = [screensize(1)  screensize(4)/2 screensize(3) screensize(4)/2];
	elseif	any(strcmpi(pos_code, {'W', 'West'}))
		Pos = [screensize(1)  screensize(2) screensize(3)/2 screensize(4)];
	elseif	any(strcmpi(pos_code, {'E', 'East'}))
		Pos = [screensize(3)/2  screensize(2) screensize(3)/2 screensize(4)];
	else
		Pos = screensize;
	end
end