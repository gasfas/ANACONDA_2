% Description: Loads the selected file into memory. Gives the loaded files
% default experiment settings (to allow it for direct plotting).
%   - inputs: 
%           Folder name             (folder_name)
%           File selected           (fileselected)
%   - outputs: 
%           Experiment names        (exp_names)
%           Name of loaded files    (String_LoadedFiles)
%           File location + name    (d_fn)
%           File data.              (data_n)
%           File metadata.          (mdata_n)
%           Experiment settings.    (expsettings)
%           Number of loaded files. (NumberOfLoadedFiles)
% Date of creation: 2017-07-10.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

%% LoadFile function
function [ ] = LoadFile(UILoad, UIPlot, UIFilter) 
md_GUI = evalin('base', 'md_GUI');
%% Get names and dir
folder_name = md_GUI.load.folder_name;
fileselected = md_GUI.load.fileselected;
filesareloaded = isfield(md_GUI.load, 'NumberOfLoadedFiles'); %0 if does not exist, 1 if it exists.
if filesareloaded == 0
    NumberOfLoadedFiles = 0;
elseif filesareloaded == 1
    NumberOfLoadedFiles = md_GUI.load.NumberOfLoadedFiles;
end
%Gives: 'filenumber', 'fileselected_01', 'NumberOfLoadedFiles', 'String_LoadedFiles'
fullfilepath = char(fullfile(folder_name, fileselected));
filenumber = NumberOfLoadedFiles + 1; %new value has to be saved;
disp(['File selected: ' fullfilepath]) % Print to command line.
NumberOfLoadedFiles = filenumber;
if NumberOfLoadedFiles == 1
    md_GUI.load.exp_names = ['exp', int2str(filenumber)];
else
    if iscell(md_GUI.load.exp_names)
        md_GUI.load.exp_names(filenumber) = cellstr({['exp', int2str(filenumber)]});
    else
        exp_names(1) = cellstr({char(md_GUI.load.exp_names)});
        exp_names(filenumber) = cellstr({['exp', int2str(filenumber)]});
        md_GUI.load.exp_names = exp_names;
    end
end
for s = 1:filenumber
    if s == filenumber
        String_LoadedFiles(s) = fileselected;
    else
        String_LoadedFiles(s) = md_GUI.load.String_LoadedFiles(s);
    end
end
md_GUI.load.String_LoadedFiles = String_LoadedFiles;
md_GUI.load.NumberOfLoadedFiles = NumberOfLoadedFiles;
%Experiment name
filenumber = num2str(filenumber);

%% Load file into memory
if str2num(filenumber) == 1
    % This is exp 1.
else % Load other data from before
    data_n = md_GUI.data_n;
    mdata_n = md_GUI.mdata_n;
end

%% Read metadata
md_GUI.d_fn.(['exp', filenumber]) = fullfile(fullfilepath);
[dir, filename, ext] = fileparts(md_GUI.d_fn.(['exp', filenumber]));
file = fullfile(dir, filename);
md_def_setting = md_GUI.UI.UILoad.md_default_radiobuttongroup.SelectedObject.String;
switch md_def_setting
    case 'Local metadata'
	[exp_md, islocal, md_loading_message] = read_local_md(dir, filename, md_GUI);
    case 'System metadata'
    exp_md = GUI.load.IO.buttons.LoadFile_system_md(md_GUI);
	% Message to log_box
    md_loading_message = 'System metadata used.';
    case 'Combined metadata'
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
[mdata_n.(['exp', filenumber])] = exp_md;
%% Load the experimental data.
[data_n.(['exp', filenumber])]   = IO.import_raw(file);
data_n.info.foi = fieldnames(md_GUI.d_fn);
data_n.info.numexps = length(data_n.info.foi);
[data_n.(['exp', filenumber]), mdata_n.(['exp', filenumber])] = macro.all(data_n.(['exp', filenumber]), mdata_n.(['exp', filenumber])); % Look into data_n <-- 

%% Exporting to md_GUI.
md_GUI.data_n = data_n;
md_GUI.mdata_n = mdata_n;
md_GUI.mdata_n.(['exp', filenumber]).filepath = fullfilepath;
md_GUI.mdata_n.(['exp', filenumber]).dir = md_GUI.load.folder_name;
md_GUI.plot.expsettings.(['exp', filenumber]) = [2 1 1];
set(UILoad.UnLoadFileButton, 'Enable', 'on')
exps = md_GUI.data_n.(['exp', filenumber]);
filesextratext = 'Last loaded file information: \n';
%Try to see if experiment has any information:
try 
    information = exps.info;
    information_acq_start = information.acquisition_start_str;
    information_acq_dur = information.acquisition_duration;
    information_acq_dur = num2str(information_acq_dur);
    information_comment = information.comment; %in experimental data, exps.info field has a variable: comment - which contains experiment information.
    informationbox = sprintf([filesextratext, filename, '\nExperiment: exp', filenumber, '\n\nFile information comment: \n', information_comment,'\nData acquisition start: \n',information_acq_start,'\nData acquisition duration: \n',information_acq_dur]);
catch
    informationbox = sprintf([filesextratext, filename, '\nExperiment: exp', filenumber, '\nNo info found.']);
end
set(UILoad.SelectedFileInformation, 'String', informationbox);
assignin('base', 'md_GUI', md_GUI)
disp('Log: Finished loading file.')

% % Add to loaded files listbox.
set(UILoad.LoadedFiles, 'String', md_GUI.load.String_LoadedFiles);
set(UILoad.LoadedFiles, 'Enable', 'on');
set(UIPlot.LoadedFilesPlotting, 'String', md_GUI.load.String_LoadedFiles);
set(UIPlot.LoadedFilesPlotting, 'Enable', 'on');

GUI.log.add(['File loaded: exp', num2str(NumberOfLoadedFiles), ', ', char(String_LoadedFiles(NumberOfLoadedFiles))])

end

function [exp_md, islocal, md_loading_message] = read_local_md(dir, filename, md_GUI)
    try	
        metadata_loc = fullfile(dir, ['md_', filename, '.m']);
        exp_md = IO.import_metadata(metadata_loc); % Results in an exp_md generated.
        islocal = true;
        md_loading_message = 'Local metadata used.';
    catch
        exp_md = GUI.load.IO.buttons.LoadFile_system_md(md_GUI);
        islocal = false;
        md_loading_message = 'Local metadata not found for file.';
    end
end