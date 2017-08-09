function [exp] = convert_2_ANA2(dir, filename_base)
% Importing and converting EPICEA files to ANACONDA2 files.

dir = fullfile(dir, filename_base);
% Define the names of the different files:
event_bfn	= [dir '.lmf_ID_DAn'];
elec_bfn	= [dir '.lmf_elec_DAn'];
ion_bfn		= [dir '.lmf_ion_DAn'];
% Convert to mat file:
IO.COBOLD.ASCII_2_mat_one([elec_bfn '.dat'])
IO.COBOLD.ASCII_2_mat_one([ion_bfn '.dat']);
IO.COBOLD.ASCII_2_mat_one([event_bfn '.dat']);
% Load the mat file:
exp = IO.COBOLD.load_mat([event_bfn '.mat'], [elec_bfn '.mat'], [ion_bfn '.mat']);

end