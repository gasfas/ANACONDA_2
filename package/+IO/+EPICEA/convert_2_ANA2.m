function [exp] = convert_2_ANA2(dir, filename_base)
% Importing and converting EPICEA files to ANACONDA2 files.
% Inputs:
% dir			the directory (path) at which the ASCII files can be found
% filename_base the filename, without '_ions' or '_electrons', etc postfix.
% Outputs:
% exp			The experimental data in ANACONDA_2 format.
%
% Written by Smita Ganguly, 2021, Lund university: smita.ganguly(at)sljus.lu.se

dir = fullfile(dir, filename_base);
% Convert to mat file:
IO.EPICEA.ASCII_2_mat([dir '_electrons.txt'], [dir '_ions.txt'],[dir '_events.txt']);
% Load the mat file:
% exp = IO.EPICEA.load_mat([dir '_events'], [dir '_electrons'], [dir '_ions']);

exp = IO.EPICEA.load_mat_with_event([dir '_events'], [dir '_electrons'], [dir '_ions']);

end