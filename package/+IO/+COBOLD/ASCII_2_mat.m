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
 IO.COBOLD.ASCII_2_mat_one(electrons_path);

% read the ion datafile:
IO.COBOLD.ASCII_2_mat_one(ions_path);
end

