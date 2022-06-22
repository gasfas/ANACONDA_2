function exp = XLSX_to_exp(XLSX_filename)
% Function to import array of XLSX files from measurements using the
% modified Bruker Qex FT mass spectrometer in Lyon. 
% Inputs:
%   XLSX_filename:   char string: The complete name (including path) to where the CSV files can be found.
% Outputs:
%   exp: struct, containing the experimental data

% Read the XLSX file:
M = xlsread(XLSX_filename);

exp.hist.det1.TOF.bins  = M(:,1);
exp.hist.det1.TOF.I     = M(:,2);

end
