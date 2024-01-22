function hist = txt_hist(txt_filename)
% Function to import array of ASCII txt files from measurements using the
% modified Bruker Qex FT mass spectrometer in Lyon. 
% Inputs:
%  txt_filename:   char string: The complete name (including path) to where the CSV files can be found.
% Outputs:
%   hist: The struct containing the histogram saved in the mzML file.

% Read the XLSX file:
M = IO.Qex_Lyon.txt2mat(txt_filename, 'InfoLevel', 0);

hist.M2Q.bins   = M(:,1);
hist.M2Q.I      = M(:,2);

end
