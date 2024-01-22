function [data_struct] = import_Spektrolatius_csv (csv_filename)
% This function writes out a datafile to csv format, that can be read by
% the quick spectra viewer.
% Inputs:
% csv_filename      The filename from which to read the data.
% Outputs:
% data_struct       The struct with fields... TODO

% Load the csv file into a table(skip the first empty line):
T_csv = readtable(csv_filename, 'NumHeaderLines', 1);

if sum(T_csv.Photon) > 0 % If a photon-induced signal has been recorded:
    data_struct.TOF.I       = T_csv.Photon;
    disp('Photon-induced data found and returned');
elseif sum(T_csv.ESI) > 0
    data_struct.TOF.I       = T_csv.ESI;
    disp('ESI-induced data found and returned');
end

%% Re-binning M2Q spectra:
data_struct.TOF.bins    = T_csv.tof_us_;
% m2q spectrum can be retrieved from the TOF intensities:
binsize_m2q_0           = mean(diff(T_csv.m_z));
binsize_m2q             = [diff(T_csv.m_z(1:2)); diff(T_csv.m_z)];
I_m2q_nonuniform        = data_struct.TOF.I * binsize_m2q_0./binsize_m2q;
% Make uniform bins for the m2q bins (interpolate):
data_struct.M2Q.bins    = linspace(max(0, min(T_csv.m_z)), max(T_csv.m_z), length(T_csv.m_z));
idx_m2q_above_0         = T_csv.m_z>0;
data_struct.M2Q.bins    = data_struct.M2Q.bins(idx_m2q_above_0)';
data_struct.M2Q.I       = interp1(T_csv.m_z(idx_m2q_above_0), I_m2q_nonuniform(idx_m2q_above_0), data_struct.M2Q.bins)';
end