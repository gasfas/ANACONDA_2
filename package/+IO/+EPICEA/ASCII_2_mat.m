function [  ] = ASCII_2_mat(electrons_path, ions_path)
%General function to convert EPICEA ASCII datafiles to ANACONDA 2
%datafiles. 
% Inputs:
% electrons_path	The location to find electron datafiles
% ions_path			The location to find ion datafiles
% Outputs:
% -
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% read the electron datafile:
 IO.EPICEA.ASCII_2_mat_one(electrons_path, {'eventId_', 'pos_x', 'pos_y', 'energy' },2);

% read the ion datafile:
d_e = datastore(ions_path);
% The ion file can be with or without header:
if cell2mat(strfind(d_e.VariableNames,'eventId_'))
	IO.EPICEA.ASCII_2_mat_one(ions_path, {'eventId_', 'pos_x', 'pos_y' ,  'tof_fallingEdge_'},1);
else
	IO.EPICEA.ASCII_2_mat_one(ions_path, {'Var1', 'Var9', 'Var10' , 'Var2'},1);
end
end

