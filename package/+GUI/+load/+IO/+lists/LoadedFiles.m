% Description: A list that shows the loaded files. Two parts:
% One for the load tab and another for the plot tab. Defined by tabval. 
%% For the load tab: 
%   - inputs: 
%           Selected loaded file data           (selectedloadedfiles, data_n.exp#)
%           Number of selected loaded files     (filenumber_selected)
%   - outputs: 
%           Selected loaded file                (selectedloadedfiles)
%           Selected filenumber                 (filenumber)
%           Number of selected files            (numberofloadedfilesselected)
%% For the plot tab:
%   - inputs: 
%           Selected loaded files               (selectedloadedfiles)
%           Filter tree nodes information       (filter_fieldnames)
%           Experiment names                    (exp_names)
%   - outputs: 
%           Selected loaded file                (selectedloadedfiles)
%           Selected filenumber                 (filenumber)
%           Selected experiment names           (selected_exp_names)
%           Plotsettings                        (plotsettings)
%           Experiment settings                 (expsettings.(expname))
%           Number of selected files            (numberofloadedfilesselected)
% Date of creation: 2017-07-10.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

%% LoadedFiles function
function [ ] = LoadedFiles(hObject, eventdata, UILoad, UIPlot)
md_GUI = evalin('base', 'md_GUI');
%% Get all selected objects
guidata(hObject);
handles = guidata(hObject);
handles.filetype = get(hObject, 'String');
filenumber = get(hObject, 'Val');
selectedloadedfiles = handles.filetype(filenumber);
%% Determine if it is in the load or plot tab:
tabname = eventdata.Source.Parent.Title;
switch tabname
    case 'Load'
        tabval = 1;
    case 'Plot'
        tabval = 2;
end
[numberofloadedfilesselected, ~] = size(selectedloadedfiles);
if md_GUI.load.NumberOfLoadedFiles > 0
    if numberofloadedfilesselected == 0 

        set(UIPlot.Popup_experiment_name, 'Enable', 'off');
        set(UIPlot.Popup_detector_choice, 'Enable', 'off')
        set(UIPlot.Popup_plot_dimensions, 'Enable', 'off')
        set(UIPlot.Popup_graph_type_X, 'Enable', 'off')
        set(UIPlot.Popup_graph_type_Y, 'Enable', 'off')
        set(UIPlot.PopupPlotSelected, 'Enable', 'off')
        set(UIPlot.Popup_Hits_or_Events, 'Enable', 'off')
        set(UIPlot.Popup_Filter_Selection, 'Enable', 'off')
        set(UIPlot.Popup_Filter_Selection, 'Enable', 'off')
        set(UIPlot.PlotButton, 'Enable', 'off')
        set(UIPlot.PlotConfButton, 'Enable', 'off')
        
        
        disp('Select a file. Until then, last selected file(s) will continue being selected. Last loaded file was ')
        selectedloadedfiles = md_GUI.load.selectedloadedfiles;
        disp(selectedloadedfiles)
        disp('which is ')



        exp_names = md_GUI.load.exp_names;
        disp(exp_names)
        disp('in the GUI workspace.')
        % Basically does nothing but shows last selected file.
    else
        md_GUI.load.selectedloadedfiles = selectedloadedfiles;
        % Multi selection not yet available.
        md_GUI.load.numberofloadedfilesselected = numberofloadedfilesselected;
        % Show the selected file's information
        %Get the data:
        if numberofloadedfilesselected == 1
            filenumberstr = int2str(filenumber);
            exps = md_GUI.data_n.(['exp', filenumberstr]);
            if tabval == 1 % Load tab
                %% Message to log_box - cell_to_be_inserted:
                cell_to_be_inserted = ['Loaded file selected: exp', filenumberstr];
                [ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, cell_to_be_inserted );
                md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
                % End of new message to log_box function.
                selectedloadedfiles_str = char(selectedloadedfiles);
                filesextratext = 'Selected file information: \n';
                %Try to see if experiment has any information:
                try exps.info
                    information = exps.info;
                    information_acq_start = information.acquisition_start_str;
                    information_acq_dur = information.acquisition_duration;
                    information_acq_dur = num2str(information_acq_dur);
                    information_comment = information.comment; %in experimental data, exps.info field has a variable: comment - which contains experiment information.
                    informationbox = sprintf([filesextratext, selectedloadedfiles_str, '\nExperiment: exp', filenumberstr, '\n\nFile information comment: \n', information_comment,'\nData acquisition start: \n',information_acq_start,'\nData acquisition duration: \n',information_acq_dur]);
                catch
                    informationbox = sprintf([filesextratext, selectedloadedfiles_str, '\nExperiment: exp', filenumberstr]);
                end
                set(UILoad.SelectedFileInformation, 'String', informationbox);
                md_GUI.load.filenumber_selected = filenumber;
            elseif tabval == 2 % Plot tab
                md_GUI.plot.filenumber_selected = filenumber;
                % Get the selected objects out from this function and prepare them for plotting.
                sel_load(1) = cellstr('All');
                for lx = 1:length(selectedloadedfiles)
                    sel_load(lx + 1) = selectedloadedfiles(lx);
                end
                selectedloadedfiles = sel_load;
            end
        else
            if tabval == 2
                md_GUI.plot.filenumber_selected = filenumber;
                filenom = filenumber(1);
                filenumberstr = int2str(filenom);
                exps = md_GUI.data_n.(['exp', filenumberstr]);
                selectedloadedfiles_str = char(selectedloadedfiles(1));
                sel_load(1) = cellstr('All');
                for lx = 1:length(selectedloadedfiles)
                    sel_load(lx + 1) = selectedloadedfiles(lx);
                end
                selectedloadedfiles = sel_load;
            end
        end
        if tabval == 2
            set(UIPlot.Popup_experiment_name, 'Enable', 'on');
            set(UIPlot.Popup_detector_choice, 'Enable', 'on')
            set(UIPlot.Popup_plot_dimensions, 'Enable', 'on')
            set(UIPlot.Popup_graph_type_X, 'Enable', 'on')
            set(UIPlot.Popup_graph_type_Y, 'Enable', 'on')
            set(UIPlot.PopupPlotSelected, 'Enable', 'on')
            set(UIPlot.Popup_Hits_or_Events, 'Enable', 'on')
            set(UIPlot.Popup_Filter_Selection, 'Enable', 'on')
            set(UIPlot.Popup_Filter_Selection, 'Enable', 'on')
            set(UIPlot.PlotButton, 'Enable', 'on')
            set(UIPlot.PlotConfButton, 'Enable', 'on')

            m2qcheck = 0;
            % Get all field values and set them as ' 2 1 1 ':
            for lzz = 1:length(filenumber)
                expname(lzz) = cellstr(['exp', num2str(filenumber(lzz))]);
                hits_evs(lzz, :) = cellstr(fieldnames(md_GUI.data_n.([char(expname(lzz))])));
                detectornum(lzz, :) = cellstr(fieldnames(md_GUI.data_n.([char(expname(lzz))]).(char(hits_evs(lzz, 2)))));
                % Set 
                plottypes(lzz, :) = fieldnames(md_GUI.mdata_n.([char(expname(lzz))]).plot.(char(detectornum(1, 1))));
                plottypes_Y(lzz, 1) =  cellstr('Pre-defined');
                for lxz = 1:length(plottypes(lzz, :))
                    plottypes_Y(lzz, lxz+1) = plottypes(lzz, lxz);
                    % Try to find m2q.
                    if strcmp('m2q', char(plottypes(lzz, lxz)))
                        m2qcheck = lxz;
                    end
                end
            end

            if m2qcheck == 0
                m2qvalue = 1; % m2q plot non-existant. take first plot only.
            else
                m2qvalue = m2qcheck; % m2q plot exists, set its value as pre-specified plot.
            end
            md_GUI.plot.plotsettings(2) = m2qvalue;
            if numberofloadedfilesselected > 1
                for lx = 1:numberofloadedfilesselected
                exp_names(lx) = cellstr(['exp', int2str(filenumber(lx))]);
                end
            elseif numberofloadedfilesselected == 1
                exp_names = ['exp', int2str(filenumber)];
            end
            md_GUI.plot.selected_exp_names = exp_names;

            % Set filter options for 'All' selected experiments. Default: No filter, value 1.
            for exp_nomb = 1:length(cellstr(exp_names))
                exp_nomb_str = num2str(exp_nomb);
                Filters_string.(['exp', exp_nomb_str, '_cond']) = md_GUI.mdata_n.(['exp', exp_nomb_str]).cond;
                Filters_string_str_1 = fieldnames(Filters_string.(['exp', exp_nomb_str, '_cond']));
                for sf_1 = 1:length(Filters_string_str_1)
                    Filters_string_str_1_str = char(Filters_string_str_1(sf_1));
                    sff_1(sf_1)  = isstruct(Filters_string.(['exp', exp_nomb_str, '_cond']).(Filters_string_str_1_str));
                    if sff_1(sf_1) == 0
                        Filters_string.(['numb_', num2str(exp_nomb), '_', num2str(sf_1)]) = Filters_string_str_1_str;
                    else
                        Filters_string_str_2 = fieldnames(Filters_string.(['exp', exp_nomb_str, '_cond']).(Filters_string_str_1_str));
                        for sf_2 = 1:length(Filters_string_str_2)
                            Filters_string_str_2_str = char(Filters_string_str_2(sf_2));
                            sff_2(sf_2)  = isstruct(Filters_string.(['exp', exp_nomb_str, '_cond']).(Filters_string_str_1_str).(Filters_string_str_2_str));
                            if sff_2(sf_2) == 0
                                Filters_string.names.([Filters_string_str_1_str]) = Filters_string_str_1_str;
                                Filters_string.(['numb_', num2str(exp_nomb), '_',  num2str(sf_2)]) = Filters_string_str_2_str;
                            else
                                Filters_string.names.([Filters_string_str_1_str]) = Filters_string_str_1_str;
                                Filters_string.(['numb_', num2str(exp_nomb), '_',  num2str(sf_2)]) = Filters_string_str_2_str;

                                Filters_string_str_3 = fieldnames(Filters_string.(['exp', exp_nomb_str, '_cond']).(Filters_string_str_1_str).(Filters_string_str_2_str));
                                for sf_3 = 1:length(Filters_string_str_3)
                                    Filters_string_str_3_str = char(Filters_string_str_3(sf_3));
                                    sff_3(sf_3)  = isstruct(Filters_string.(['exp', exp_nomb_str, '_cond']).(Filters_string_str_1_str).(Filters_string_str_2_str).(Filters_string_str_3_str));
                                    if sff_3(sf_3) == 0
                                        Filters_string.names.([Filters_string_str_1_str, '__', Filters_string_str_2_str]) = Filters_string_str_2_str;
                                        Filters_string.(['numb_', num2str(exp_nomb), '_',  num2str(sf_3)]) = Filters_string_str_3_str;
                                    else
                                        Filters_string_str_4 = fieldnames(Filters_string.(['exp', exp_nomb_str, '_cond']).(Filters_string_str_1_str).(Filters_string_str_2_str).(Filters_string_str_3_str));
                                        for sf_4 = 1:length(Filters_string_str_4)
                                            Filters_string_str_4_str = char(Filters_string_str_4(sf_4));
                                            sff_4(sf_4)  = isstruct(Filters_string.(['exp', exp_nomb_str, '_cond']).(Filters_string_str_1_str).(Filters_string_str_2_str).(Filters_string_str_3_str).(Filters_string_str_4_str));
                                            if sff_4(sf_4) == 0
                                                Filters_string.names.([Filters_string_str_1_str, '__', Filters_string_str_2_str, '__', Filters_string_str_3_str]) = Filters_string_str_3_str;
                                                Filters_string.(['numb_', num2str(exp_nomb), '_',  num2str(sf_4)]) = Filters_string_str_4_str;
                                            else
                                                Filters_string_str_5 = fieldnames(Filters_string.(['exp', exp_nomb_str, '_cond']).(Filters_string_str_1_str).(Filters_string_str_2_str).(Filters_string_str_3_str).(Filters_string_str_4_str));
                                                for sf_5 = 1:length(Filters_string_str_5)
                                                    Filters_string_str_5_str = char(Filters_string_str_5(sf_5));
                                                    sff_5(sf_5)  = isstruct(Filters_string.(['exp', exp_nomb_str, '_cond']).(Filters_string_str_1_str).(Filters_string_str_2_str).(Filters_string_str_3_str).(Filters_string_str_4_str).(Filters_string_str_5_str));
                                                    if sff_5(sf_5) == 0
                                                        Filters_string.names.([Filters_string_str_1_str, '__', Filters_string_str_2_str, '__', Filters_string_str_3_str, '__', Filters_string_str_4_str]) = Filters_string_str_4_str;
                                                        Filters_string.(['numb_', num2str(exp_nomb), '_',  num2str(sf_5)]) = Filters_string_str_5_str;
                                                    else
                                                        disp('uh-oh..')
                                                        % Now all until 5th level have
                                                        % fieldnames separated by : __
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            filter_fieldnames = fieldnames(Filters_string.names);
            for sdff = 2:(length(filter_fieldnames) + 1)
                Filters_string_name(sdff) = filter_fieldnames(sdff-1);
            end
            NoFilterString = 'No_Filter';
            Filters_string_name(1) = cellstr(NoFilterString);

            if ischar(exp_names)
                exp_names = cellstr(exp_names);
            end
            valuesforpopups = md_GUI.plot.expsettings.(char(exp_names(1))); % Just set values of first sel. exp.
            md_GUI.plot.experiment_selected_number = 0;
            set(UIPlot.Popup_Filter_Selection, 'String', Filters_string_name)
            set(UIPlot.Popup_experiment_name, 'String', selectedloadedfiles);
            set(UIPlot.Popup_Hits_or_Events, 'String', hits_evs(1, :))
            set(UIPlot.Popup_detector_choice, 'String', detectornum(1, :))
            set(UIPlot.Popup_graph_type_X, 'String', plottypes(1, :))
            set(UIPlot.Popup_graph_type_Y, 'String', plottypes_Y(1, :))
            set(UIPlot.PopupPlotSelected, 'String', {'Plot all in new figure together', 'Plot all separately', 'Plot selection into pre-existing figure'})
            set(UIPlot.Popup_Filter_Selection, 'Value', 1)
            set(UIPlot.Popup_experiment_name, 'Value', 1);
            set(UIPlot.Popup_detector_choice, 'Value', valuesforpopups(2))
            set(UIPlot.Popup_plot_dimensions, 'Value', 1)
            set(UIPlot.Popup_graph_type_X, 'Value', m2qvalue)
            set(UIPlot.Popup_graph_type_Y, 'Value', 1)
            set(UIPlot.PopupPlotSelected, 'Value', 1)
            set(UIPlot.Popup_Filter_Selection, 'Value', 1)
            set(UIPlot.Popup_Hits_or_Events, 'Value', valuesforpopups(1))
            set(UIPlot.Popup_Filter_Selection, 'Value', valuesforpopups(3))
        end
    end
    assignin('base', 'md_GUI', md_GUI)
end
end