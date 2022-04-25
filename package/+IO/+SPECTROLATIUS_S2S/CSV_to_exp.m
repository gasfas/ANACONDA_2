function exp = CSV_to_exp(CSV_filepath, rebin_factor, threshold_intensity, max_nof_csv_files)
% Function to import array of CSV files from FLASH measurements using the
% Groningen 'Paultje' setup. 
% Inputs:
%   CSV_filepath:   char string, The complete path to where the CSV files can be found.
%   All CSV files in that directory are assumed to contain data and will 
%     thus be attempted to import.
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
csv_filenames = dir (fullfile(CSV_filepath, '*shot*.csv'));

nof_files = size(csv_filenames,1);
% Get the data array size from the first in the list (note we assume here that all other CSV files are equally long):
csv_filename_1 = fullfile(CSV_filepath, csv_filenames(1).name); % Construct the full CSV filename

% Read the creation date:
fileInfo = IO.getfileinfo(csv_filename_1);
crD     = fileInfo.CreationDate;
% Column version after 21 April 2021:
if  datetime(str2num(crD(7:10)), str2num(crD(4:5)), str2num(crD(1:2))) > datetime(2022, 04, 21)
    csv_version = 'column';
else 
    csv_version = 'row';
end

% Read the first CSV file:
M = read_CSV_file(csv_filename_1, csv_version);
hist_length = size(M,1);

if exist('max_nof_csv_files', 'var') % If requested, the number of CSV files is limited.
    nof_files = min(nof_files, max_nof_csv_files);
end

exp.hist.det1.TOF.I = zeros(nof_files, floor(hist_length/rebin_factor));

if ~exist('threshold_intensity', 'var') % No threshold intensity given.
    threshold_intensity = -1000; %[mV] very low threshold, so that no data will be affected.
end

for filenr_cur = 1:nof_files
    % Construct the full CSV filename:
    csv_filename_cur = fullfile(CSV_filepath, csv_filenames(filenr_cur).name);
    % Read the CSV file:
    M = read_CSV_file(csv_filename_cur, csv_version);
    % Remove all datapoints below threshold:
    M(M<threshold_intensity) = 0;
    % Re-bin it if requested:
    M = hist.H_1D_rebin_intensity(M, rebin_factor);
    % Store them in exp:
    exp.hist.det1.TOF.I(filenr_cur,:) = single(transpose(M));
end

% Collect the TOF/m2q data:
scan_files = dir(fullfile(CSV_filepath, '*scans.csv'));
csv_scan_filenames = fullfile(CSV_filepath, scan_files(1).name);
M_scan = dlmread(csv_scan_filenames, '\t', 2, 0);% Read the CSV file
% M_scan = M_scan(1:floor(hist_length/rebin_factor)*rebin_factor,:); % skim off end 
M_TOF  = hist.H_1D_rebin_intensity(M_scan(:,1), rebin_factor);
M_m2q  = hist.H_1D_rebin_intensity(M_scan(:,2), rebin_factor);

% M_TOF = mean(reshape(M_scan(:,1),rebin_factor,floor(hist_length/rebin_factor)),1); % re-bin
% M_m2q = mean(reshape(M_scan(:,2),rebin_factor,floor(hist_length/rebin_factor)),1); % re-bin

if strcmp(csv_version, 'column')
    exp.hist.det1.TOF.bins = transpose(M_TOF(1:5:end));
    exp.hist.det1.m2q.bins = transpose(M_m2q(1:5:end));
else
    exp.hist.det1.TOF.bins = transpose(M_TOF);
    exp.hist.det1.m2q.bins = transpose(M_m2q);

end
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