% Description: A list that shows the loaded files. Two parts:
% One for the load tab and another for the plot tab. Defined by tabval. 
%   - inputs: 
%           GUI metadata
%           GUI tab name
%   - outputs: 
%           Selected file value
% Date of creation: 2017-07-10.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

% LoadedFiles function
function [ ] = LoadedFiles(hObject, eventdata, UILoad, UIPlot)
md_GUI = evalin('base', 'md_GUI');
% Determine if it is in the load or plot tab:
tabname = eventdata.Source.Parent.Title;
switch tabname
    case 'Load'
        tabval = 1;
        filenumber = md_GUI.UI.UILoad.LoadedFiles.Value;
        selectedloadedfiles = md_GUI.UI.UILoad.LoadedFiles.String(md_GUI.UI.UILoad.LoadedFiles.Value);
    case 'Plot'
        tabval = 2;
        filenumber = md_GUI.UI.UIPlot.LoadedFilesPlotting.Value;
        selectedloadedfiles = md_GUI.UI.UIPlot.LoadedFilesPlotting.String(md_GUI.UI.UIPlot.LoadedFilesPlotting.Value);
end
numberofloadedfilesselected = length(selectedloadedfiles);
if ~isempty(md_GUI.UI.UILoad.LoadedFiles.String)
    if numberofloadedfilesselected == 1
        filenumberstr = int2str(filenumber);
        exps = md_GUI.data_n.(['exp', filenumberstr]);
        if tabval == 1 % Load tab
            % Message to log_box
            GUI.log.add(['Loaded file selected: exp', filenumberstr])
            try % Try to get information of experiment:
                information = exps.info;
                information_acq_start = information.acquisition_start_str;
                information_acq_dur = information.acquisition_duration;
                information_acq_dur = num2str(information_acq_dur);
                information_comment = information.comment; %in experimental data, exps.info field has a variable: comment - which contains experiment information.
                informationbox = sprintf(['Selected file information: \n', char(selectedloadedfiles), '\nExperiment: exp', filenumberstr, '\n\nFile information comment: \n', information_comment,'\nData acquisition start: \n',information_acq_start,'\nData acquisition duration: \n',information_acq_dur]);
            catch
                informationbox = sprintf(['Selected file information: \n', char(selectedloadedfiles), '\nExperiment: exp', filenumberstr, '\nNo info found.']);
            end
            set(UILoad.SelectedFileInformation, 'String', informationbox);
        elseif tabval == 2 % Plot tab
            sel_load(1) = cellstr('All');
            for lx = 1:length(selectedloadedfiles)
                sel_load(lx + 1) = selectedloadedfiles(lx);
            end
        end
    else
        if tabval == 2
            filenom = filenumber(1);
            filenumberstr = int2str(filenom);
            exps = md_GUI.data_n.(['exp', filenumberstr]);
            sel_load(1) = cellstr('All');
            for lx = 1:length(selectedloadedfiles)
                sel_load(lx + 1) = selectedloadedfiles(lx);
            end
            selectedloadedfiles = sel_load;
        end
    end
    if tabval == 2
        set(UIPlot.new.save_plot_conf, 'Enable', 'on');
        set(UIPlot.new.edit_plot_conf, 'Enable', 'on');
        set(UIPlot.new_signal.duplicate_signal, 'Enable', 'on');
        set(UIPlot.new.signals_list, 'Enable', 'on');
        set(UIPlot.new_signal.signals_list, 'Enable', 'on');
        set(UIPlot.new.btn_set_x_sign_pointer, 'Enable', 'on');
        set(UIPlot.new.y_signals_checkbox, 'Enable', 'on');
        set(UIPlot.Popup_Filter_Selection, 'Enable', 'on')
        set(UIPlot.new.PlotButton, 'Enable', 'on')
        set(UIPlot.def.PlotConfEditButton, 'Enable', 'on')
        set(UIPlot.def.Popup_plot_type, 'Enable', 'on')
        set(UIPlot.def.pre_def_plot_radiobutton_built_in, 'Enable', 'on')
        set(UIPlot.def.pre_def_plot_radiobutton_customized, 'Enable', 'on')
        set(UIPlot.def.PlotButton, 'Enable', 'on')
        set(UIPlot.def.PlotConfDuplButton, 'Enable', 'on')
        set(UIPlot.new.x_signal_pointer, 'String', '-')
        set(UIPlot.new.y_signal_pointer, 'String', '-')
        set(UIPlot.def.pre_def_plot_radiobutton_built_in, 'Value', 1);
        set(UIPlot.new.signals_radiobutton_built_in, 'Value', 1);
        set(UIPlot.new.y_signals_checkbox, 'Value', 0);
        set(UIPlot.new.btn_set_y_sign_pointer, 'Enable', 'off');
        set(md_GUI.UI.UIPlot.new_signal.signals_radiobutton_built_in, 'Value', 1);
        if UIPlot.new_signal.signals_radiobutton_built_in.Value == 1
            GUI.plot.data_selection.Radiobutton_PreDef_Signal;
        elseif UIPlot.new_signal.signals_radiobutton_customized.Value == 1
            GUI.plot.data_selection.Radiobutton_Custom_Signal;
        end
        if UIPlot.new.signals_radiobutton_built_in.Value == 1
            GUI.plot.data_selection.Radiobutton_PreDef_PlotConf_New;
        elseif UIPlot.new.signals_radiobutton_customized.Value == 1
            GUI.plot.data_selection.Radiobutton_Custom_PlotConf_New;
        end
        if numberofloadedfilesselected > 1
            for lx = 1:numberofloadedfilesselected
                exp_names(lx) = cellstr(['exp', int2str(filenumber(lx))]);
            end
        elseif numberofloadedfilesselected == 1
            exp_names = ['exp', int2str(filenumber)];
        end
        
        if ischar(exp_names)
            exp_name = exp_names;
        else
            exp_name = char(exp_names(1));
        end
        Filters_Struct = md_GUI.mdata_n.(exp_name).cond;
        filter_fieldnames = general.struct.fieldnamesr(Filters_Struct);
        % Get maximum depth of filters struct:
        maxdepth = 1;
        for lxx = 1:length(filter_fieldnames)
            depth = length(strsplit(char(filter_fieldnames(lxx)), '.'));
            if depth > maxdepth
                maxdepth = depth;
            end
        end
        % Get all filters and combined filters - one by one:
        for alldepths = 1:maxdepth
            filter_allfieldnamesstructs.(['s', num2str(alldepths)]) = general.struct.fieldnamesr(Filters_Struct, alldepths);
        end
        for alldepths = 1:maxdepth
            filter_allfieldnamesmaxdepthstruct = filter_allfieldnamesstructs.(['s', num2str(alldepths)]);
            for depthx = 1:length(filter_allfieldnamesmaxdepthstruct)
                if exist('filter_allfieldnames')
                    nextf = length(filter_allfieldnames) + 1;
                else
                    nextf = 1;
                end
                filter_allfieldnames(nextf) = filter_allfieldnamesmaxdepthstruct(depthx);
            end
        end
        filter_fieldnames = filter_allfieldnames;

        for sdff = 2:(length(filter_fieldnames) + 1)
            Filters_string_name(sdff) = filter_fieldnames(sdff-1);
        end
        NoFilterString = 'No_Filter';
        Filters_string_name(1) = cellstr(NoFilterString);
        %% Experiment names:
        if ischar(exp_names)
            exp_names = cellstr(exp_names);
        end
        %% Plot types for defined plots tab:
        plottypes_def = {}; 
        popup_list_names = {};
        for lx = 1:length(exp_names)
            current_exp_name = char(exp_names(lx));
            % Get number of detectors.
            detector_choices = fieldnames(md_GUI.mdata_n.(current_exp_name).det);
            if ischar(detector_choices)
                numberofdetectors = 1;
                detector_choices = cellstr(detector_choices);
            else
                numberofdetectors = length(detector_choices);
            end
            for ly = 1:numberofdetectors
                current_det_name = char(detector_choices(ly));
                detnr			 = IO.detname_2_detnr(current_det_name);
                % Find a human-readable detector name:
                hr_detname		= md_GUI.mdata_n.(current_exp_name).spec.det_modes{detnr};
                if      UIPlot.def.pre_def_plot_radiobutton_built_in.Value == 1
                    currentplottypes = fieldnames(md_GUI.mdata_n.(current_exp_name).plot.(current_det_name));
                elseif  UIPlot.def.pre_def_plot_radiobutton_customized.Value == 1
                    try
                        currentplottypes = fieldnames(md_GUI.mdata_n.(current_exp_name).plot.user.(current_det_name));
                    catch
                        currentplottypes = cellstr('');
                    end
                end
                % remove possible 'ifdo' fields:
                currentplottypes(find(ismember(currentplottypes,'ifdo'))) = [];
                numberofplottypes = length(currentplottypes);

                % write dots between detectornames and fieldnames:
                if strcmp(currentplottypes, '')
                    popup_list_names = cellstr('');
                else
                    popup_list_names_det = general.cell.pre_postscript_to_cellstring(currentplottypes, [hr_detname '.' ], '');
                    plottypes_def(1,end+1:end+numberofplottypes) = currentplottypes;
                    popup_list_names(1,end+1:end+numberofplottypes) = popup_list_names_det;
% 					 general.cell.pre_postscript_to_cellstring(currentplottypes, [hr_detname '.' ], '')
%                    for lz = 1:numberofplottypes
%                        plottypes_def(end+1) = cellstr([current_det_name, '.' char(currentplottypes(lz))]);
%                    end
                end
            end            
            if length(exp_names) > 1
                list_struct.([char(exp_names(lx))]) = popup_list_names_det;
            end
            signals_list_struct.([char(exp_names(lx))]) = fieldnames(md_GUI.mdata_n.([char(exp_names(lx))]).plot.signal);
        end
        if length(exp_names) > 1 % check so that all exps have plot confs:
            value_conf = 0;
            value_signals = 0;
            for llz = 1:length(exp_names)
                if length(list_struct.([char(exp_names(llz))])) > 0
                    value_conf = value_conf + 1;
                end
                if length(signals_list_struct.([char(exp_names(llz))])) > 0
                    value_signals = value_signals + 1;
                end
            end
            popup_list_names = cellstr('');
            signals_list = GUI.general_functions.CommonFields(signals_list_struct);
            if value_conf > length(exp_names)-1 % Do the fields comparison.
                popup_list_names = GUI.general_functions.CommonFields(list_struct);
            else % At least one exp has zero fields - do nothing.
                GUI.log.add(['At least one experiment has no pre-defined plots for selected plot setting.'])
            end
        else
            signals_list = fieldnames(md_GUI.mdata_n.([char(exp_names(1))]).plot.signal);
        end
        %% Values for the different settings in the defined plots tab:
        set(UIPlot.new.signals_list, 'String', signals_list)
        if isempty(popup_list_names) || length(popup_list_names) == 1
            if strcmp(popup_list_names, '')
                set(UIPlot.def.Popup_plot_type, 'String', {' - '})
                set(UIPlot.def.Popup_plot_type, 'Enable', 'off')
            else
                set(UIPlot.def.Popup_plot_type, 'String', popup_list_names)
                set(UIPlot.def.Popup_plot_type, 'Enable', 'on')
            end
        else
            set(UIPlot.def.Popup_plot_type, 'String', popup_list_names)
            set(UIPlot.def.Popup_plot_type, 'Enable', 'on')
        end
        set(UIPlot.def.Popup_plot_type, 'Value', 1)
        %% Values for the different settings in the new plots tab:
        set(UIPlot.Popup_Filter_Selection, 'String', Filters_string_name)
        set(UIPlot.Popup_Filter_Selection, 'Value', 1)
    end
    assignin('base', 'md_GUI', md_GUI)
end
end