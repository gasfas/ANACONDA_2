function [exp_mds, simu_mds, th_mds] = import_metadata_n (filenames)
%  This macro imports the metadata from multiple filenames.
%  input:
% filenames struct with filenames to the datafile of interest.
%           If a DLT file is given, a MAT file is searched in the same
%           folder. If a MAT file is not found, the DLT file is converted 
%           and saved as .MAT file.
% Output:
% exp_mds	struct, The experimental metadata
% simu_mds	struct, The simulation metadata (if it exists)
% th_md	struct, The theory metadata (if it exists)
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

exp_names = fieldnames(filenames);
for i = 1:length(exp_names)
    filename = filenames.(exp_names{i});
    [exp_mds.(exp_names{i}) simu_mds.(exp_names{i}) th_mds.(exp_names{i})] = IO.import_metadata(filename);
end

end
