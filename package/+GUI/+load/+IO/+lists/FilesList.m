% Description: A list that shows the files in the specified folder with the
% specified fileextension.
%   - inputs: None.
%   - outputs: 
%           Selected file.          (fileselected)
% Date of creation: 2017-07-10.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

%% FilesList function
function [ ] = FilesList(hObject, eventdata, UILoad)
md_GUI = evalin('base', 'md_GUI');
%Gives fileselected in the fileslist
guidata(hObject);
handles = guidata(hObject);
handles.filetype = get(hObject, 'String');
filenumber = get(hObject, 'Val');
fileselected = handles.filetype(filenumber);
md_GUI.load.fileselected = fileselected;
%% Message to log_box - cell_to_be_inserted:
cell_to_be_inserted = ['File selected.'];
[ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, cell_to_be_inserted );
md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
% End of new message to log_box function.
assignin('base', 'md_GUI', md_GUI);
end