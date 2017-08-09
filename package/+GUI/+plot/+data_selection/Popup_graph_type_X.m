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
guidata(hObject)
disp('Object marked in exp popup')
handles = guidata(hObject);
handles.filetype = get(hObject, 'String');
graphtype_X_selected_number = get(hObject, 'Val');
md_GUI.plot.plotsettings(2) = graphtype_X_selected_number;
assignin('base', 'md_GUI', md_GUI);
end