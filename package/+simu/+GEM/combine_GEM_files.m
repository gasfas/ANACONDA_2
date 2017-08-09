function [ GEM_data ] = combine_GEM_files(GEM_filename1, GEM_filename2, filename_dest)
%This function combines two GEM-files.
%   the first GEM filename will be written on top.
%   filename_dest specifies the destination name of the new GEM-file.
settings1 = struct; settings2 = struct;
[settings1] = read_GEM_file(settings1, GEM_filename1);
[settings2] = read_GEM_file(settings2, GEM_filename2);

GEM_data = settings1.GEM.data
% to be finished
end

