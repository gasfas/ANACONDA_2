function [  ] = ASCII_2_mat(electrons_path, ions_path)
%General function to convert EPICEA ASCII datafiles to ANACONDA 2
%datafiles.

% read the electron datafile:
 IO.EPICEA.ASCII_2_mat_one(electrons_path, {'eventId_', 'pos_x', 'pos_y', 'energy' });

% read the ion datafile:
d_e = datastore(ions_path);
% The ion file can be with or without header:
if cell2mat(strfind(d_e.VariableNames,'eventId_'))
	IO.EPICEA.ASCII_2_mat_one(ions_path, {'eventId_', 'pos_x', 'pos_y' ,  'tof_fallingEdge_'});
else
	IO.EPICEA.ASCII_2_mat_one(ions_path, {'Var1', 'Var8', 'Var9' , 'Var2'});
end
end

