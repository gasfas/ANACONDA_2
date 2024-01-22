function [data_struct] = export_to_Spektrolatius_csv (data_struct, csv_filename)
% This function reads a csv datafile, as exported by Ackbar acquisition.
% Inputs:
% data_struct       The struct with fields... TODO
% csv_filename      The filename to which to write the csv file.
% Outputs:

% Initiate the data struct:
export_struct = struct();

% These are the variable names that need to be exported:
% {'tof_us_'  'm_z'  'Empty'  'ESI'  'Photon'  'ESI_photon'  'Subtracted'}

% disect the data struct, see which fields are present:
if any(contains(fieldnames(data_struct), 'M2Q'))
    % mass-to-charge data is present, so we fill in those bins and
    % intensity:
    m_z       = data_struct.M2Q.bins;
    Photon    = data_struct.M2Q.I;
    nof_bins  = length(Photon);
end

% Fill in the empty bins:
if ~exist('tof_us_', 'var')
    tof_us_   = zeros(nof_bins, 1);
end
if ~exist('Empty', 'var')
    Empty   = zeros(nof_bins, 1);
end
if ~exist('ESI', 'var')
    ESI   = zeros(nof_bins, 1);
end
if ~exist('Photon', 'var')
    Photon   = zeros(nof_bins, 1);
end
if ~exist('ESI_photon', 'var')
    ESI_photon = zeros(nof_bins, 1);
end
if ~exist('Subtracted', 'var')
    Subtracted   = zeros(nof_bins, 1);
end

% Create the new emtpy csv file
T_csv = table(tof_us_, m_z, Empty, ESI, Photon, ESI_photon, Subtracted); 

% Write header lines:
headertext = 'tof(us)	m/z	Empty	ESI	Photon	ESI+photon	Subtracted';
% Write the table to csv file:
writetable(T_csv, csv_filename,'Delimiter','\t')

end