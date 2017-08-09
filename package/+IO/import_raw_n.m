function [exps] = import_raw_n (filenames)
%  This macro imports the data from multiple files.
%  input:
% filename  A struct listing directories to the datafiles of interest.
%           If a DLT file is given, a MAT file is searched in the same
%           folder. If a MAT file is not found, the DLT file is converted 
%           and saved as .MAT file.

exp_names = fieldnames(filenames);
for i = 1:length(exp_names)
    filename = filenames.(exp_names{i});
    exps.(exp_names{i}) = IO.import_raw(filename);
end