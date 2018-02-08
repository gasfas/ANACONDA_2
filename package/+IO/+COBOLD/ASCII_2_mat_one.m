function [  ] = ASCII_2_mat_one(file_path)
%General function to convert Cobolb PC Custom ASCII datafiles to MATLAB
%datafiles. This function only converts either ions or electrons.

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
save(fullfile(fn_path, [fn_file '.mat']), 'd', '-mat');
clear d data

end