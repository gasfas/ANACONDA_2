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
fileselected = md_GUI.UI.UILoad.ListOfFilesInFolder.String(md_GUI.UI.UILoad.ListOfFilesInFolder.Value);
% Message to log_box
for lx = 1:length(fileselected)
    if lx == 1
        fileselmsg = char(fileselected(lx));
    else
        fileselmsg = [fileselmsg, ' & ', char(fileselected(lx))];
    end
end
assignin('base', 'md_GUI', md_GUI);
GUI.log.add(['File(s) selected: ', fileselmsg])
end