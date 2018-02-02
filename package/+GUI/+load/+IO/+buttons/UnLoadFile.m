% Description: Unloads the selected file from memory. 
%   - inputs: 
%       Location of experimental data file (folder name, fullfilepath)
%       Experimental data file
%       Ev. associated experimental metadata file
%   - outputs: 
%       Experimental data       (data_n)
%       Experimental metadata   (mdata_n)
% Date of creation: 2017-07-10.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

%% UnLoadFile function
function [ ] = UnLoadFile(UILoad, UIPlot, UIFilter)
md_GUI = evalin('base', 'md_GUI');
if ~isempty(md_GUI.UI.UILoad.LoadedFiles.String)
    String_LoadedFiles = md_GUI.UI.UILoad.LoadedFiles.String;
    Val_Files2Unload = md_GUI.UI.UILoad.LoadedFiles.Value; % These will be unloaded.
    NumberOfLoadedFiles = length(md_GUI.UI.UILoad.LoadedFiles.String);
    newNumberOfLoadedFiles = NumberOfLoadedFiles - length(Val_Files2Unload);
    exps = fieldnames(md_GUI.mdata_n);
    String_Exps2Unload = exps(Val_Files2Unload);
    expnum = 0;
    null = 1;
    for nnx = 1:NumberOfLoadedFiles
        TF = contains(String_Exps2Unload, char(exps(nnx)));
        if sum(TF) == 0 % Then the exp will not be unloaded -> has to remain in memory; copy it.
            expnum = expnum + 1;
            String_Files2Keep(expnum) = String_LoadedFiles(nnx);
            data_n_new.(['exp', int2str(expnum);]) = md_GUI.data_n.(['exp', int2str(nnx)]);
            mdata_n_new.(['exp', int2str(expnum);]) = md_GUI.mdata_n.(['exp', int2str(nnx)]);
            exp_names_new = md_GUI.load.exp_names(nnx);
            null = 0;
        end
    end
    % If there are no more files to unload - reset GUI parameters.
    if null == 0
        md_GUI.data_n = data_n_new;
        md_GUI.mdata_n = mdata_n_new;
        md_GUI.load.exp_names = exp_names_new;
        set(UILoad.LoadedFiles, 'String', String_Files2Keep);
        set(UIPlot.LoadedFilesPlotting, 'String', String_Files2Keep);
    else
        set(UILoad.LoadedFiles, 'Enable', 'off');
        set(UIPlot.new.y_signals_checkbox, 'Enable', 'off');
        set(UIPlot.new.signals_list, 'Enable', 'off');
        set(UIPlot.new.signals_list, 'String', '-');
        set(UIPlot.new.signals_list, 'Value', 1);
        set(UIPlot.new_signal.signals_list, 'Enable', 'off');
        set(UIPlot.new_signal.signals_list, 'String', '-');
        set(UIPlot.new_signal.signals_list, 'Value', 1);
        set(UILoad.UnLoadFileButton, 'Enable', 'off');
        set(UIPlot.new.save_plot_conf, 'Enable', 'off');
        set(UIPlot.new.edit_plot_conf, 'Enable', 'off');
        set(UIPlot.new_signal.new_signal, 'Enable', 'off');
        set(UIPlot.new_signal.edit_signal, 'Enable', 'off');
        set(UIPlot.new_signal.remove_signal, 'Enable', 'off');
        set(UIPlot.def.PlotButton, 'Enable', 'off');
        set(UIPlot.def.Popup_plot_type, 'Enable', 'off');
        set(UIPlot.def.pre_def_plot_radiobutton_customized, 'Enable', 'off');
        set(UIPlot.def.pre_def_plot_radiobutton_customized, 'Enable', 'off');
        set(UIPlot.def.Popup_plot_type, 'String', '-');
        set(UIPlot.LoadedFilesPlotting, 'Enable', 'off');
        set(UILoad.LoadedFiles, 'String', '-');
        set(UILoad.LoadedFiles, 'Enable', 'off');
        set(UIPlot.LoadedFilesPlotting, 'String', '-');
        set(UIPlot.LoadedFilesPlotting, 'Enable', 'off');
        set(UIPlot.new.PlotButton, 'Enable', 'off');
        set(UIPlot.Popup_Filter_Selection, 'Enable', 'off');
        set(UIPlot.Popup_Filter_Selection, 'String', '-');
        set(UIPlot.Popup_Filter_Selection, 'Value', 1);
        set(UIPlot.def.PlotConfDuplButton, 'Enable', 'off');
    end
    set(UILoad.LoadedFiles, 'Value', 1);
    set(UIPlot.LoadedFilesPlotting, 'Value', 1);
    %% Message to log_box
	GUI.log.add(['File unloaded: exp', num2str(md_GUI.UI.UILoad.LoadedFiles.Value), ', ', char(md_GUI.UI.UILoad.LoadedFiles.String(md_GUI.UI.UILoad.LoadedFiles.Value))])
else
    %% Message to log_box
	GUI.log.add(['Load a file.'])
end
if ~isempty(md_GUI.UI.UILoad.LoadedFiles)
    exps = md_GUI.data_n.exp1;
    try % Try to get information of experiment 1:
        information = exps.info;
        information_acq_start = information.acquisition_start_str;
        information_acq_dur = information.acquisition_duration;
        information_acq_dur = num2str(information_acq_dur);
        information_comment = information.comment; %in experimental data, exps.info field has a variable: comment - which contains experiment information.
        informationbox = sprintf(['Selected file information: \n', char(md_GUI.UI.UILoad.LoadedFiles.String(1)), '\nExperiment: exp1', '\n\nFile information comment: \n', information_comment,'\nData acquisition start: \n',information_acq_start,'\nData acquisition duration: \n',information_acq_dur]);
    catch
        informationbox = sprintf(['Selected file information: \n', char(md_GUI.UI.UILoad.LoadedFiles.String(1)), '\nExperiment: exp1', '\nNo info found.']);
    end
    set(UILoad.SelectedFileInformation, 'String', informationbox);
end
md_GUI.UI.UIPlot.def.Popup_plot_type.Value = 1;
assignin('base', 'md_GUI', md_GUI)
end