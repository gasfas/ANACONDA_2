function [  ] = ASCII_2_mat(electrons_path, ions_path)
%General function to convert EPICEA ASCII datafiles to ANACONDA 2
%datafiles.

% read the electron datafile:
 IO.COBOLD.ASCII_2_mat_one(electrons_path);

% read the ion datafile:
IO.COBOLD.ASCII_2_mat_one(ions_path);
end

