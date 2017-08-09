function [exp] = convert_2_ANA2(dir, filename_base)
% Importing and converting EPICEA files to ANACONDA2 files.

dir = fullfile(dir, filename_base);
% Convert to mat file:
IO.EPICEA.ASCII_2_mat([dir '_electrons.txt'], [dir '_ions.txt']);
% Load the mat file:
exp = IO.EPICEA.load_mat([dir '_events'], [dir '_electrons'], [dir '_ions']);

end