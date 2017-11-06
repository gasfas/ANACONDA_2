% Description: Unloads the selected file from memory. 
%   - inputs: 
%           Experiment names                    (exp_names)
%           Loaded file number                  (filenumber_selected)
%           Number of loaded files in total     (NumberOfLoadedFiles)
%           Number of loaded files selected     (numberofloadedfilesselected)
%           Names of the loaded files           (String_LoadedFiles)
%           File data.                          (data_n)
%           File metadata.                      (mdata_n)
%   - outputs: 
%           Experiment names        (exp_names)
%           Name of loaded files    (String_LoadedFiles)
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
%Get the filenumber of the selected file - if exists.
if ~isempty(md_GUI.UI.UILoad.LoadedFiles.String)
    NumberOfLoadedFiles = length(md_GUI.UI.UILoad.LoadedFiles.String);
    String_LoadedFiles = md_GUI.UI.UILoad.LoadedFiles.String;
    for nn = (md_GUI.UI.UILoad.LoadedFiles.Value + 1):NumberOfLoadedFiles
        String_LoadedFiles(nn-1) = String_LoadedFiles(nn);
        md_GUI.data_n.(['exp', int2str(nn-1);]) = md_GUI.data_n.(['exp', int2str(nn)]);
        md_GUI.mdata_n.(['exp', int2str(nn-1);]) = md_GUI.mdata_n.(['exp', int2str(nn)]);
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
    if length(md_GUI.UI.UILoad.LoadedFiles.String) == 1
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
    else
        md_GUI.data_n = data_n_new;
        md_GUI.mdata_n = mdata_n_new;
        md_GUI.load.exp_names = exp_names_new;
        set(UILoad.LoadedFiles, 'String', String_LoadedFilesNew(nk));
        set(UIPlot.LoadedFilesPlotting, 'String', String_LoadedFilesNew(nk));
        set(UIPlot.LoadedFilesPlotting, 'String', '-');
    end
    set(UILoad.LoadedFiles, 'Value', 1);
    set(UIPlot.LoadedFilesPlotting, 'Value', 1);
    %% Message to log_box
	GUI.log.add(['File unloaded: exp', num2str(md_GUI.UI.UILoad.LoadedFiles.Value), ', ', char(md_GUI.UI.UILoad.LoadedFiles.String(md_GUI.UI.UILoad.LoadedFiles.Value))])
else
    %% Message to log_box
	GUI.log.add(['Load a file.'])
end
assignin('base', 'md_GUI', md_GUI)
end