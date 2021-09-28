function [  ] = ASCII_2_mat(electrons_path, ions_path, events_path)
%General function to convert EPICEA ASCII datafiles to ANACONDA 2
%datafiles. 
% Inputs:
% electrons_path	The location to find electron datafiles
% ions_path			The location to find ion datafiles
% Outputs:
% -
%
% Written by Smita Ganguly, 2021, Lund university: smita.ganguly(at)sljus.lu.se

%% read the electron datafile:
d_e = datastore(electrons_path);
% The electron file can be with or without header:
if cell2mat(strfind(d_e.VariableNames,'eventId_'))
	IO.EPICEA.ASCII_2_mat_one(electrons_path, {'eventId_', 'pos_x', 'pos_y', 'energy' });
else
	IO.EPICEA.ASCII_2_mat_one(electrons_path, {'Var1', 'Var6', 'Var7' , 'Var10'});
end

 
%% read the ion datafile:
d_e = datastore(ions_path);
% The ion file can be with or without header:
if cell2mat(strfind(d_e.VariableNames,'eventId_'))
	IO.EPICEA.ASCII_2_mat_one(ions_path, {'eventId_', 'pos_x', 'pos_y' ,  'tof_fallingEdge_'});
else
	IO.EPICEA.ASCII_2_mat_one(ions_path, {'Var1', 'Var9', 'Var10' , 'Var2'});
end
%% read the events datafile
% read the electron datafile:
d_e = datastore(events_path);
% The electron file can be with or without header:
if cell2mat(strfind(d_e.VariableNames,'eventId_'))
	IO.EPICEA.ASCII_2_mat_one(events_path, {'eventId_', 'num_E_', 'num_I_', 'num_RandomHits' });
else
	IO.EPICEA.ASCII_2_mat_one(events_path, {'Var1', 'Var2','Var4', 'Var6'});
end

end

