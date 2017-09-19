% function [exp, info] = DLT2ANA2(dltfilename)

% Demonstrates usage of the DLT reading library
load('PhDdir.mat', 'PhDdir'); default_style;
dltfilename = fullfile(PhDdir, 'Research', 'H2O_NH3_clusters','NH3_clusters','20130904_013.dlt');
[~, b_fn] = fileparts(dltfilename); % the bare filename.

dlt = DLT(dltfilename);

dlt.set_detectors(dlt.detectors{1}); % read using DLD only
dlt.read(); % load data

% Converting the data to the units used in ANACONDA2 software:
TXY = (dlt.XYT{1}([3 1 2], :))';
% The time to ns:
TXY = [TXY(:,1)*1e9, TXY(:,2)*1e3, TXY(:,3)*1e3];

% Filling in the data into the ANACONDA-format:
exp.e.raw = dlt.start_index;
exp.h.det1.raw = TXY;
exp.h.det1.raw_sn = {'T [ns]', 'X [mm]', 'Y [mm]'}

info = struct(dlt);
clear dlt;
info = rmfield(info, 'absolute_group_trigger_time');
info = rmfield(info, 'start_index');
info = rmfield(info, 'XYT');
info = rmfield(info, 'discarded');
info = rmfield(info, 'rescued');

