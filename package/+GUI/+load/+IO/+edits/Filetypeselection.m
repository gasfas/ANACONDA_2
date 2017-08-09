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
handles = guidata(hObject);
handles.filetype = get(hObject, 'String');
filetypeselected = char(handles.filetype);

%% Load previously set foldername
foldername = md_GUI.load.folder_name;

%% Put files with selected file extension into string cell
fullfiletypeselected = ['.', filetypeselected];
fileextension = ['*', fullfiletypeselected];
fileextension = cellstr(fileextension);
pathname = fullfile(foldername, fileextension);     %set file extension
pathname = char(pathname);
matFiles = dir(pathname);                           %get the files
String_ListOfFilesInFolder = {matFiles.name};
set(UILoad.ListOfFilesInFolder, 'String', String_ListOfFilesInFolder)
set(UILoad.ListOfFilesInFolder, 'Value', 1)
md_GUI.load.fileformat = fullfiletypeselected;

%% Message to log_box - cell_to_be_inserted:
cell_to_be_inserted = ['File extension set: .', filetypeselected];
[ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, cell_to_be_inserted );
md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
% End of new message to log_box function.
%%

%% Save to metadata
assignin('base', 'md_GUI', md_GUI);
end
