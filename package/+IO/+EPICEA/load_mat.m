function [ exp ] =load_mat(event_path, electrons_path, ions_path)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% read the event ID datafile:
el		= load(electrons_path);	% read the electron datafile
ion		= load(ions_path);	% read the ion datafile

fn = fieldnames(ion.d);
% In case no header is given:
switch fn{1}
	case 'Var1'
		ion.d = general.struct.rename_structfield(ion.d, {'Var1', 'Var8', 'Var9' , 'Var2'}, {'eventId_', 'pos_x', 'pos_y' ,  'tof_fallingEdge_'});
end

% Initialize an empty event pointer array:
exp.e.raw = NaN*ones(max(ion.d.eventId_(end), el.d.eventId_(end)), 2);

% Find the unique values and their positions:
[e_C, e_IA] = unique(el.d.eventId_);		
% Fill these in into the event pointer array (electrons: first column):
exp.e.raw(e_C,1) = e_IA; % Electron detector: det1
% Find the unique values and their positions:
[i_C, i_IA] = unique(ion.d.eventId_);
% Fill these in into the event pointer array (ions: second column):
exp.e.raw(i_C,2) = i_IA;% Ion detector: det2

% Fill in electron data: (format [x, y, energy])
exp.h.det1.raw = [el.d.pos_x el.d.pos_y el.d.energy];

% Fill in ion data: (format [x, y, TOF])
exp.h.det2.raw = [ion.d.pos_x ion.d.pos_y ion.d.tof_fallingEdge_./1e3];
end