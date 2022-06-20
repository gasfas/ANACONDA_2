function [  ] = ASCII_2_mat_one(file_path)
%General function to convert Cobolb PC Custom ASCII datafiles to MATLAB
%datafiles. This function only converts either ions or electrons. The
%function automatically saves the mat file in the same folder as the ASCII
%file.
% Inputs:
% file_path		the filepath where the ASCII file can be found
% Outputs
% -
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se


% read the event ID datafile:
d_e = datastore(file_path);
data = d_e.readall;
data = table2array(data);

if ~isempty(d_e.SelectedVariableNames)
	for i = 1:length(d_e.SelectedVariableNames)
	d.(d_e.SelectedVariableNames{i}) = data(:,i);
	end
else
	d = [];
end

[fn_path, fn_file] = fileparts(file_path);
save(fullfile(fn_path, [fn_file '.mat']), 'd', '-mat', '-v7.3');
clear d data

end