% Description: A list that shows the files in the specified folder with the specified fileextension.
%   - inputs: 
%           GUI metadata
%   - outputs: 
%           Selected file
% Date of creation: 2017-07-10.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

%% FilesList function
function [ ] = FilesList(hObject, eventdata, UILoad)
md_GUI = evalin('base', 'md_GUI');
% Message to log_box
GUI.log.add(['File selected: ', char(md_GUI.UI.UILoad.ListOfFilesInFolder.String(md_GUI.UI.UILoad.ListOfFilesInFolder.Value))])
assignin('base', 'md_GUI', md_GUI);
end