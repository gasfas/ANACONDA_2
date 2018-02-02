function [exp_mds, simu_mds, th_mds] = import_metadata_n (filenames)
%  This macro imports the metadata from multiple filenames.
%  input:
% filename  The directory and filename to the datafile of interest.
%           If a DLT file is given, a MAT file is searched in the same
%           folder. If a MAT file is not found, the DLT file is converted 
%           and saved as .MAT file.

exp_names = fieldnames(filenames);
for i = 1:length(exp_names)
    filename = filenames.(exp_names{i});
    [exp_mds.(exp_names{i}) simu_mds.(exp_names{i}) th_mds.(exp_names{i})] = IO.import_metadata(filename);
end

end
