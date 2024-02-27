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
        [filelist, csv_filedir] = uigetfile('.csv', 'Select all spectra that are part of the scan', GUI_settings.load_scan.browse_dir, 'MultiSelect', 'on');
        if iscell(filelist) && ~isempty(csv_filedir) % Multiple files selected:
            GUI_settings.load_scan.csv_filedir = csv_filedir;
            GUI_settings.load_scan.csv_filelist = filelist;
            % Close the load_file dialog:
            % Sort the filelist by photon energy. Fetch list of photon energies:
            photon_energy_list_unordered = IO.SPECTROLATIUS_S2S.fetch_photon_energy_csv_namelist(filelist);
            % Then sort by ascending order:
            [~, ordering_idx] = sort(photon_energy_list_unordered);
            filelist = filelist(ordering_idx);
            UI_obj.load_scan.LoadFilePath.Value = filelist;
        elseif ischar(filelist)  && ~isempty(filelist) % only one file selected
            GUI_settings.load_scan.csv_filedir = csv_filedir;
            UI_obj.load_scan.LoadFilePath.Value = {filelist};
            GUI_settings.load_scan.csv_filelist = filelist;
        end % The third option, filelist=0, is not acted upon.
        case 'Desirs_LTQ'
        % Here we offer the 'Chef special' option that Bart prepared:
        % Let the user decide which kind of experiment is loaded:
        UI_obj.load_scan.Desirs.questdlg = questdlg('Which Desirs files would you like to load?', ...
        'Choose type of Desirs experiment', 'Desirs (txt)', 'Desirs 2022 (Chef special)', 'Desirs 2022 (Chef special)');
        GUI_settings.load_scan.filedir = uigetdir(GUI_settings.load_scan.browse_dir, 'Select path to find the scans');
        UI_obj.load_scan.LoadFilePath.Value = GUI_settings.load_scan.csv_filedir;
        otherwise
        msgbox('Be friendly to the programmer, ask at the right moment if a setup module could be added in the future');
    end
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
            if any(find(isnan(photon_energy_list_unordered))) % nan's for photon energy, so some of the files do not have a photon energy defined, they are
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