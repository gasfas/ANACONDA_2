% Description: Loads the filecontent of the selected folder. 
%   - inputs: None.
%   - outputs: 
%           Folder name             (folder_name)
%           List of files in folder (String_ListOfFilesInFolder)
% Date of creation: 2017-07-18.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

%% Loadfolder function
function [ ] = LoadFolder( hObject, eventdata, UIPlot, UILoad)
% tech the GUI metadata:
md_GUI = evalin('base', 'md_GUI');

%% Specify location:
fformat = get(UILoad.FiletypeEditBox, 'String');
getdir_title = 'load a file';

try [pathname] = uigetdir(md_GUI.load.prevdir, getdir_title);
catch [pathname] = uigetdir(cd, getdir_title);
end

%% Verify location/data in path:

if ~pathname == 0
	
    md_GUI.load.prevdir = pathname;
	% Find all the files in the given directory:
    searchname = fullfile(pathname, ['*.' fformat{:}]);
    Files = dir(searchname);                   %get the files
    String_ListOfFilesInFolder = {Files.name};
	
	if isempty(String_ListOfFilesInFolder) % no files of specified format found
        GUI.log.add(['No files in ' fformat{:} ' format in folder']);
		set(UILoad.FiletypeEditBox, 'Enable', 'on')
	else % Files found, update the list of files:
		md_GUI.load.String_ListOfFilesInFolder = String_ListOfFilesInFolder;
		md_GUI.load.folder_name = pathname;
		md_GUI.load.fileselected = String_ListOfFilesInFolder(1);
		set(UILoad.ListOfFilesInFolder, 'String', md_GUI.load.String_ListOfFilesInFolder)
		set(UILoad.ListOfFilesInFolder, 'Value', 1)
		set(UILoad.LoadFileButton, 'Enable', 'on')
		% Message to log_box:
		GUI.log.add(['Folder loaded: ', pathname]);
    end
    
    % Put GUI into base.
    assignin('base', 'md_GUI', md_GUI);
end

end