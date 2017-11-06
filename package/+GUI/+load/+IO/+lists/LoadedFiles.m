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
%           Number of selected files            (numberofloadedfilesselected)
% Date of creation: 2017-07-10.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

%% LoadedFiles function
function [ ] = LoadedFiles(hObject, eventdata, UILoad, UIPlot)
md_GUI = evalin('base', 'md_GUI');

%% Determine if it is in the load or plot tab:
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
            %% Message to log_box
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
        set(UIPlot.new.new_signal, 'Enable', 'on');
        set(UIPlot.new.edit_signal, 'Enable', 'on');
        set(UIPlot.new.remove_signal, 'Enable', 'on');
        set(UIPlot.new.signals_list, 'Enable', 'on');
        set(UIPlot.new.btn_set_x_sign_pointer, 'Enable', 'on');
        set(UIPlot.new.y_signals_checkbox, 'Enable', 'on');
        set(UIPlot.new.PopupPlotSelected, 'Enable', 'on')
        set(UIPlot.Popup_Filter_Selection, 'Enable', 'on')
        set(UIPlot.new.PlotButton, 'Enable', 'on')
        set(UIPlot.new.PlotConfButton, 'Enable', 'on')
        set(UIPlot.def.PlotConfEditButton, 'Enable', 'on')
        set(UIPlot.def.Popup_plot_type, 'Enable', 'on')
        set(UIPlot.def.PlotButton, 'Enable', 'on')

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
                currentplottypes = fieldnames(md_GUI.mdata_n.(current_exp_name).plot.(current_det_name));
                % remove possible 'ifdo' fields:
                currentplottypes(find(ismember(currentplottypes,'ifdo'))) = [];
                numberofplottypes = length(currentplottypes);

                % write dots between detectornames and fieldnames:
                popup_list_names_det = general.cell.pre_postscript_to_cellstring(currentplottypes, [hr_detname '.' ], '');
                plottypes_def(1,end+1:end+numberofplottypes) = currentplottypes;
                popup_list_names(1,end+1:end+numberofplottypes) = popup_list_names_det;
% 					general.cell.pre_postscript_to_cellstring(currentplottypes, [hr_detname '.' ], '')
%                     for lz = 1:numberofplottypes
%                         plottypes_def(end+1) = cellstr([current_det_name, '.' char(currentplottypes(lz))]);
%                     end
            end
        end
        expnum = 1;
        signals_list = fieldnames(md_GUI.mdata_n.([char(exp_names(expnum))]).plot.signal);
        
        %% Values for the different settings in the defined plots tab:
        set(UIPlot.new.signals_list, 'String', signals_list)
        set(UIPlot.def.Popup_plot_type, 'String', popup_list_names)
        set(UIPlot.def.Popup_plot_type, 'Value', 1)

        %% Values for the different settings in the new plots tab:
        set(UIPlot.Popup_Filter_Selection, 'String', Filters_string_name)
        set(UIPlot.new.PopupPlotSelected, 'String', {'Plot all in new figure together', 'Plot all separately', 'Plot selection into pre-existing figure'})
        set(UIPlot.Popup_Filter_Selection, 'Value', 1)
        set(UIPlot.new.PopupPlotSelected, 'Value', 1)
    end
    assignin('base', 'md_GUI', md_GUI)
end
end