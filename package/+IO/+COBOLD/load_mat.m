function [ exp ] = load_mat(event_path, electrons_path, ions_path)
%This function loads custom COBOLD PC ASCII files (that are already
%converted to MAT files) and converts them to the ANA2 format.

% read the event ID datafile:
events	= load(event_path); % read the events
el		= load(electrons_path);	% read the electron datafile
ion		= load(ions_path);	% read the ion datafile

% Initialize an empty event pointer array:
exp.e.raw = [events.d.Var4+1 events.d.Var3+1];

% Fill in electron data: (format [x, y, TOF])
exp.h.det1.raw = [el.d.Var1 el.d.Var2 el.d.Var3];

% Fill in ion data: (format [x, y, TOF])
exp.h.det2.raw = [ion.d.Var1 ion.d.Var2 ion.d.Var3];
end