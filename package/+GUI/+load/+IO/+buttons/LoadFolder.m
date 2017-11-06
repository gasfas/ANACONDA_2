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
fformat = md_GUI.UI.UILoad.FiletypeEditBox.String;

try 
    [pathname] = uigetdir(md_GUI.load.folder_name, 'Select folder');
catch
    [pathname] = uigetdir(cd, 'Select folder');
end

%% Verify location/data in path:

if ~pathname == 0
    
	% Find all the files in the given directory:
    Files = dir(fullfile(pathname, ['*.' fformat{:}])); % get the files
    String_ListOfFilesInFolder = {Files.name};
	
	if isempty(String_ListOfFilesInFolder) % no files of specified format found
        GUI.log.add(['No files in ' fformat{:} ' format in folder. Returned to previous folder.']);
	else % Files found, update the list of files:
		md_GUI.UI.UILoad.ListOfFilesInFolder.String = String_ListOfFilesInFolder;
		md_GUI.load.folder_name = pathname;
		set(UILoad.ListOfFilesInFolder, 'Value', 1)
		set(UILoad.LoadFileButton, 'Enable', 'on')
		% Message to log_box:
		GUI.log.add(['Folder loaded: ', pathname]);
	end
    
    % Put GUI into base.
    assignin('base', 'md_GUI', md_GUI);
end

end