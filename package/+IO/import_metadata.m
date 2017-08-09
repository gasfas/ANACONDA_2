    function [exp_md, simu_md, th_md] = import_metadata (filename)
%  This macro imports the metadata from a filename.
%  input:
% filename  The directory and filename to the datafile of interest.
%           If a DLT file is given, a MAT file is searched in the same
%           folder. If a MAT file is not found, the DLT file is converted 
%          - and saved as .MAT file.

if ~strcmp(filename(end-2:end), '.m')
    filename = [filename '.m'];
end
[dir, file, ext] = fileparts(filename);
if ~strcmp(file(1:3), 'md_')
    file = ['md_' file];
end

basedir = pwd;

cd (dir)
run([file ext]);
cd(basedir)
% run(fullfile(dir, file));

if ~exist('exp_md', 'var')
    exp_md = [];
end
if ~exist('simu_md', 'var')
    simu_md = [];
end
if ~exist('th_md', 'var')
    th_md = [];
end

end
