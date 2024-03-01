function load_scan_OK_callback(~, ~, GUI_settings, is_modify_scan)
% This function checks the inputs and, if approved, loads the requested
% data to file.

% Get the variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

% First read the inputs from the Add scan window:
GUI_settings.load_scan.csv_filelist     = UI_obj.load_scan.LoadFilePath.Value;
% TODO: add filepath into the GUI and readout here:
% GUI_settings.load_scan.csv_filedir     = UI_obj.load_scan.LoadFileDir.Value;
file_found = true;

if any(~isfile(fullfile(GUI_settings.load_scan.csv_filedir, GUI_settings.load_scan.csv_filelist)))% Make sure the filenames are all actual datafiles:
    UI_obj.load_scan.non_existing_files = msgbox('Some or all of the specified files do not exist. Please choose other name(s).');
else % The files exist.
    % If we are modifying a load, we first remove the currently selected
    % scan from memory:
    if is_modify_scan
        % Check which run (sample name) is selected.
        sample_selected                 = UI_obj.main.scans.uitable.Selection(1);
        sample_userscanname_selected    = UI_obj.main.scans.uitable.Data(sample_selected, 1);
        % Get the internal name:
        sample_intscanname_selected     = GUI.fs_big.get_intname_from_username(exp_data.scans, sample_userscanname_selected);
        % Backup scans in case name is duplicate:
        exp_data_old                    = exp_data;
        % Remove the scan from experimental data:
        exp_data.scans                  = rmfield(exp_data.scans, sample_intscanname_selected);
        % If the scan has not been modified, no action.
    end

    % Read which scan and spectrum numbers should be used:
    [~, scan_nr_cur]    = GUI.fs_big.make_new_intname(exp_data.scans);
    [~, spectrum_nr_cur]= GUI.fs_big.make_new_intname(exp_data.spectra);
    color_counter       = spectrum_nr_cur + scan_nr_cur - 1;
    user_scannames      = GUI.fs_big.get_user_names(exp_data.scans);
    user_spectranames   = GUI.fs_big.get_user_names(exp_data.spectra);

    if ismember(UI_obj.load_scan.sample_name.Value, user_scannames) || ismember(UI_obj.load_scan.sample_name.Value, user_spectranames)
        UI_obj.load_scan.duplicate_names_msgbox = msgbox(['Sample name ', UI_obj.load_scan.sample_name.Value, ' is either already in use, or an invalid name. Please choose another name.']);
        if is_modify_scan % The modified name is duplicate with an existing scan, so return to old exp_data:
            exp_data = exp_data_old;
        end
    else % We assume the input is correct.
        % Load the files and place a new instance in the GUI_settings:
        % Read the re-bin factor 
        GUI_settings.load_scan.re_bin_factor = UI_obj.load_scan.re_bin_factor.Value;
        % Read the setup type:
        [GUI_settings] = GUI.fs_big.load_scan.read_setup_type_radio(GUI_settings, UI_obj);
        % Warning the user it might take a while:
        UI_obj.load_scan.loading_data_msgbox = msgbox('Loading the requested spectra. This might take a while');
        % Give a name to this new scan:
        scan_name_cur    = ['scan_' , num2str(scan_nr_cur, '%03.f')];
        spectr_name_cur = ['spectrum_' , num2str(spectrum_nr_cur, '%03.f')];
    
        % Load the files to memory, method depends on the spectrometer:
        switch GUI_settings.load_scan.setup_type
            case 'Spektrolatius'
                switch UI_obj.load_scan.isscanfields.rb_individual_spectra.Value
                    case true % Individual spectra (not a scan) loaded:
                        % Save the experimental data from this sample in the general data directory:
                        for spectr_nr = 1:length(GUI_settings.load_scan.csv_filelist)
                            exp_data.spectra.(spectr_name_cur).Data               = IO.SPECTROLATIUS_S2S.load_CSV_filelist(GUI_settings.load_scan.csv_filedir, GUI_settings.load_scan.csv_filelist{spectr_nr} , GUI_settings.load_scan.re_bin_factor);
                            if numel(GUI_settings.load_scan.csv_filelist) == 1 % No numbering if only one spectrum is loaded.
                                exp_data.spectra.(spectr_name_cur).Name                 = UI_obj.load_scan.sample_name.Value;
                            else
                                exp_data.spectra.(spectr_name_cur).Name                 = [UI_obj.load_scan.sample_name.Value, '_' num2str(spectr_nr)];
                            end
                            exp_data.spectra.(spectr_name_cur).Color                    = plot.colormkr(color_counter,1);
                            exp_data.spectra.(spectr_name_cur).metadata.IO.setup_type   = GUI_settings.load_scan.setup_type;
                            exp_data.spectra.(spectr_name_cur).metadata.IO.re_bin_factor= GUI_settings.load_scan.re_bin_factor;
                            exp_data.spectra.(spectr_name_cur).metadata.IO.csv_filelist = GUI_settings.load_scan.csv_filelist;
                            exp_data.spectra.(spectr_name_cur).metadata.IO.csv_filedir  = GUI_settings.load_scan.csv_filedir;
                            % Fill in a dY (intensity shift) and scale for the spectrum, used for correction later.
                            exp_data.spectra.(spectr_name_cur).Data.hist.spectr_001.dY    = 0;
                            exp_data.spectra.(spectr_name_cur).Data.hist.spectr_001.Scale = 1;
                            spectrum_nr_cur                    = spectrum_nr_cur + 1;
                            color_counter                     = color_counter + 1;
                            spectr_name_cur = ['spectrum_' , num2str(spectrum_nr_cur, '%03.f')];
                            file_found = true;
                        end
                    case false % A scan is loaded, so save the files in exp_data.scans:
                       exp_data.scans.(scan_name_cur).Data   = IO.SPECTROLATIUS_S2S.load_CSV_filelist(GUI_settings.load_scan.csv_filedir, GUI_settings.load_scan.csv_filelist , GUI_settings.load_scan.re_bin_factor);
                       scan_nr_cur = scan_nr_cur + 1;      
                       % Write the metadata of this sample in the GUI_settings:
                       exp_data.scans.(scan_name_cur).metadata.IO.setup_type        = GUI_settings.load_scan.setup_type;
                       exp_data.scans.(scan_name_cur).metadata.IO.re_bin_factor     = GUI_settings.load_scan.re_bin_factor;
                       exp_data.scans.(scan_name_cur).metadata.IO.csv_filelist      = GUI_settings.load_scan.csv_filelist;
                       exp_data.scans.(scan_name_cur).metadata.IO.csv_filedir       = GUI_settings.load_scan.csv_filedir;
                       exp_data.scans.(scan_name_cur).Name                          = UI_obj.load_scan.sample_name.Value;
                       % Fill in a dY (intensity shift) and scale for every spectrum in the scan, used for correction later.
                       for spectr_name = fieldnames(exp_data.scans.(scan_name_cur).Data.hist)'
                           exp_data.scans.(scan_name_cur).Data.hist.(spectr_name{:}).dY     = 0;
                           exp_data.scans.(scan_name_cur).Data.hist.(spectr_name{:}).Scale  = 1;
                       end
                       if is_modify_scan
                           exp_data.scans.(scan_name_cur).Color                = GUI_settings.load_scan.Color;
                       else
                           exp_data.scans.(scan_name_cur).Color                = plot.colormkr(color_counter,1);
                       end
                       color_counter                              = color_counter + 1;
                end
            case 'Desirs_LTQ'
               msgbox('TODO')
            otherwise
               msgbox('TODO')
        end
        if file_found
            % Closing the load spectrum window:
            set(UI_obj.load_scan.f_open_scan,'visible','off');
            % Closing the message box:
            try set(UI_obj.load_scan.loading_data_msgbox, 'visible', 'off'); catch;  end
            % Set the default directory to the one just used, for the possible next scan/spectrum load:
            GUI_settings.load_scan.browse_dir = GUI_settings.load_scan.csv_filedir;
            figure(UI_obj.main.uifigure)
        end
end

% Update the tables:
GUI.fs_big.scan_viewer.uitable_spectra_modify(UI_obj, exp_data);
GUI.fs_big.scan_viewer.uitable_scan_modify(UI_obj, exp_data);

% Set the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end

