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

exp = struct();

%% Load the file to memory, one detector at the time:
% The HDF5 data detector numbers starts counting at 0:
detector_nr = 0; detector_nrs = []; events_dataset_names = {};
while ~isnan(detector_nr) % There could still be more detectors which' data is to be fetched:

    % define the names of the different datasets:
    % detector names:
    events_dataset_name = ['/scan/Instrument/Detector' num2str(detector_nr) '/events'];
    hits_dataset_name   = ['/scan/Instrument/Detector' num2str(detector_nr) '/hits'];
    % First we read out the hits (can be done per detector):
    exp     = IO.MAXIV_HDF5.read_HDF5_hit_dataset(exp, fullfilename, hits_dataset_name, detector_nr);
    
    % Store the detector names and pointers for later:
    detector_nrs   = [detector_nrs; detector_nr];
    events_dataset_names = {events_dataset_names{:}, events_dataset_name};
    
    % see if there are more detectors defined:
    try h5readatt(fullfilename, ['/scan/Instrument/Detector' num2str(detector_nr+1)], 'NX_class');
        % another detector to read out from:
        detector_nr = detector_nr + 1;
    catch % no more detectors to read out from
       detector_nr = NaN;
    end
end
% Now that we know which detector names exist, we can fetch the event data:
exp     = IO.MAXIV_HDF5.read_HDF5_event_dataset(exp, fullfilename, events_dataset_names, detector_nrs);

% h5read('/home/ina/Documents/Lund/HDF5_example/
% 02_idet_dark_2400V_30hz_a.lmf.streamed.rawpackets.resorted.hdf5', '/scan/Instrument/Detector0/events')