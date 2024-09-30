function sample_data = load_FELIX_CSV_filedir(CSV_filename)
% Load the CSV files generated from the FELIX amazon files:
% Read the column names (will serve as M2q scale):

[~, filename, ~]   = fileparts(CSV_filename);
csv_filename_cur        = fullfile(CSV_filename, [filename, '.D.csv']);

fid                     = fopen(csv_filename_cur);
if ~fid
    msgbox("FELIX data directory and/or file not found. Please try again, specify the .d directory.")
    % TODO: error will be thrown, ideally this does not happen.
else
header                  = textscan(fgetl(fid), '%s','Delimiter',',');
data                    = transpose(fscanf(fid, '%g,%g,%g\n', [3, Inf]));
end
fclose(fid);

date_measured           = general.get_file_creation_date(csv_filename_cur);
sample_data.comments    = ['FELIX measurement, last modified on ' date_measured];

% Assuming the FELIX Amazon data format, the headers contain the fragment
% (rounded) masses starting with the name: 'EIC (F): ' for the fragments,
% and ' EIC (P): ' for the parent.
% These columns will be picked out and given each a bin in the M2Q
% 'spectrum'.
fragment_column_nrs = find(contains(header{:}, 'EIC (F):'));
parent_column_nrs   = find(contains(header{:}, 'EIC (P):'));
% Get the masses of the fragments and parent:
header_cell = header{:};
if isempty(fragment_column_nrs)
    fragment_masses = [];
else
    fragment_masses_str = general.char.replace_symbol_in_char(header_cell(fragment_column_nrs), 'EIC (F): ', '');
    fragment_masses     = cellfun(@str2num, fragment_masses_str);
end
parent_masses_str   = general.char.replace_symbol_in_char(header_cell(parent_column_nrs), 'EIC (P): ', '');

parent_masses       = cellfun(@str2num, parent_masses_str);
[all_masses, idx]   = sort([fragment_masses, parent_masses]);


% Fill the columns into a spectrum for each row:
% Read the matrix:
[D]             = readmatrix(csv_filename_cur);

% Fetch the wavenumbers, and convert them to photon energy (used internally):
wavenumber_column_nrs = find(ismember(header{:}, 'wavenumber'));
sample_data.photon.energy = D(:, wavenumber_column_nrs(1)) * general.constants('cm-1_to_eV');
% Get the photodiode current ('Laser measured')
Laser_power_measured_column_nr = find(ismember(header{:}, 'Laser Measured'));
% Interpolate the zero-measurements:
sample_data.Photodiode.current  = convert.replace_outliers_in_array(D(:, Laser_power_measured_column_nr), 0);

% Fill in the histograms:
for filenr_cur = 1:size(D, 1)
    % Store them in exp:
    spectr_name_cur     = ['spectr_', num2str(filenr_cur, '%03.f')];
    sample_data.hist.(spectr_name_cur).M2Q.I        = D(filenr_cur, idx);
    sample_data.hist.(spectr_name_cur).M2Q.bins     = all_masses';
end
end