% Description: Sets the location of the md_defaults file for files to be 
% loaded. 
%   - inputs: None.
%   - outputs: Filepath of md_defaults      (exp_md)
% Date of creation: 2017-07-03.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ ] = Conf()
md_GUI = evalin('base', 'md_GUI');
[filename_mdDefault, filepath_mdDefault] = uigetfile();
exp_md = IO.import_metadata(fullfile(filepath_mdDefault, filename_mdDefault));
md_GUI.exp_md = exp_md;
assignin('base', 'md_GUI', md_GUI);
end