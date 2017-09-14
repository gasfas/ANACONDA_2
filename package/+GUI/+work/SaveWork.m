% Description: Save function...
%   - inputs:
%           UI controls.
%   - outputs:
%           Callback functions for the UI controls.
% Date of creation: 2017-07-11.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ ] = SaveWork()
currentdir = pwd;
md_GUI = evalin('base', 'md_GUI');
metadata = md_GUI.mdata_n;
exp_fullfilepaths = md_GUI.d_fn;
expnames = fieldnames(metadata);
for ll = 1:length(expnames)
    filepath = exp_fullfilepaths.(char(expnames(ll)));
    filepath = strsplit(filepath, '/');
    fullfilename = char(filepath(length(filepath)));
    filepath = strsplit(exp_fullfilepaths.(char(expnames(ll))), fullfilename);
    filepath = char(filepath(1));
    filename = strsplit(fullfilename, '.');
    filename = ['md_', char(filename(1)), '.m'];
    exp_md = metadata.(char(expnames(ll)));
    cd(filepath)
    matlab.io.saveVariablesToScript(filename, 'exp_md')
end
cd(currentdir)
end