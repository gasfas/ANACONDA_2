% Description: Selects which experiment(s) to configure.
%   - inputs:
%           Experiment names                    (exp_names)
%           Experiment filenumber selected      (filenumber_selected)
%           Filter tree information             (filter_fieldnames)
%   - outputs:
%           Filter selected             (filterpath)
%           Experiment settings         (expsettings)
% Date of creation: 2017-07-11.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ ] = Popup_Filter_Selection(hObject, eventdata, UILoad, UIPlot)
md_GUI = evalin('base', 'md_GUI');
%Gives: Experiment type; hits or events. Can also show information about 
guidata(hObject);
handles = guidata(hObject);
handles.filetype = get(hObject, 'String');
filter_selected_number = get(hObject, 'Val');
filter_selected = handles.filetype(filter_selected_number);
filter_selected = char(filter_selected);
%% Message to log_box - cell_to_be_inserted:
cell_to_be_inserted = ['Filter selected: ', filter_selected];
[ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, cell_to_be_inserted );
md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
% End of new message to log_box function.
newfilter_selected = strrep(filter_selected,'__','.');
exp_names = md_GUI.load.exp_names;
exp_nom = md_GUI.plot.experiment_selected_number;
exp_selnum = exp_nom;
if exp_selnum == 0 % User is defining metadata for ALL experiments at the same time.
    md_GUI.plot.expsettings.All(3) = filter_selected_number;
	md_GUI.plot.filterpath.All = newfilter_selected;
    for lxzz = 1:length(exp_names)
        exp_name_def = exp_names(lxzz);
        md_GUI.plot.expsettings.(char(exp_name_def))(3) = filter_selected_number;
        md_GUI.plot.filterpath.(char(exp_name_def)) = newfilter_selected;
    end
else
    exp_name_def = exp_names(exp_selnum);
    md_GUI.plot.expsettings.(char(exp_name_def))(3) = filter_selected_number;
    md_GUI.plot.filterpath.(char(exp_name_def)) = newfilter_selected;
end
assignin('base', 'md_GUI', md_GUI);
end