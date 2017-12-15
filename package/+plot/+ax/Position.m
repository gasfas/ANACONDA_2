function [Pos] = Position(pos_code)
% This convenience function automizes the position of an axes.
% Inputs:
% pos_code	(optional). Posibilities are: 
%				'se' or 'SouthEast' to place the figure in the bottom
%				right. etc...
%				'full' : Fullscreen figure (default value)
% Outputs:
% Pos		the Position in relative numbers.
if ~exist('pos_code', 'var')
	pos_code = 'F';
end

% fetch the screensize of the monitor:
screensize = get( groot, 'Screensize' );

if isnumeric(pos_code) && length(pos_code) == 4
	Pos = pos_code./screensize([3 4 3 4]);
elseif ischar(pos_code)
	if		any(strcmpi(pos_code, {'NW', 'NorthWest'}))
		Pos = [0.2000 0.5896 0.2980 0.2930];
	elseif	any(strcmpi(pos_code, {'NE', 'NorthEast'}))
		Pos = [0.5920 0.5896 0.2980 0.2930];
	elseif	any(strcmpi(pos_code, {'SE', 'SouthEast'}))
		Pos = [0.5920 0.1826 0.2980 0.2930];
	elseif	any(strcmpi(pos_code, {'SW', 'SouthWest'}))
		Pos = [0.2000 0.1826 0.2980 0.2930];
	elseif	any(strcmpi(pos_code, {'S', 'South'}))
		Pos = [0.2000 0.1826 0.6900 0.2930];
	elseif	any(strcmpi(pos_code, {'N', 'North'}))
		Pos = [0.2000 0.5896 0.6900 0.2930];
	elseif	any(strcmpi(pos_code, {'W', 'West'}))
		Pos = [0.2000 0.1826 0.2980 0.7000];
	elseif	any(strcmpi(pos_code, {'E', 'East'}))
		Pos = [0.5920 0.1826 0.2980 0.7000];
	elseif	any(strcmpi(pos_code, {'NWW', 'NorthWestWest'}))
		Pos = [0.2000    0.5896    0.1900    0.2930];
	elseif	any(strcmpi(pos_code, {'NC', 'NorthCenter'}))
		Pos = [0.4500    0.5896    0.1900    0.2930];
	elseif	any(strcmpi(pos_code, {'NEE', 'NorthEastEast'}))
		Pos = [0.7000    0.5896    0.1900    0.2930];
	elseif	any(strcmpi(pos_code, {'SWW', 'SouthWestWest'}))
		Pos = [0.2000    0.1826    0.1900    0.2930];
	elseif	any(strcmpi(pos_code, {'SC', 'SouthCenter'}))
		Pos = [0.4500    0.1826    0.1900    0.2930];
	elseif	any(strcmpi(pos_code, {'SEE', 'SouthEastEast'}))
		Pos = [0.7000    0.1826    0.1900    0.2930];
	elseif	any(strcmpi(pos_code, {'Full'}))
		Pos = [0.2 0.2 0.6 0.6];
	end
end