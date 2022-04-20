function [ exp ] =load_mat_with_event_electron_only(event_path, electrons_path)
%This function load the temporal mat files that have been saved from the
%ASCII to MAT conversion. The function returns the experimental data in a 
% format that is ready for the ANACONDA_2 analysis.
% Inputs:
% event_path		The path (directory) where the events file can be found
% electrons_path	The path (directory) where the electrons file can be found
% ions_path			The path (directory) where the ions file can be found
% Outputs:
% exp				The data struct.
%
% electrons_path	The path (directory) where the electrons file can be found
%
% Written by Smita Ganguly, 2021, Lund university: smita.ganguly(at)sljus.lu.se


%% read the event ID datafile:
el		= load(electrons_path);	% read the electron datafile
events  = load(event_path);	% read the events datafile
%% assign proper field names
fn = fieldnames(el.d);
% In case no header is given:
switch fn{1}
	case 'Var1'
		el.d = general.struct.rename_structfield(el.d, {'Var1', 'Var6', 'Var7' , 'Var10'}, {'eventId_', 'pos_x', 'pos_y', 'energy'});
end

fn = fieldnames(events.d);
% In case no header is given:
switch fn{1}
	case 'Var1'
		events.d = general.struct.rename_structfield(events.d, {'Var1', 'Var2', 'Var6'}, {'eventId_', 'num_E_','num_RandomHits' });
end

%% define the number of events from events file
exp.e.e_trig   = logical(events.d.num_E_);
exp.e.rnd_trig = logical(events.d.num_RandomHits);

% Initialize an empty event pointer array:
% exp.e.raw = NaN*ones(max(ion.d.eventId_(end), el.d.eventId_(end)), 2);
exp.e.raw = NaN*ones(max(events.d.eventId_), 1);
% Find the unique electron values and their positions:
[e_C, e_IA] = unique(el.d.eventId_);		
% Fill these in into the event pointer array (electrons: first column):
exp.e.raw(e_C,1) = e_IA; % Electron detector: det1
% Fill trigger information Electron trigger or random trigger or no trigger
% exp.e.trig_e = 
% Fill in electron data: (format [x, y, energy])
exp.h.det1.raw = [el.d.pos_x el.d.pos_y el.d.energy];

end