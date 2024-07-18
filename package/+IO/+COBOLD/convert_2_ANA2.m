function [exp] = convert_2_ANA2(dir, filename_base, is_hdf5)
% Importing and converting COBOLD files to ANACONDA2 files.
% Inputs:
% dir			the directory (path) at which the ASCII files can be found
% filename_base the filename, without '_ions' or '_electrons', etc postfix.
% is_hdf5       Boolean if the importing file is the hdf5 file.
% Outputs:
% exp			The experimental data in ANACONDA_2 format.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if ~exist("is_hdf5", "var")
    is_hdf5 = false;
end
filename = fullfile(dir, filename_base);

if ~is_hdf5
    % Define the names of the different files:
    event_bfn	= [filename '.lmf_ID_DAn'];
    elec_bfn	= [filename '.lmf_elec_DAn'];
    ion_bfn		= [filename '.lmf_ion_DAn'];
    % Convert to mat file:
    % electrons:
    IO.COBOLD.ASCII_2_mat_one([elec_bfn '.dat'])
    % ions:
    IO.COBOLD.ASCII_2_mat_one([ion_bfn '.dat']);
    % events:
    IO.COBOLD.ASCII_2_mat_one([event_bfn '.dat']);
    % Load the mat file:
    exp = IO.COBOLD.load_mat([event_bfn '.mat'], [elec_bfn '.mat'], [ion_bfn '.mat']);
else  % This means the user wants to load a hdf5 file to ANA2:  

    exp = IO.MAXIV_HDF5.HDF5_2_ANA2(dir, filename_base);
    % % det0 is the ion detector.
    % rawimport.e.det0.raw        = h5read(dir, '/scan/Instrument/Detector0/events')';
    % exp.h.det0.raw              = h5read(dir, '/scan/Instrument/Detector0/hits')';
    % rawimport.e.det1.raw        = h5read(dir, '/scan/Instrument/Detector1/events')';
    % exp.h.det1.raw              = h5read(dir, '/scan/Instrument/Detector1/hits')';
    % % Structure of event data is as follows: [event_nr, unknown, hit_idx_detX]
    % % Count the number of events:
    % nof_events                  = max(max(rawimport.e.det0.raw(:,1)), max(rawimport.e.det1.raw(:,1)));
    % % Generate an empty event array with that size:
    % exp.e.raw                   = NaN*ones(nof_events, 2);
    % % place indices in all event rows that are indicated:
    % exp.e.raw(rawimport.e.det0.raw(:,1), 1) = rawimport.e.det0.raw(:,3);
    % exp.e.raw(rawimport.e.det1.raw(:,1), 2) = rawimport.e.det1.raw(:,3);
    
end

end