% Description: Select what to plot. Abscissa.
%   - inputs: none.
%   - outputs:
%           Plot settings       	(plotsettings)
% Date of creation: 2017-07-10.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [] = Popup_graph_type_X(hObject, eventdata, UILoad, UIPlot)
md_GUI = evalin('base', 'md_GUI');
guidata(hObject);
handles = guidata(hObject);
handles.filetype = get(hObject, 'String');
graphtype_X_selected_number = get(hObject, 'Val');
md_GUI.plot.plotsettings(2) = graphtype_X_selected_number;
%% Message to log_box - cell_to_be_inserted:
cell_to_be_inserted = ['Abscissa: ', char(handles.filetype(graphtype_X_selected_number))];
[ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, cell_to_be_inserted );
md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
% End of new message to log_box function.
assignin('base', 'md_GUI', md_GUI);
end