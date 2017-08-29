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
folder_name = md_GUI.load.folder_name;
fileselected = md_GUI.load.fileselected;
filesareloaded = isfield(md_GUI.load, 'NumberOfLoadedFiles'); %0 if does not exist, 1 if it exists.
if filesareloaded == 0
    NumberOfLoadedFiles = 0;
elseif filesareloaded == 1
    NumberOfLoadedFiles = md_GUI.load.NumberOfLoadedFiles;
end
%Gives: 'filenumber', 'fileselected_01', 'NumberOfLoadedFiles', 'String_LoadedFiles'
fullfilepath = [folder_name, fileselected];
fullfilepath = strjoin(fullfilepath, {'/'});
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
set(UILoad.LoadedFiles, 'String', md_GUI.load.String_LoadedFiles);
set(UILoad.LoadedFiles, 'Enable', 'on');
set(UIPlot.LoadedFilesPlotting, 'String', md_GUI.load.String_LoadedFiles);
set(UIPlot.LoadedFilesPlotting, 'Enable', 'on');
% Load file into memory
if str2num(filenumber) == 1
    % This is exp 1.
else % Load other data from before
    data_n = md_GUI.data_n;
    mdata_n = md_GUI.mdata_n;
end

md_GUI.d_fn.(['exp', filenumber]) = fullfile(fullfilepath);
[dir, filename, ext] = fileparts(md_GUI.d_fn.(['exp', filenumber]));
file = fullfile(dir, filename);
% Check if a local md_defaults exists.
if exist(fullfile(dir, 'md_defaults.m'), 'file')
    % Local md_defaults exist. Check if system or local md_Defaults is to be used via radiobutton selection.
    md_def_setting = md_GUI.UI.UILoad.md_default_radiobuttongroup.SelectedObject.String;
    if strcmp(md_def_setting, 'System metadata default')
        % Use system md_Defaults.
        %Prompt user to select the substructs
        metadata.defaults.exp.EPICEA
        metadata.defaults.Laksman_TOF_e_XY. % Make it in correct order - see md defaults!
        [mdata_n.(['exp', filenumber])]  = IO.import_metadata(file);
    elseif strcmp(md_def_setting, 'Local metadata default')
        % Use local md_Defaults.
        [mdata_n.(['exp', filenumber])]  = IO.import_metadata(file);
    end
else % Local md_defaults does not exist. Use system md_Defaults.
    
end

[data_n.(['exp', filenumber])]   = IO.import_raw(file);


data_n.info.foi = fieldnames(md_GUI.d_fn);
data_n.info.numexps = length(data_n.info.foi);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % This one (below) makes all files load again - not only the selected one! 
% % Be careful with it since slows everything down considerably and risks
% % overheating if used many times for higher number of files.
%[data_n, exp_names] = macro.all(data_n, mdata_n);
% % This one (below) makes only the selected file load while keeping the rest in memory.
[data_n.(['exp', filenumber]), mdata_n.(['exp', filenumber])] = macro.all(data_n.(['exp', filenumber]), mdata_n.(['exp', filenumber])); % Look into data_n <-- 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
md_GUI.data_n = data_n;
md_GUI.mdata_n = mdata_n;
set(UIPlot.Popup_experiment_name, 'String', md_GUI.load.String_LoadedFiles);
md_GUI.mdata_n.(['exp', filenumber]).cond.nofilter = md_GUI.mdata_n.(['exp', filenumber]).cond;
md_GUI.mdata_n.(['exp', filenumber]).filepath = fullfilepath;
md_GUI.mdata_n.(['exp', filenumber]).dir = md_GUI.load.folder_name;
md_GUI.plot.expsettings.(['exp', filenumber]) = [2 1 1];
set(UILoad.UnLoadFileButton, 'Enable', 'on')
    %% Message to log_box - cell_to_be_inserted:
cell_to_be_inserted = ['File loaded: ', char(fileselected)];
[ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, cell_to_be_inserted );
md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
% End of new message to log_box function.
assignin('base', 'md_GUI', md_GUI)
disp('Log: Finished loading file.')
end