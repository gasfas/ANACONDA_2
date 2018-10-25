function [  ] = ASCII_2_mat_one(file_path, headername)
%General function to convert EPICEA ASCII datafiles to ANACONDA 2
%datafiles. This function only converts either ions or electrons. The
%function automatically saves the mat file in the same folder as the ASCII
%file.
% Inputs:
% file_path		the filepath where the ASCII file can be found
% headername	EPICEA ASCII files can have different headers, and this one
%				needs to be known to read it.
% Outputs
% -
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% read the event ID datafile:
d_e = datastore(file_path);
d_e.SelectedVariableNames = headername;
data = d_e.readall;
data = table2array(data);

% Remove the first line, which for some reason does not contain data:
data = data(2:end, :);

for i = 1:length(d_e.SelectedVariableNames)
d.(d_e.SelectedVariableNames{i}) = data(:,i);
end

[fn_path, fn_file, fn_post] = fileparts(file_path);
save(fullfile(fn_path, [fn_file '.mat']), 'd', '-mat');
clear d data

end