function get_filepath(hObj, event, GUI_settings, UI_obj)
% Load the variables from base workspace:
[GUI_settings] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

    Data_type_handle = general.handle.find_Handle_in_HandleList(hObj.Parent.Children, 'Title', 'Data type');

    if ~isfolder(GUI_settings.load_scan.browse_dir) % The given default is not a directory, so overwritten with current directory:
        GUI_settings.load_scan.browse_dir = pwd;
    end
    % Load differently depending on the setup:
    [GUI_settings] = GUI.fs_big.load_scan.read_setup_type_radio(GUI_settings, UI_obj);
    switch  GUI_settings.load_scan.setup_type
        case 'Spektrolatius'         % Spektrolatius setup:
        [filelist, filedir] = uigetfile('.csv', 'Select all spectra that are part of the scan', GUI_settings.load_scan.browse_dir, 'MultiSelect', 'on');
        if iscell(filelist) && ~isempty(filedir) % Multiple files selected:
            GUI_settings.load_scan.filedir = filedir;
            GUI_settings.load_scan.filelist = filelist;
            % Close the load_file dialog:
            % Sort the filelist by photon energy. Fetch list of photon energies:
            UI_obj.load_scan.photon_energy_list_unordered = IO.SPECTROLATIUS_S2S.fetch_photon_energy_csv_namelist(filelist);
            % Then sort by ascending order:
            [~, ordering_idx] = sort(UI_obj.load_scan.photon_energy_list_unordered);
            filelist = filelist(ordering_idx);
            UI_obj.load_scan.LoadFilePath.Value = filelist;
        elseif ischar(filelist)  && ~isempty(filelist) % only one file selected
            GUI_settings.load_scan.filedir = filedir;
            UI_obj.load_scan.LoadFilePath.Value = {filelist};
            GUI_settings.load_scan.filelist = filelist;
        end % The third option, filelist=0, is not acted upon.
        
        case 'Desirs_LTQ' % In case the user wants to read data from an LTQ system (for example installed at SOLEIL/DESIRS/PLEIADES)
        % Here we offer the 'Chef special' option that Bart prepared:
        % Let the user decide which kind of experiment is loaded:
        UI_obj.load_scan.Desirs.questdlg = questdlg('Which Desirs files would you like to load?', ...
        'Choose type of Desirs experiment', 'LTQ (txt)', 'Desirs 2022 (Chef special)', 'Cancel', 'Desirs 2022 (Chef special)');
        
        if strcmp(UI_obj.load_scan.Desirs.questdlg, 'Desirs 2022 (Chef special)')
            % The user is expected to load the folder where the data is
            % found of the Desir measurements done in  2022.
            filelist = uigetdir(GUI_settings.load_scan.browse_dir, 'Select path to find the Desirs scans');
            GUI_settings.load_scan.filedir = filelist;
            if GUI_settings.load_scan.filedir ~= 0 % If a file directory is given, write it in:
                UI_obj.load_scan.LoadFilePath.Value = GUI_settings.load_scan.filedir;
            else
                hmsgbox = msgbox('Please select the directory either called 5-unit or 10-unit');
                figure(hmsgbox);
            end
        elseif strcmp(UI_obj.load_scan.Desirs.questdlg, 'LTQ (txt)')
            % Let the user select a .txt file from the Soleil LTQ system:
            [filelist, filedir]                     = uigetfile('.txt', GUI_settings.load_scan.browse_dir, 'Select path to find the Desirs scans', 'MultiSelect', 'on');
            GUI_settings.load_scan.filedir          = filedir;
            UI_obj.load_scan.LoadFilePath.Value     = filelist;
            % If multiple files are loaded, the user could give a list of
            % photon energies for each given textfile:
            if length(filelist) > 1
                % Set the variables to base workspace:
                GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj)
                GUI.fs_big.load_scan.LTQ_TXT_assignment(GUI_settings, filelist, filedir);
                % Save it in a place where we can find it while actually
                % loading the settings again:
                [GUI_settings, UI_obj] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);
            end
        else
            filelist = [];
        end
        case 'Amazon (FELIX)' % Load the amazon (Felix) scan data
            filelist                        = uigetdir(GUI_settings.load_scan.browse_dir, 'Select path to find the Felix scans');
            GUI_settings.load_scan.filedir  = filelist;
            if GUI_settings.load_scan.filedir ~= 0
                UI_obj.load_scan.LoadFilePath.Value = GUI_settings.load_scan.filedir;
            end
            UI_obj.load_scan.isscan.SelectedObject.Value = 1; % Only scans from FELIX.
    end
if ~isempty(filelist)
    % Rename the suggested filename by reading the filename of the first loaded file:
    [~, filename] = fileparts(UI_obj.load_scan.LoadFilePath.Value{1});
    if iscell(filelist) || ischar(filelist) % If a file has been selected:
        % Make sure the filename is valid:
        filename = general.make_valid_name(filename, 'sp');
        % Rename it:
        UI_obj.load_scan.sample_name.Value = filename;
        % See how many files are loaded. if only one, we classify it as a spectrum:
        if length(UI_obj.load_scan.LoadFilePath.Value) == 1
            UI_obj.isscanfields.rb_individual_spectra.Value = true;
        else % else they are separate spectra:
            if any(find(isnan(UI_obj.load_scan.photon_energy_list_unordered))) % nan's for photon energy, so some of the files do not have a photon energy defined, they are
                % also treated as separate spectra rather than a scan:
                Data_type_handle.Children(2).Value = true;
            else % we found a scan:
                Data_type_handle.Children(1).Value = true;
            end
        end
    end
    figure(UI_obj.load_scan.f_open_scan)

% Set the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj)
end