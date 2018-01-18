% Description: Save function that save all experiments' metadata.
%   - inputs:
%           All experiments' metadata structure.
%   - outputs:
%           None.
% All experiments' metadata structures are saved in the file folder in
% which the experiments' data files are located with file name:
%       md_[ exp_filename ].m
% Date of creation: 2017-09-12.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ ] = SaveWork()
    md_GUI = evalin('base', 'md_GUI');
    expnames = fieldnames(md_GUI.mdata_n);
    save_mode = questdlg('Replace or update metadata?', 'Save workspace', 'Replace', 'Update', 'Cancel', 'Cancel');
    for ll = 1:length(expnames)
        exp_fullfilepath = md_GUI.mdata_n.(char(expnames(ll))).filepath;
        [exp_path, exp_filename] = fileparts(exp_fullfilepath);
        md_fullfilepath = fullfile(exp_path, ['md_', exp_filename, '.m']);
        exp_md = md_GUI.mdata_n.(char(expnames(ll)));
        switch save_mode
            case 'Replace'
                matlab.io.saveVariablesToScript(md_fullfilepath, 'exp_md', 'SaveMode', 'create')
            case 'Update'
                matlab.io.saveVariablesToScript(md_fullfilepath, 'exp_md', 'SaveMode', 'update')
            case 'Cancel'
                return
        end
        GUI.log.add(['Metadata file for md_', exp_filename, '.m saved locally.' ])
    end
end