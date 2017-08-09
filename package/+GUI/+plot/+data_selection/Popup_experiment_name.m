% Description: Selects which experiment(s) to configure.
%   - inputs:
%           Experiment names                    (exp_names)
%           Experiment filenumber selected      (filenumber_selected)
%           Filter tree information             (filter_fieldnames)
%           Selected experiment(s) metadata     (mdata_n)
%           Selected experiment(s) data         (data_n)
%   - outputs:
%           Selected experiment number          (experiment_selected_number)
% Date of creation: 2017-07-10.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ ] = Popup_experiment_name(hObject, eventdata, UILoad, UIPlot)
md_GUI = evalin('base', 'md_GUI');
%Gives: Experiment selected, Experiment selected number
guidata(hObject);
handles = guidata(hObject);
handles.filetype = get(hObject, 'String');
experiment_selected_number = get(hObject, 'Val');
%% Message to log_box - cell_to_be_inserted:
cell_to_be_inserted = ['Experiment name selected: ', char(handles.filetype(experiment_selected_number))];
[ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, cell_to_be_inserted );
md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
% End of new message to log_box function.
experiment_selected_number = int64(experiment_selected_number - 1);
exp_names = md_GUI.load.exp_names;
filenumbers = md_GUI.plot.filenumber_selected;
if experiment_selected_number == 0
    filenumber = filenumbers(1);
else
    filenumber = filenumbers(experiment_selected_number);
end
md_GUI.plot.experiment_selected_number = experiment_selected_number;
%Loop over all experiment names if All Exps is selected, i.e. 
if experiment_selected_number == 0
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
else % One experiment is being modified. 
    exp_nomb = experiment_selected_number;
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
NoFilterString = 'nofilter';
Filters_string_name(1) = cellstr(NoFilterString);
if ischar(exp_names)
    exp_names = cellstr(exp_names);
end
if experiment_selected_number == 0 % means all are being defined - put values of first exp. only.
    valuesforpopups = md_GUI.plot.expsettings.(char(exp_names(1)));
    string_hits_or_events = fieldnames(md_GUI.data_n.(char(exp_names(1))));
    string_detector = fieldnames(md_GUI.data_n.(char(exp_names(1))).(char(string_hits_or_events(valuesforpopups(1)))));
    set(UIPlot.Popup_Hits_or_Events, 'String', string_hits_or_events)
    set(UIPlot.Popup_detector_choice, 'String', string_detector)
else
    valuesforpopups = md_GUI.plot.expsettings.(char(exp_names(experiment_selected_number)));
    string_hits_or_events = fieldnames(md_GUI.data_n.(char(exp_names(experiment_selected_number))));
    string_detector = fieldnames(md_GUI.data_n.(char(exp_names(experiment_selected_number))).(char(string_hits_or_events(valuesforpopups(1)))));
    set(UIPlot.Popup_Hits_or_Events, 'String', string_hits_or_events)
    set(UIPlot.Popup_detector_choice, 'String', string_detector)
end
set(UIPlot.Popup_Filter_Selection, 'String', Filters_string_name)
set(UIPlot.Popup_Hits_or_Events, 'Value', valuesforpopups(1))
set(UIPlot.Popup_detector_choice, 'Value', valuesforpopups(2))
set(UIPlot.Popup_Filter_Selection, 'Value', valuesforpopups(3))
%% Message to log_box - cell_to_be_inserted:
cell_to_be_inserted = ['Fieldvalues for [hits/events], [detectornumber] resp. [filternumber]: ', num2str(valuesforpopups)];
[ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, cell_to_be_inserted );
md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
% End of new message to log_box function.
%% Assign to base workspace.
assignin('base', 'md_GUI', md_GUI)
end