function createdate = get_file_creation_date(filename)
% Get the creation date of a file. Currently only works under windows
% Inputs:
% - filename
% Outputs:
% - createdate

if ispc
    [~,str] = dos(['dir "' filename '"']);
    c = textscan(str,'%s');
    createdate = c{1}{15};
else
    createdate = []; % TODO: extend to other OS.
end
end