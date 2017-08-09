% Description: Selects if the plot is to be on hits or events based data.
%   - inputs:
%           Experiment names                    (exp_names)
%           Selected exp. number                (experiment_selected_number)
%           Selected experiment(s) data         (data_n)
%   - outputs:
%           Experiment settings                 (expsettings)
% Date of creation: 2017-07-10.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ ] = Popup_Hits_or_Events(hObject, eventdata, UILoad, UIPlot)
md_GUI = evalin('base', 'md_GUI');
%Gives: Experiment type; hits or events. Can also show information about 
guidata(hObject);
handles = guidata(hObject);
handles.filetype = get(hObject, 'String');
hits_or_events_selected_number = get(hObject, 'Val');
selectedfield = char(handles.filetype(hits_or_events_selected_number));
%% Message to log_box - cell_to_be_inserted:
switch selectedfield
    case 'h'
        cell_to_be_inserted = ['hits selected.'];
    case 'e'
        cell_to_be_inserted = ['events selected.'];
end
[ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, cell_to_be_inserted );
md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
% End of new message to log_box function.
exp_nom = md_GUI.plot.experiment_selected_number;
exp_selnum = exp_nom;
if exp_nom == 0
    exp_nom = 1;
end
exps = md_GUI.data_n.(['exp', num2str(exp_nom)]);
if strcmp('info', selectedfield) %info will be shown
    information = exps.info;
    information_comment = information.comment; %in experimental data, exps.info field has a variable: comment - which contains experiment information.
    information_acq_start = information.acquisition_start_str;
    information_acq_dur = information.acquisition_duration;
    information_acq_dur = num2str(information_acq_dur);
    uiwait(msgbox({'File information comment:';information_comment;'Data acquisition start:';information_acq_start;'Data acquisition duration:';information_acq_dur} ,'About !','modal'));
    hits_or_events_selected_number = 2; % hits
    set(UIPlot.Popup_Hits_or_Events, 'Value', 2) % hits
end
hits_or_events_selected = char(handles.filetype(hits_or_events_selected_number));
experimenttype = exps.([hits_or_events_selected]);
experimenttype_fieldnames = fieldnames(experimenttype);
set(UIPlot.Popup_detector_choice, 'Enable', 'on')
set(UIPlot.Popup_detector_choice, 'String', experimenttype_fieldnames);
exp_names = md_GUI.plot.selected_exp_names;
if ischar(exp_names)
    exp_names = cellstr(exp_names);
end
if exp_selnum == 0 % User is defining metadata for ALL experiments at the same time.
    md_GUI.plot.expsettings.All(1) = hits_or_events_selected_number;
    detectornames = fieldnames(md_GUI.data_n.(char(exp_names(1))).(hits_or_events_selected));
    if strcmp(char(detectornames(1)), 'raw')
        detsel = detectornames(2);
        detnum = 2;
        set(UIPlot.Popup_detector_choice, 'Value', 2)
    else
        detsel = detectornames(1);
        detnum = 1;
        set(UIPlot.Popup_detector_choice, 'Value', 1)
    end
    for lxzz = 1:length(exp_names)
        exp_name_def = exp_names(lxzz);
        md_GUI.plot.expsettings.(char(exp_name_def))(1) = hits_or_events_selected_number;
        md_GUI.plot.expsettings.(char(exp_name_def))(2) = detnum;
    end
    plottypes = fieldnames(md_GUI.data_n.(char(exp_names(1))).(hits_or_events_selected).(char(detectornames(detnum))));
else
    exp_name_def = exp_names(exp_selnum);
    detectornames = fieldnames(md_GUI.data_n.(char(exp_names(1))).(hits_or_events_selected));
    if strcmp(char(detectornames(1)), 'raw')
        detsel = detectornames(2);
        detnum = 2;
        set(UIPlot.Popup_detector_choice, 'Value', 2)
    else
        detsel = detectornames(1);
        detnum = 1;
        set(UIPlot.Popup_detector_choice, 'Value', 1)
    end
    plottypes = fieldnames(md_GUI.data_n.(char(exp_name_def)).(hits_or_events_selected).(char(detsel)));
    md_GUI.plot.expsettings.(char(exp_name_def))(1) = hits_or_events_selected_number;
    md_GUI.plot.expsettings.(char(exp_name_def))(2) = detnum;
end
m2qcheck = 0;
plottypes_Y(1) =  cellstr('Pre-defined');
for lxz = 1:length(plottypes)
    plottypes_Y(lxz+1) = plottypes(lxz);
    % Try to find m2q.
    if strcmp('m2q', char(plottypes(lxz)))
        m2qcheck = lxz;
    end
end
if m2qcheck == 0
    m2qvalue = 1; % m2q plot non-existant. take first plot only, unless it is 'ifdo' which is not a plottype but a condition.
    if strcmp(char(plottypes(m2qvalue)), 'ifdo')
        m2qvalue = 2;
    end
else
    m2qvalue = m2qcheck; % m2q plot exists, set its value as pre-specified plot.
end
md_GUI.plot.plotsettings(2) = m2qvalue;
md_GUI.plot.plotsettings(3) = 1;
set(UIPlot.Popup_graph_type_X, 'String', plottypes)
set(UIPlot.Popup_graph_type_Y, 'String', plottypes_Y)
set(UIPlot.Popup_graph_type_X, 'Value', m2qvalue)
set(UIPlot.Popup_graph_type_Y, 'Value', 1)
assignin('base', 'md_GUI', md_GUI);
end