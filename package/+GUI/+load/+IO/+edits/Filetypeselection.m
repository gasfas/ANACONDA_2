% Description: Sets the fileformat of the files in the specified folder of
% which to show / use.
%   - inputs: 
%           Folder name             (folder_name)
%   - outputs: 
%           Filetype                (fileformat)
% Date of creation: 2017-07-10.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

%% Filetypeselection function
function [ ] = Filetypeselection( hObject, eventdata, UILoad )
md_GUI = evalin('base', 'md_GUI');

matFiles = dir(char(fullfile(md_GUI.load.folder_name, cellstr(['*.', char(md_GUI.UI.UILoad.FiletypeEditBox.String)]))));
String_ListOfFilesInFolder = {matFiles.name};
set(UILoad.ListOfFilesInFolder, 'String', String_ListOfFilesInFolder)
set(UILoad.ListOfFilesInFolder, 'Value', 1)

%% Message to log_box
GUI.log.add(['File extension set: .', char(md_GUI.UI.UILoad.FiletypeEditBox.String)])

%% Save to metadata
assignin('base', 'md_GUI', md_GUI);

end
