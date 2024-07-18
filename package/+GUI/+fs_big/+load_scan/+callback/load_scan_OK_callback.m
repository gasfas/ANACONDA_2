function load_scan_OK_callback(~, ~, GUI_settings, is_modify_scan)
% This function checks the inputs and, if approved, loads the requested
% data to file.

% Get the variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

% First read the inputs from the Add scan window:
GUI_settings.load_scan.filelist     = UI_obj.load_scan.LoadFilePath.Value;
% TODO: add filepath into the GUI and readout here:
% GUI_settings.load_scan.filedir     = UI_obj.load_scan.LoadFileDir.Value;
file_found = true;
GUI_settings = GUI.fs_big.load_scan.read_setup_type_radio(GUI_settings, UI_obj);

% Treat the data depending on which spectrometer was selected:
switch GUI_settings.load_scan.setup_type
    case 'Spektrolatius'
    if any(~isfile(fullfile(GUI_settings.load_scan.filedir, GUI_settings.load_scan.filelist)))% Make sure the filenames are all actual datafiles:
        UI_obj.load_scan.non_existing_files = msgbox('Some or all of the specified files do(es) not exist. Please choose other name(s).');
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
        [~, scan_nr_cur]    = GUI.fs_big.make_new_intname(exp_data.scans, 'scan');
        [~, spectrum_nr_cur]= GUI.fs_big.make_new_intname(exp_data.spectra, 'spectr');
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
            scan_name_cur   = ['scan_' , num2str(scan_nr_cur, '%03.f')];
            spectr_name_cur = ['spectrum_' , num2str(spectrum_nr_cur, '%03.f')];
        
            % Load the files to memory, method depends on the spectrometer:
            switch GUI_settings.load_scan.setup_type
                case 'Spektrolatius'
                    switch UI_obj.load_scan.isscanfields.rb_individual_spectra.Value
                        case true % Individual spectra (not a scan) loaded:
                            % Save the experimental data from this sample in the general data directory:
                            for spectr_nr = 1:length(GUI_settings.load_scan.filelist)
                                if numel(GUI_settings.load_scan.filelist) == 1 % No numbering if only one spectrum is loaded.
                                    exp_data.spectra.(spectr_name_cur).Name                 = username_for_new_spectrum_scan(exp_data, UI_obj.load_scan.sample_name.Value);
                                else
                                    exp_data.spectra.(spectr_name_cur).Name                 = username_for_new_spectrum_scan(exp_data, [UI_obj.load_scan.sample_name.Value, '_' num2str(spectr_nr)]);
                                end
                                exp_data.spectra.(spectr_name_cur).Data               = IO.SPECTROLATIUS_S2S.load_CSV_filelist(GUI_settings.load_scan.filedir, GUI_settings.load_scan.filelist{spectr_nr} , GUI_settings.load_scan.re_bin_factor);
                                exp_data.spectra.(spectr_name_cur).Color                    = plot.colormkr(color_counter,1);
                                exp_data.spectra.(spectr_name_cur).metadata.IO.setup_type   = GUI_settings.load_scan.setup_type;
                                exp_data.spectra.(spectr_name_cur).metadata.IO.re_bin_factor= GUI_settings.load_scan.re_bin_factor;
                                exp_data.spectra.(spectr_name_cur).metadata.IO.filelist     = GUI_settings.load_scan.filelist;
                                exp_data.spectra.(spectr_name_cur).metadata.IO.filedir      = GUI_settings.load_scan.filedir;
                                % Fill in a dY (intensity shift) and scale for the spectrum, used for correction later.
                                exp_data.spectra.(spectr_name_cur).Data.hist.spectr_001.dY    = 0;
                                exp_data.spectra.(spectr_name_cur).Data.hist.spectr_001.Scale = 1;
                                spectrum_nr_cur                     = spectrum_nr_cur + 1;
                                color_counter                       = color_counter + 1;
                                spectr_name_cur                     = ['spectrum_' , num2str(spectrum_nr_cur, '%03.f')];
                                file_found                          = true;
                            end
                        case false % A scan is loaded, so save the files in exp_data.scans:
                            % Check if user name is duplicate:
                           exp_data.scans.(scan_name_cur).Name                      = username_for_new_spectrum_scan(exp_data, UI_obj.load_scan.sample_name.Value);
                           exp_data.scans.(scan_name_cur).Data   = IO.SPECTROLATIUS_S2S.load_CSV_filelist(GUI_settings.load_scan.filedir, GUI_settings.load_scan.filelist , GUI_settings.load_scan.re_bin_factor);
                           scan_nr_cur = scan_nr_cur + 1;      
                           % Write the metadata of this sample in the GUI_settings:
                           exp_data.scans.(scan_name_cur).metadata.IO.setup_type    = GUI_settings.load_scan.setup_type;
                           exp_data.scans.(scan_name_cur).metadata.IO.re_bin_factor = GUI_settings.load_scan.re_bin_factor;
                           exp_data.scans.(scan_name_cur).metadata.IO.filelist      = GUI_settings.load_scan.filelist;
                           exp_data.scans.(scan_name_cur).metadata.IO.filedir       = GUI_settings.load_scan.filedir;
                           if general.struct.issubfield(GUI_settings, 'channels.list')
                                % There are channels defined, so we add an entry for
                                % this newly added scan. 
                                [GUI_settings] = add_fragment_channels(GUI_settings, scan_name_cur, plot.colormkr(color_counter,1));
                           end

                           % Fill in a dY (intensity shift) and scale for every spectrum in the scan, used for correction later.
                           for spectr_name = fieldnames(exp_data.scans.(scan_name_cur).Data.hist)'
                               exp_data.scans.(scan_name_cur).Data.hist.(spectr_name{:}).dY     = 0;
                               exp_data.scans.(scan_name_cur).Data.hist.(spectr_name{:}).Scale  = 1;
                           end
                           % Give a color
                           if is_modify_scan % either that was used for this scan before
                               exp_data.scans.(scan_name_cur).Color                = GUI_settings.load_scan.Color;
                           else %or that is not used yet for a new scan:
                               exp_data.scans.(scan_name_cur).Color                = plot.colormkr(color_counter,1);
                           end
                           color_counter                              = color_counter + 1;
                    end
                otherwise
                   msgbox('TODO')
            end
            GUI_settings.load_scan.browse_dir = GUI_settings.load_scan.filedir;
        end
    end
    case 'Desirs_LTQ' % In case the Desirs data is loaded (in txt format assumed):
        % We load all spectra of either the short (5-unit) or long
        % (10-unit) peptides, depending which is selected:
        % The following folders are assumed in the Desirs_LTQ chef special:
        % 5-unit/R*GGM or R*MGG/RFGGM_5-7eV/txt
        % Accompanying metadata is found in:
        % 5-unit/R*GGM or R*MGG/RFGGM_5-7eV/md_R*GGM_5_7eV
        datafiles       = GUI_settings.load_scan.filelist;
        % Read which scan and spectrum numbers should be used:
        [~, scan_nr_cur]    = GUI.fs_big.make_new_intname(exp_data.scans, 'scan');
        [~, spectrum_nr_cur]= GUI.fs_big.make_new_intname(exp_data.spectra, 'spectr');
        color_counter       = spectrum_nr_cur + scan_nr_cur - 1;

        for datafile = datafiles
            [data_dir_base, peptide_size] = fileparts(datafile{:});
            switch peptide_size
                case '10-unit'
                    sample_names = {'RWG2MG5', 'RWG4MG3', 'RWG6MG', 'RWMG7'};
                case '5-unit'
                    sample_names = {'RFGGM', 'RFMGG', 'RWGGM', 'RWMGG', 'RYGGM', 'RYMGG'};
                otherwise
                     UI_obj.load_scan.invalid_DESIRS2022_name_msgbox = msgbox('Please give a valid DESIRS 2022 file directory. Choose between 5- or 10-unit folder');
            end
            UI_obj.load_scan.loading_data_msgbox = msgbox('Loading the requested DESIRS spectra. This might take a while');

            for sample_name = sample_names
                scan_nr_cur = scan_nr_cur + 1; 
                scan_name_cur = ['scan_' , num2str(scan_nr_cur, '%03.f')];
                % Check if user name is not duplicate:
                NewName                                                     = [UI_obj.load_scan.sample_name.Value '_DESIRS_' sample_name{:}];
                NewName                                                     = username_for_new_spectrum_scan(exp_data, NewName);
                [exp_data.scans.(scan_name_cur)]                            = IO.LTQ.Load_DESIRS_2022(data_dir_base, sample_name, 'full', fullfile(data_dir_base, 'Flux_calibration'));
                exp_data.scans.(scan_name_cur).Name                         = NewName;
                % Write the metadata of this sample in the GUI_settings:
                exp_data.scans.(scan_name_cur).metadata.IO.setup_type       = GUI_settings.load_scan.setup_type;
                exp_data.scans.(scan_name_cur).metadata.IO.re_bin_factor    = GUI_settings.load_scan.re_bin_factor;
                exp_data.scans.(scan_name_cur).metadata.IO.filedir          = data_dir_base;
                exp_data.scans.(scan_name_cur).metadata.IO.filelist         = sample_name;
                exp_data.scans.(scan_name_cur).Data.comments                = '';
                exp_data.scans.(scan_name_cur).Color                        = plot.colormkr(color_counter,1);
                % A new scan is added, so there should also be entries added to the
                % fragment list, if it already exists:
                if general.struct.issubfield(GUI_settings, 'channels.list')
                    % There are channels defined, so we add an entry for
                    % this newly added scan. 
                    [GUI_settings] = add_fragment_channels(GUI_settings, scan_name_cur, plot.colormkr(color_counter,1));
                end
                color_counter                                               = color_counter + 1;
            end
        end
        file_found      = true;
end
if file_found
    % Closing the load spectrum window:
    set(UI_obj.load_scan.f_open_scan,'visible','off');
    % Closing the message box:
    try set(UI_obj.load_scan.loading_data_msgbox, 'visible', 'off'); catch;  end
    % Set the default directory to the one just used, for the possible next scan/spectrum load:
    figure(UI_obj.main.uifigure)
end
    
% Update the tables:
GUI.fs_big.scan_viewer.uitable_spectra_modify(UI_obj, exp_data);
GUI.fs_big.scan_viewer.uitable_scan_modify(UI_obj, exp_data);

% Set the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end

function NewName = username_for_new_spectrum_scan(exp_data, NewName)
NewName_ori = NewName;
occ_nr      = 0;
    while ~GUI.fs_big.check_validity_name(exp_data, NewName)
        occ_nr = occ_nr + 1;
        NewName = [NewName_ori '_' num2str(occ_nr)];
    end
end

function [GUI_settings] = add_fragment_channels(GUI_settings, scan_name_cur, Color)
    % fetch the channel names:
    channel_names           = fieldnames(GUI_settings.channels.list);
    existing_scan_names     = fieldnames(GUI_settings.channels.list.(channel_names{1}).scanlist);
    channel_to_copy         = GUI_settings.channels.list.(channel_names{1}).scanlist.(existing_scan_names{1});
    for channel_name_cur = channel_names'
        % Copy the file:
        GUI_settings.channels.list.(channel_name_cur{:}).scanlist.(scan_name_cur)          = channel_to_copy;
        % Overwrite the color:
        GUI_settings.channels.list.(channel_name_cur{:}).scanlist.(scan_name_cur).Color    = Color;
    end
end