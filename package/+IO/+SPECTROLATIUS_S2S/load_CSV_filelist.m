function sample_data = load_CSV_filelist(CSV_filepath, CSV_filelist, rebin_factor, threshold_intensity, max_nof_csv_files)
% Function to import array of CSV files from FLASH measurements using the
% Spektrolatius setup.
% Inputs:
%   CSV_filepath:   string containing the complete path to where the CSV files can be found.
%   CSV_filelist:   cell of strings, each containing the name of each requested CSV file to be loaded.
%   rebin_factor: integer scalar, to re-bin multiple bins into a larger
%                   one to reduce memory issues. e.g. A rebin_factor of 12 on a spectrum
%                   containing 301 bins, reduces the size to 25 (averaged) bins, and dismisses the last
%                   bin. (optional, default = 1)
%   threshold_intensity: scalar [mV], intensity under which the loaded
%                   intensities are set to zero. (optional, default; no
%                   threshold)
%   max_nof_csv_files: By default, this function reads all CSV files, but
%                   if indicated, the user can decide to load only the first
%                   'max_nof_csv_files' csv documents. (optional, default =
%                   all files)
% Outputs:
%   exp: struct, containing the experimental data

 if ~exist('rebin_factor','var')
     % rebinning factor is not given, so no rebinning done:
      rebin_factor = 1;
      % TODO
 end
 
% Locate and fetch the names of csv files (that contain the word 'shot':
csv_filenames.name = CSV_filelist;
if ~iscell(csv_filenames.name) % MATLAB makes no cell if only one file is loaded.
    csv_filenames.name = {csv_filenames.name};
end

nof_files = length(csv_filenames.name);

% Get the data array size from the first in the list (note we assume here that all other CSV files are equally long):
csv_filename_1 = fullfile(CSV_filepath, csv_filenames.name{1}); % Construct the full CSV filename


% Read the first CSV file:
M = read_CSV_file(csv_filename_1, 'column');
hist_length = size(M,1);

if exist('max_nof_csv_files', 'var') % If requested, the number of CSV files is limited.
    nof_files = min(nof_files, max_nof_csv_files);
end

if ~exist('threshold_intensity', 'var') % No threshold intensity given.
    threshold_intensity = -1e100; %[mV] very low threshold, so that no data will be affected.
end

% Collect the TOF/m2q data:
scan_files          = dir(fullfile(CSV_filepath, '*scans.csv'));
csv_scan_filenames  = fullfile(CSV_filepath, scan_files(1).name);
M_scan              = dlmread(csv_scan_filenames, '\t', 3, 0);% Read the CSV file
% M_scan = M_scan(1:floor(hist_length/rebin_factor)*rebin_factor,:); % skim off end 

for filenr_cur = 1:nof_files
    % Construct the full CSV filename:
    csv_filename_cur = fullfile(CSV_filepath, csv_filenames.name{filenr_cur});
    % Column order is assumed as follows:
    % tof(us)	m/z	Empty	ESI	Photon	ESI+photon	Subtracted
    % Read the CSV file:
    Full_csv_table = read_CSV_file(csv_filename_cur, 'column');
    % TODO make the user decide which column(s) to use, and separate background
    I = sum(Full_csv_table(:, 3:6), 2);
    % Remove all datapoints below threshold:
    I(I<threshold_intensity) = 0;
    % Re-bin it if requested:
    I = hist.H_1D_rebin_intensity(I, rebin_factor);
    % Load the bins:
    M  = hist.H_1D_rebin_intensity(Full_csv_table(:,2), rebin_factor);
    % Store them in exp:
    spectr_name_cur     = ['spectr_', num2str(filenr_cur, '%03.f')];
    sample_data.hist.(spectr_name_cur).M2Q.I        = single(transpose(I));
    sample_data.hist.(spectr_name_cur).M2Q.bins     = single(transpose(M));
    energy_number_end   = strfind(csv_filename_cur, 'eV')-1;
    energy_number_start = strfind(csv_filename_cur(1:energy_number_end), '_');
    sample_data.photon.energy(filenr_cur) = str2num(csv_filename_cur(energy_number_start(end)+1:energy_number_end));
end

M_m2q  = hist.H_1D_rebin_intensity(M_scan(:,2), rebin_factor);

% Read the photon energy to store:
% Find the 'eV' in the name of the CSV files: 

% decide the limits around the photon energies:

end

function M = read_CSV_file(csv_filename, csv_version)
% Read the CSV file:
switch csv_version
case 'row'
    M = dlmread(csv_filename, '\t', 1, 0);
case 'column'
    M = dlmread(csv_filename, '\t', 6, 0);        
end
end