% Description: Loads the selected file into memory. Gives the loaded files
% default experiment settings (to allow it for direct plotting).
%   - inputs: 
%           Experiment names        (exp_names)
%           Folder name             (folder_name)
%           File selected           (fileselected)
%           Previously loaded files (String_LoadedFiles)
%   - outputs: 
%           Experiment names        (exp_names)
%           Loaded files            (String_LoadedFiles)
%           File data               (data_n)
%           File metadata           (mdata_n)
% Date of creation: 2017-07-10.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

%% LoadFile function
function [ ] = LoadFile(UILoad, UIPlot, UIFilter) 
md_GUI = evalin('base', 'md_GUI');
%% Get names and dir
folder_name = md_GUI.load.folder_name;
files_selected = md_GUI.UI.UILoad.ListOfFilesInFolder.String(md_GUI.UI.UILoad.ListOfFilesInFolder.Value);
for fls = 1:length(files_selected)
fileselected = files_selected(fls);
NumberOfLoadedFiles = length(md_GUI.UI.UILoad.LoadedFiles.String);
fullfilepath = char(fullfile(folder_name, fileselected));
[dir, filename, ext] = fileparts(fullfile(fullfilepath));
if NumberOfLoadedFiles == 1
    if strcmp(char(md_GUI.UI.UILoad.LoadedFiles.String), '-') || isempty(char(md_GUI.UI.UILoad.LoadedFiles.String))
        NumberOfLoadedFiles = 0;
    end
end
if NumberOfLoadedFiles == 0
    md_GUI.load.exp_names(1) = cellstr('exp1');
    String_LoadedFiles(1) = cellstr(filename);
else
    if iscell(md_GUI.load.exp_names)
        md_GUI.load.exp_names(NumberOfLoadedFiles+1) = cellstr({['exp', int2str(NumberOfLoadedFiles+1)]});
    else
        exp_names(1) = cellstr({char(md_GUI.load.exp_names)});
        exp_names(NumberOfLoadedFiles+1) = cellstr({['exp', int2str(NumberOfLoadedFiles+1)]});
        md_GUI.load.exp_names = exp_names;
    end
	data_n = md_GUI.data_n;
    mdata_n = md_GUI.mdata_n;
    String_LoadedFiles = md_GUI.UI.UILoad.LoadedFiles.String;
    String_LoadedFiles(length(String_LoadedFiles)+1) = cellstr(filename);
end
file = fullfile(dir, filename);
md_def_setting = md_GUI.UI.UILoad.md_default_radiobuttongroup.SelectedObject.String;
switch md_def_setting
    case 'Local configurations'
	[exp_md, islocal, md_loading_message] = read_local_md(dir, filename, md_GUI);
    case 'System configurations'
    exp_md = GUI.load.IO.buttons.LoadFile_system_md(md_GUI);
	% Message to log_box
    md_loading_message = 'System metadata used.';
    case 'Combined configurations'
	[exp_md_local, islocal, md_loading_message] = read_local_md(dir, filename, md_GUI);
    if islocal
        exp_md_system = GUI.load.IO.buttons.LoadFile_system_md(md_GUI);
        exp_md = general.struct.catstruct(exp_md_system, exp_md_local);
    else
        exp_md = exp_md_local;
        % Message to log_box:
        md_loading_message = 'Local metadata not found for file.';
    end
end
if isempty(exp_md)
    return
else
    GUI.log.add(md_loading_message)
end
[mdata_n.(['exp', num2str(NumberOfLoadedFiles+1)])] = exp_md;
%% Load the experimental data.
[data_n.(['exp', num2str(NumberOfLoadedFiles+1)])]   = IO.import_raw(file);
d_fn.(['exp', num2str(NumberOfLoadedFiles+1)]) = fullfile(fullfilepath);
if NumberOfLoadedFiles > 0
    for lx = 1:NumberOfLoadedFiles
        d_fn.(['exp', num2str(lx)]) = md_GUI.mdata_n.(['exp', num2str(lx)]).filepath;
    end
end
data_n.info.foi = fieldnames(d_fn);
data_n.info.numexps = length(data_n.info.foi);
[data_n.(['exp', num2str(NumberOfLoadedFiles+1)]), mdata_n.(['exp', num2str(NumberOfLoadedFiles+1)])] = macro.all(data_n.(['exp', num2str(NumberOfLoadedFiles+1)]), mdata_n.(['exp', num2str(NumberOfLoadedFiles+1)]));
md_GUI.data_n = data_n;
md_GUI.mdata_n = mdata_n;
md_GUI.mdata_n.(['exp', num2str(NumberOfLoadedFiles+1)]).filepath = fullfilepath;
md_GUI.mdata_n.(['exp', num2str(NumberOfLoadedFiles+1)]).dir = md_GUI.load.folder_name;
md_GUI.plot.expsettings.(['exp', num2str(NumberOfLoadedFiles+1)]) = [2 1 1];
set(UILoad.UnLoadFileButton, 'Enable', 'on')
exps = md_GUI.data_n.(['exp', num2str(NumberOfLoadedFiles+1)]);
filesextratext = 'Last loaded file information: \n';

%Try to fetch any added comments/information about the information:
try 
    information = exps.info;
	information_comment = information.comment;
    information_acq_start = information.acquisition_start_str;
    information_acq_dur = information.acquisition_duration;
    information_acq_dur = num2str(information_acq_dur);
    informationbox = sprintf([filesextratext, filename, '\nExperiment: exp', num2str(NumberOfLoadedFiles+1), '\n\nFile information comment: \n', information_comment,'\nData acquisition start: \n',information_acq_start,'\nData acquisition duration: \n',information_acq_dur]);
catch
    informationbox = sprintf([filesextratext, filename, '\nExperiment: exp', num2str(NumberOfLoadedFiles+1), '\nNo info found.']);
end
set(UILoad.SelectedFileInformation, 'String', informationbox);
disp('Log: Finished loading file.')
set(UILoad.LoadedFiles, 'String', String_LoadedFiles);
set(UILoad.LoadedFiles, 'Enable', 'on');
set(UIPlot.LoadedFilesPlotting, 'String', String_LoadedFiles);
set(UIPlot.LoadedFilesPlotting, 'Enable', 'on');
GUI.log.add(['File loaded: exp', num2str(NumberOfLoadedFiles+1), ', ', char(filename)])
end
assignin('base', 'md_GUI', md_GUI)
end

function [exp_md, islocal, md_loading_message] = read_local_md(dir, filename, md_GUI)
    try	
        metadata_loc = fullfile(dir, ['md_', filename, '.m']);
        exp_md = IO.import_metadata(metadata_loc);
        islocal = true;
        md_loading_message = 'Local metadata used.';
    catch
        exp_md = GUI.load.IO.buttons.LoadFile_system_md(md_GUI);
        islocal = false;
        md_loading_message = 'Local metadata not found for file.';
    end
end