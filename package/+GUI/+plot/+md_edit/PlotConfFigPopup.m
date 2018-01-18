% Description: Selects which field to manipulate for the plot
% configuration (binsize, labels, etc.).
%   - inputs: none.
%   - outputs:
%           Field selected that user wants to edit      (fieldselected)
% Date of creation: 2017-07-10.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ ] = PlotConfFigPopup(hObject, eventdata)
md_GUI = evalin('base', 'md_GUI');
guidata(hObject);
handles = guidata(hObject);
handles.fieldsel = get(hObject, 'String');
fieldselnum = get(hObject, 'Val');
fieldselected = handles.fieldsel(fieldselnum);
md_GUI.plot.plotconf.fieldselected = fieldselected;
assignin('base', 'md_GUI', md_GUI);
end