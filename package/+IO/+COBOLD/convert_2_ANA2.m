function [exp] = convert_2_ANA2(dir, filename_base)
% Importing and converting COBOLD files to ANACONDA2 files.
% Inputs:
% dir			the directory (path) at which the ASCII files can be found
% filename_base the filename, without '_ions' or '_electrons', etc postfix.
% Outputs:
% exp			The experimental data in ANACONDA_2 format.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

dir = fullfile(dir, filename_base);
% Define the names of the different files:
event_bfn	= [dir '.lmf_ID_DAn'];
elec_bfn	= [dir '.lmf_elec_DAn'];
ion_bfn		= [dir '.lmf_ion_DAn'];
% Convert to mat file:
% electrons:
IO.COBOLD.ASCII_2_mat_one([elec_bfn '.dat'])
% ions:
IO.COBOLD.ASCII_2_mat_one([ion_bfn '.dat']);
% events:
IO.COBOLD.ASCII_2_mat_one([event_bfn '.dat']);
% Load the mat file:
exp = IO.COBOLD.load_mat([event_bfn '.mat'], [elec_bfn '.mat'], [ion_bfn '.mat']);

end