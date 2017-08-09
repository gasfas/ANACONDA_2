% Description: Selects which detector's data to use.
%   - inputs:
%           Experiment names                    (exp_names)
%           Experiment settings                 (expsettings)
%           Selected exp. number                (experiment_selected_number)
%           Selected experiment(s) data         (data_n)
%   - outputs:
%           Experiment settings                 (expsettings)
% Date of creation: 2017-07-10.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [] = Popup_detector_choice(hObject, eventdata, UILoad, UIPlot)
md_GUI = evalin('base', 'md_GUI');
guidata(hObject);
handles = guidata(hObject);
handles.filetype = get(hObject, 'String');
detector_selected_number = get(hObject, 'Val');
detector_selected = char(handles.filetype(detector_selected_number));
%% Message to log_box - cell_to_be_inserted:
cell_to_be_inserted = ['Detector selected: ', detector_selected];
[ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, cell_to_be_inserted );
md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
% End of new message to log_box function.
%%
set(UIPlot.Popup_plot_dimensions, 'Enable', 'on')
exp_names = md_GUI.plot.selected_exp_names;
exp_nom = md_GUI.plot.experiment_selected_number;
exp_selnum = exp_nom;
hitsevents = fieldnames(md_GUI.data_n.exp1);

if ischar(exp_names)
    exp_names = cellstr(exp_names);
end
if exp_selnum == 0 % User is defining metadata for ALL experiments at the same time.
    md_GUI.plot.expsettings.All(2) = detector_selected_number;
    hitseventsselnum = md_GUI.plot.expsettings.exp1;
    hitseventsselnum = hitseventsselnum(1);
    hitsevents = char(hitsevents(hitseventsselnum));
    if strcmp(detector_selected, 'raw')
        plottypes = {'raw_plot'};
    else
        plottypes = fieldnames(md_GUI.data_n.(char(exp_names(1))).(hitsevents).(detector_selected));
    end
    for lxzz = 1:length(exp_names)
        exp_name_def = exp_names(lxzz);
        md_GUI.plot.expsettings.(char(exp_name_def))(2) = detector_selected_number;
    end
else
    exp_name_def = exp_names(exp_selnum);
	md_GUI.plot.expsettings.(char(exp_name_def))(2) = detector_selected_number;
	hitseventsselnum = md_GUI.plot.expsettings.(char(exp_name_def));
    hitseventsselnum = hitseventsselnum(1);
    hitsevents = char(hitsevents(hitseventsselnum));
    plottypes = fieldnames(md_GUI.data_n.(char(exp_name_def)).(hitsevents).(detector_selected));
end
m2qcheck = 0;
if strcmp(detector_selected, 'raw')
    plottypes_Y = {'Intensity'};
else
    plottypes_Y(1) =  cellstr('Pre-defined');
    for lxz = 1:length(plottypes)
        plottypes_Y(lxz+1) = plottypes(lxz);
        % Try to find m2q.
        if strcmp('m2q', char(plottypes(lxz)))
            m2qcheck = lxz;
        end
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