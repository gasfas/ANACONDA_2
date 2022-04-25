function exp = CSV_to_hist(CSV_filepath)
% Function to import array of CSV files from FLASH measurements using the
% Groningen 'Paultje' setup. 
% Inputs:
%   CSV_filepath:   char string, The complete path to where the CSV files can be found.
%   All CSV files in that directory are assumed to contain data and will 
%     thus be attempted to import.
% Outputs:
%   exp: struct, containing the experimental data

% Locate and fetch the names of csv files:
csv_filenames = dir (fullfile(CSV_filepath, '*.csv'));

nof_files = size(csv_filenames,1);
% Get the data array size from the first in the list (note we assume here that all other CSV files are equally long):
csv_filename_1 = fullfile(CSV_filepath, csv_filenames(1).name); % Construct the full CSV filename
M = dlmread(csv_filename_1, '\t');% Read the CSV file
hist_length = size(M,1);
exp.hist.det1.m2q.I = zeros(nof_files, hist_length);
exp.hist.det1.m2q.bins = M(:,1); % Assuming all bins are the same

for filenr_cur = 1:nof_files
    % Construct the full CSV filename:
    csv_filename_cur = fullfile(CSV_filepath, csv_filenames(filenr_cur).name);
    % Read the CSV file:
    M = dlmread(csv_filename_cur, '\t');
    % Store them in exp:
    exp.hist.det1.m2q.I(filenr_cur,:) = M(:,2);
    
end