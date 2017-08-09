% Description: Gets the values from an editbox and returns them.
%   - inputs: none.
%   - outputs: (into PlotConfSetButton)
%           New field values            (newfieldcell)
% Date of creation: 2017-07-10.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ newfieldcell ] = PlotConfFieldEdit( hObject )
handles = guidata(hObject);
handles.filetype = get(hObject, 'String');
newfieldvalues = handles.filetype;
newfieldvalues = char(newfieldvalues);
newfieldcell = newfieldvalues;
end