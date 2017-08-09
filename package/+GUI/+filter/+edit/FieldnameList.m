% Description: Sets the FieldValueList to same position and updates
% fieldvalue. If fieldvalue is same as before it activates the doubleclick
% function (FieldDoubleClick).
%   - inputs: None.
%   - outputs: Field position.      (filterlistval)
% Date of creation: 2017-07-03.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [fieldvalueselected] = FieldnameList(hObject, eventdata, UIFilter)
md_GUI = evalin('base', 'md_GUI');
fieldvalueselected = hObject.Value;
if md_GUI.filter.filterlistval == fieldvalueselected
    % Double clicked.
    GUI.filter.edit.FieldDoubleClick(UIFilter)
else
    set(UIFilter.Fieldvalue, 'Value', fieldvalueselected);
    md_GUI.filter.filterlistval = fieldvalueselected;
    assignin('base', 'md_GUI', md_GUI)
end
end