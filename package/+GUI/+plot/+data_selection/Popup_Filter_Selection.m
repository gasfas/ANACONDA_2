% Description: Selects which experiment(s) to configure.
%   - inputs:
%           Experiment names                    (exp_names)
%           Experiment filenumber selected      (filenumber_selected)
%           Filter tree information             (filter_fieldnames)
%   - outputs:
%           Filter selected             (filterpath)
% Date of creation: 2017-07-11.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ ] = Popup_Filter_Selection(hObject, eventdata, UILoad, UIPlot)
md_GUI = evalin('base', 'md_GUI');
% Gives: Experiment type; hits or events. Can also show information about 
guidata(hObject);
handles = guidata(hObject);
handles.filetype = get(hObject, 'String');
filter_selected_number = get(hObject, 'Val');
filter_selected = handles.filetype(filter_selected_number);
filter_selected = char(filter_selected);
% Message to log_box
GUI.log.add(['Filter selected: ', filter_selected])
newfilter_selected = strrep(filter_selected,'__','.');
exp_names = md_GUI.load.exp_names;
if ischar(exp_names); exp_names = {exp_names}; end
exp_nom = md_GUI.UI.UIPlot.LoadedFilesPlotting.Value;
if length(exp_nom) == 1 % User is defining metadata for ALL experiments at the same time.
    exp_name_def = exp_names(exp_nom);
    md_GUI.plot.expsettings.(char(exp_name_def))(3) = filter_selected_number;
    md_GUI.plot.filterpath.(char(exp_name_def)) = newfilter_selected;
else
    md_GUI.plot.expsettings.All(3) = filter_selected_number;
	md_GUI.plot.filterpath.All = newfilter_selected;
    for lxzz = 1:length(exp_names)
        exp_name_def = exp_names(lxzz);
        md_GUI.plot.expsettings.(char(exp_name_def))(3) = filter_selected_number;
        md_GUI.plot.filterpath.(char(exp_name_def)) = newfilter_selected;
    end
end
assignin('base', 'md_GUI', md_GUI);
end