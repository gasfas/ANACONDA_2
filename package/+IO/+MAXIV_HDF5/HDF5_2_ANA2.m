function [exp] = HDF5_2_ANA2(base_path, filename)
% Function to import HDF5 data sets into the ANACONDA2 data format.
% Inputs:
% base_path		string, containing the path to the data-containing folder. 
%				The program expects this directory to contain a file with 
%               the *.HDF5 extension. 
% filename      The name of the HDF5 file, with or without .hdf5 extension
% Outputs:
% exp           struct containing the experimental data. 
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% define the full filename:
if ~strcmpi(filename(end-4:end), '.hdf5')
    fullfilename = fullfile(base_path, [filename '.hdf5']);
else
    fullfilename = fullfile(base_path, filename);
end

% Second detector:
det_2_events_dataset = '/scan/Instrument/Detector1/events';
det_2_hits_dataset = '/scan/Instrument/Detector1/hits';

%% Load the file to memory, one detector at the time:
% The HDF5 data detector numbers starts counting at 0:
detector_nr = 0;
while ~isnan(detector_nr)
    % define the names of the different datasets:
        % detector names:
        events_dataset_name = ['/scan/Instrument/Detector' num2str(detector_nr) '/events'];
        hits_dataset_name   = ['/scan/Instrument/Detector' num2str(detector_nr) '/hits'];
    % There could still be more detectors which' data is to be fetched:
    exp.e.(['det' num2str(detector_nr+1)]).raw  = IO.MAXIV_HDF5.read_HDF5_dataset(fullfilename, events_dataset_name, 'events');
    exp.h.(['det' num2str(detector_nr+1)]).raw  = IO.MAXIV_HDF5.read_HDF5_dataset(fullfilename, hits_dataset_name, 'hits');
    % see if there are more detectors defined:
    try h5readatt(fullfilename, ['/scan/Instrument/Detector' num2str(detector_nr+1)], 'NX_class');
        % another detector to read out from:
        detector_nr = detector_nr + 1;
    catch % no more detectors to read out from
       detector_nr = NaN;
    end
end

% h5read('/home/ina/Documents/Lund/HDF5_example/
% 02_idet_dark_2400V_30hz_a.lmf.streamed.rawpackets.resorted.hdf5', '/scan/Instrument/Detector0/events')