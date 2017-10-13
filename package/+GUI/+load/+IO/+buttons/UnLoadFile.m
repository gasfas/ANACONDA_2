% Description: Unloads the selected file from memory. 
%   - inputs: 
%           Experiment names                    (exp_names)
%           Loaded file number                  (filenumber_selected)
%           Number of loaded files in total     (NumberOfLoadedFiles)
%           Number of loaded files selected     (numberofloadedfilesselected)
%           Names of the loaded files           (String_LoadedFiles)
%           File location + name                (d_fn)
%           File data.                          (data_n)
%           File metadata.                      (mdata_n)
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

%% UnLoadFile function
function [ ] = UnLoadFile(UILoad, UIPlot, UIFilter)
md_GUI = evalin('base', 'md_GUI');
UI = md_GUI.UI.UIFilter;
%Get the filenumber of the selected file - if exists.
if isfield(md_GUI.load, 'filenumber_selected')
    LoadedFileNumber = md_GUI.load.filenumber_selected; %multiselection available! -> Cell.
else
    LoadedFileNumber = 1;
end
%check how many files to unload. Now only support of one file to unload
%each time. Upgrade in future may support multi selection unload.
if isfield(md_GUI.load, 'numberofloadedfilesselected')
    numberoffilesselected = md_GUI.load.numberofloadedfilesselected;
else
    numberoffilesselected = 1;
end
%check how many files are loaded in total.
NumberOfLoadedFiles = md_GUI.load.NumberOfLoadedFiles;
%get the strings of the loaded files.
String_LoadedFiles = md_GUI.load.String_LoadedFiles;
if numberoffilesselected == 1
	%unload file.
    String_FileToUnload = String_LoadedFiles(LoadedFileNumber);
    for nn = (LoadedFileNumber + 1):NumberOfLoadedFiles
        filenumber_1 = nn-1;
        filenumber = nn;
        filenumber_1 = int2str(filenumber_1);
        filenumber = int2str(filenumber);
        md_GUI.d_fn.(['exp', filenumber_1]) = md_GUI.d_fn.(['exp', filenumber]);
        String_LoadedFiles(nn-1) = String_LoadedFiles(nn);
        md_GUI.data_n.(['exp', filenumber_1]) = md_GUI.data_n.(['exp', filenumber]);
        md_GUI.mdata_n.(['exp', filenumber_1]) = md_GUI.mdata_n.(['exp', filenumber]);
        md_GUI.load.exp_names(nn-1) = md_GUI.load.exp_names(nn);
    end
    %Remove last field (since all other fields have 'moved up 1 step')
    NumberOfLoadedFiles_str = int2str(NumberOfLoadedFiles);
    for nk = 1:(NumberOfLoadedFiles-1)
       String_LoadedFilesNew(nk) = String_LoadedFiles(nk);
       nkk = int2str(nk);
        data_n_new.(['exp', nkk]) = md_GUI.data_n.(['exp', nkk]);
        mdata_n_new.(['exp', nkk]) = md_GUI.mdata_n.(['exp', nkk]);
        exp_names_new(nk) = md_GUI.load.exp_names(nk);
    end
    % Check if there is more than one loaded files as of now.
    if length(String_LoadedFiles) == 1
        set(UILoad.LoadedFiles, 'Enable', 'off');
        set(UIPlot.new.y_signals_checkbox, 'Enable', 'off');
        set(UIPlot.new.signals_list, 'Enable', 'off');
        set(UIPlot.new.signals_list, 'String', '-');
        set(UIPlot.new.signals_list, 'Value', 1);
        set(UILoad.UnLoadFileButton, 'Enable', 'off');
        set(UIPlot.new.new_signal, 'Enable', 'off');
        set(UIPlot.new.remove_signal, 'Enable', 'off');
        set(UIPlot.new.edit_signal, 'Enable', 'off');
        set(UIPlot.def.PlotButton, 'Enable', 'off');
        set(UIPlot.def.Popup_plot_type, 'Enable', 'off');
        set(UIPlot.def.Popup_plot_type, 'String', '-');
        set(UIPlot.LoadedFilesPlotting, 'Enable', 'off');
        set(UIPlot.new.PopupPlotSelected, 'String', '-');
        set(UIPlot.new.PopupPlotSelected, 'Value', 1);
        set(UIPlot.new.PopupPlotSelected, 'Enable', 'off')
        set(UILoad.LoadedFiles, 'String', '-');
        set(UILoad.LoadedFiles, 'Enable', 'off');
        set(UIPlot.LoadedFilesPlotting, 'String', '-');
        set(UIPlot.LoadedFilesPlotting, 'Enable', 'off');
        set(UIPlot.new.PlotButton, 'Enable', 'off')
        set(UIPlot.Popup_Filter_Selection, 'Enable', 'off')
        set(UIPlot.Popup_Filter_Selection, 'String', '-')
        set(UIPlot.Popup_Filter_Selection, 'Value', 1)
        md_GUI.load = rmfield(md_GUI.load, 'String_LoadedFiles');
        md_GUI.load.filenumber_selected = 1;
    else
        String_LoadedFiles = String_LoadedFilesNew;
        md_GUI.data_n = data_n_new;
        md_GUI.mdata_n = mdata_n_new;
        md_GUI.load.exp_names = exp_names_new;
        md_GUI.load.String_LoadedFiles = String_LoadedFiles;
        set(UILoad.LoadedFiles, 'Value', 1);
        md_GUI.load.filenumber_selected = 1;
        set(UILoad.LoadedFiles, 'String', md_GUI.load.String_LoadedFiles);
        set(UIPlot.LoadedFilesPlotting, 'String', md_GUI.load.String_LoadedFiles);
        set(UILoad.LoadedFiles, 'Value', 1);
        set(UIPlot.LoadedFilesPlotting, 'Value', 1);
        set(UIPlot.LoadedFilesPlotting, 'String', '-');
    end
    if NumberOfLoadedFiles > 1
        md_GUI.d_fn = rmfield(md_GUI.d_fn, (['exp', NumberOfLoadedFiles_str]));
    end
    NumberOfLoadedFiles = NumberOfLoadedFiles - 1;
    md_GUI.load.NumberOfLoadedFiles = NumberOfLoadedFiles;
    set(UILoad.LoadedFiles, 'Value', 1);
else
	%Give message that this GUI version supports only one unload per time.
	msgbox('Select one file to unload.', 'Warning')
    disp('Select one file to unload.')
end
% Message to log_box - cell_to_be_inserted:
[ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, ['File unloaded: exp', num2str(LoadedFileNumber), ', ', char(String_FileToUnload)] );
md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
% End of new message to log_box function.
assignin('base', 'md_GUI', md_GUI)
end