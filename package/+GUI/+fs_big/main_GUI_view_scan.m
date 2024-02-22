function [exp_data, settings, defaults, UI_obj] = main_GUI_view_scan()
% GUI main view to load and visualize a Spektrolatius/Desirs/... scan
GUI.fs_big.define_channels;

% Set some defaults:
defaults.load_scan.browse_dir       = 'D:\';

defaults.load_scan.browse_dir                   = 'D:\DATA\2023\20230314\20230314\MetEnk_scan';
defaults.load_scan.browse_dir                   = 'D:\DATA\2024\Galaxies_2024\KM-5 Skedge scan intermediate steps';
defaults.load_scan.setup_type                   = 'Spektrolatius';
defaults.load_scan.tooltips.re_bin_factor       = 'The re-bin factor reduces the amount of (m2q) datapoints by calculating the average of every bunch of ''re-bin factor'' values.';
defaults.load_scan.tooltips.sample_name         = 'Fill in the name of the sample or run you are loading. For example: ""MetEnk_Desirs"" ';
defaults.load_scan.tooltips.Remove_scan         = 'Removes the selected scan(s) in the table from memory.';
defaults.load_scan.tooltips.Modify_scan         = 'Adapt an already-loaded scan, e.g. by adding or removing spectra or changing the name.';
defaults.load_scan.tooltips.plot_m2q            = 'Visualize the mass spectra of selected scan(s). If no scans are selected, all of them will be available.';
defaults.load_scan.tooltips.plot_scan           = 'Visualize the yields of selected scan(s). If no scans are selected, all of them will be considered.';
defaults.load_scan.tooltips.define_channels     = 'Select the fragments from an averaged mass spectru';
defaults.load_scan.tooltips.Save_workspace      = 'TODO Save the current workspace to disk, to be loaded at a later stage.';
defaults.load_scan.tooltips.Load_workspace      = 'TODO Load a previously used workspace from disk. Note that the currently loaded workspace will be cleared.';
defaults.load_scan.tooltips.Data_type_radio     = 'Do the data files form a common scan (only if all have a defined photon energy), or are they a collection of individual spectra?';

defaults.load_scan.tooltips.Add                 = 'Load a spectrum (or scan of spectra) from disk to memory. The spectrum name will appear as a row in the table.';
defaults.load_scan.tooltips.Remove_spectrum     = 'Removes the selected spectrum/spectra in the table from memory.';
defaults.load_scan.tooltips.Modify_spectrum     = 'Adapt an already-loaded scan, e.g. by adding or removing spectra or changing the name.';
defaults.load_scan.sample_number = 0; % Sample name
is_modify_scan                                  = false;

% [settings, defaults] = GUI.fs_big.edit_settings(settings, defaults);

settings                            = struct(); % Settings saved in struct
UI_obj                              = struct(); %All Ui objects stored in this struct.

% Some initial values for the settings:
settings.filelist.color_counter     = 1;
settings.scans.scan_nr_cur           = 1;
settings.spectra.spectrum_nr_cur    = 1;

% Set up the display, Initiate the uifigure:
UI_obj.main.uifigure                 = uifigure('Name', 'Scan viewer','NumberTitle','off','position',[100 100 590 470], 'CloseRequestFcn', @close_all_GUI_windows);

% Initiate the experiment struct:
exp_data                                = struct('scans', struct(), 'spectra', struct());

% Create the uitable containing the list of scans:
uitable_scan_create();
uitable_spectra_create();

% Initialize the interaction buttons for the spectra:
UI_obj.main.Add                         = uibutton(UI_obj.main.uifigure, "Text", "Add", "Position", [480, 430, 100, 20], 'Tooltip', defaults.load_scan.tooltips.Add, "ButtonPushedFcn", @load_scan_GUI);
UI_obj.main.Remove_spectrum             = uibutton(UI_obj.main.uifigure, "Text", "Remove spectrum", "Position", [480, 400, 100, 20], 'Tooltip', defaults.load_scan.tooltips.Remove_spectrum, "ButtonPushedFcn", {@remove_spectrum_scan_GUI,1});
% UI_obj.main.Modify_spectrum             = uibutton(UI_obj.main.uifigure, "Text", "Modify spectrum", "Position", [480, 370, 100, 20], 'Tooltip', defaults.load_scan.tooltips.Modify_spectrum, "ButtonPushedFcn", @modify_spectrum_GUI);

% Initialize the interaction buttons (load, delete, view spectra) for the
% scan:
UI_obj.main.Remove_scan             = uibutton(UI_obj.main.uifigure, "Text", "Remove scan", "Position", [480, 170, 100, 20], 'Tooltip', defaults.load_scan.tooltips.Remove_scan, "ButtonPushedFcn", {@remove_spectrum_scan_GUI,2});
UI_obj.main.Modify_scan             = uibutton(UI_obj.main.uifigure, "Text", "Modify scan", "Position", [480, 140, 100, 20], 'Tooltip', defaults.load_scan.tooltips.Modify_scan, "ButtonPushedFcn", @modify_scan_GUI);
UI_obj.main.plot_m2q.uibutton       = uibutton(UI_obj.main.uifigure, "Text", "Plot M/Q", "Position", [480, 110, 100, 20], 'Tooltip', defaults.load_scan.tooltips.plot_m2q, "ButtonPushedFcn", @plot_spectra_GUI);

UI_obj.main.plot_scan.uibutton      = uibutton(UI_obj.main.uifigure, "Text", "Plot scan", "Position", [480, 80, 100, 20], 'Tooltip', defaults.load_scan.tooltips.plot_scan, "ButtonPushedFcn", @define_channel_callback);

UI_obj.main.Save_workspace.uibutton = uibutton(UI_obj.main.uifigure, "Text", "Save workspace", "Position", [10, 10, 100, 20], 'Tooltip', defaults.load_scan.tooltips.Save_workspace, "ButtonPushedFcn", @Save_workspace);
UI_obj.main.Load_workspace.uibutton = uibutton(UI_obj.main.uifigure, "Text", "Load workspace", "Position", [120, 10, 100, 20], 'Tooltip', defaults.load_scan.tooltips.Load_workspace, "ButtonPushedFcn", @Load_workspace);

% Turn off Java warnings (we have no alternative before Matlab 2023):
warning('off', 'MATLAB:ui:javacomponent:FunctionToBeRemoved');

% Local functions
function load_scan_GUI(~, ~)
    % The load scan function as run from 'Add_scan'. This uses default 
    % values for the input fields:
    % set the default load values:
    sample_settings.sample_name     = ['sample', num2str(defaults.load_scan.sample_number)];
    sample_settings.re_bin_factor   = 1;
    sample_settings.csv_filelist    = defaults.load_scan.browse_dir;
    sample_settings.setup_type      = defaults.load_scan.setup_type;
    sample_settings.is_scan         = false;
    % Set sample name:
    defaults.load_scan.sample_number = defaults.load_scan.sample_number + 1;
    defaults.load_scan.sample_name  = ['sample', num2str(defaults.load_scan.sample_number)];
    defaultusername                 = defaults.load_scan.sample_name;
    % create the load scan window:
    load_scan_window(sample_settings, defaultusername);
    is_modify_scan = false;
end

function modify_scan_GUI(~, ~)
    % The load scan function as run from 'Modify_scan'
    % Read which scan was selected:
    if isempty(fieldnames(exp_data))
        UI_obj.main.modify_scan.empty_data_msgbox = msgbox('Cannot modify scan, since there are no data files loaded yet. Nice try.');
    elseif isempty(UI_obj.main.scans.uitable.Selection)
        UI_obj.main.modify_scan.no_data_selected_msgbox = msgbox('No data selected. Please select the sample you want to modify and try again.');
    else
        rownr              = unique(UI_obj.main.scans.uitable.Selection(:,1));
        if length(rownr) > 1  % More than one selected to be modified
            UI_obj.main.modify_scan.no_data_selected_msgbox = msgbox('Please only select one sample you want to modify');
        else
            % Check which run (sample name) is selected.
            sample_selected    = UI_obj.main.scans.uitable.Selection(1);
            sample_userscanname_selected = UI_obj.main.scans.uitable.Data(sample_selected, 1);
            % Get the internal name:
            sample_intscanname_selected     = GUI.fs_big.get_intname_from_username(exp_data.scans, sample_userscanname_selected);
            % Read the metadata from that run:
            sample_name                 = exp_data.scans.(sample_intscanname_selected{:}).Name;
            selected_sample_settings    = exp_data.scans.(sample_intscanname_selected{:}).metadata.IO;
            selected_sample_settings.is_scan = true;
            % Then use the metadata as initial settings to load_scan_window and load the modified scan:
            load_scan_window(selected_sample_settings, sample_userscanname_selected{:});
            is_modify_scan = true;
        end
    end
end

function load_scan_window(sample_settings, username)
    % Feedback whether a scan had been loaded:
    is_scan_loaded = false;
    
    UI_obj.load_scan.f_open_scan = uifigure('Name', 'Add scan',...
        'NumberTitle','off','position',[200 250 600 400], ...
        'KeyPressFcn', @load_scan_Keypress_callback);
    % Radio button to choose type of spectrometer:
    % Let the user decide which kind of experiment is done:
    UI_obj.setup_bg     = uibuttongroup(UI_obj.load_scan.f_open_scan,'Title', 'Choose spectrometer', 'Position',[30 300 140 100]);
    rb_Spektrolatius    = uiradiobutton(UI_obj.setup_bg,'Text', 'Spektrolatius', 'Position',[10 60 91 15]);
    rb_Desirs_LTQ       = uiradiobutton(UI_obj.setup_bg,'Text', 'Desirs_LTQ', 'Position',[10 38 91 15]);
    rb_Bessy            = uiradiobutton(UI_obj.setup_bg,'Text', 'Bessy', 'Position',[10 16 91 15]);
    % Set default radiobutton position:
    switch sample_settings.setup_type
        case 'Spektrolatius'
            rb_Spektrolatius.Value = true;
        case 'Desirs_LTQ'
            rb_Desirs_LTQ.Value = true;
        case 'Bessy'
            rb_Bessy.Value = true;
    end
    settings.load_scan.setup_type = '';

    UI_obj.load_scan.sample_name = uilabel(UI_obj.load_scan.f_open_scan, 'Text', 'Sample name', 'Position', [200, 375, 100, 30]);
    UI_obj.load_scan.sample_name = uieditfield(UI_obj.load_scan.f_open_scan, 'Value', username, 'Tooltip', defaults.load_scan.tooltips.sample_name, 'Position', [200, 350, 100, 30]);
    
    % re-bin factor:
    UI_obj.load_scan.re_bin_text = uilabel(UI_obj.load_scan.f_open_scan, 'Text', 're-bin factor', 'Position', [200, 325, 70, 30]);
    UI_obj.load_scan.re_bin_factor = uieditfield(UI_obj.load_scan.f_open_scan,"numeric", 'Value', sample_settings.re_bin_factor, 'Tooltip', defaults.load_scan.tooltips.re_bin_factor, 'Position', [200, 300, 50, 30]);
    
    % scan or individual spectra:
    % Radio button to choose type of spectrometer:
    % Let the user decide which kind of experiment is done:
    UI_obj.isscan         = uibuttongroup(UI_obj.load_scan.f_open_scan,'Title', 'Data type', 'Tooltip', defaults.load_scan.tooltips.Data_type_radio, 'Position',[320 300 140 80]);
    UI_obj.isscanfields.rb_individual_spectra   = uiradiobutton(UI_obj.isscan,'Text', 'spectra', 'Position',[10 38 91 15]);
    UI_obj.isscanfields.rb_scan                 = uiradiobutton(UI_obj.isscan,'Text', 'scans', 'Position',[10 16 91 15]);
    UI_obj.isscan.SelectedObject.Value          = ~sample_settings.is_scan;

    % Text of the filepath:
    UI_obj.LoadFilePath         = uitextarea(UI_obj.load_scan.f_open_scan, 'Value', sample_settings.csv_filelist, 'Position', [10, 50, 500, 220]);
    UI_obj.LoadFile_Browse_btn  = uibutton(UI_obj.load_scan.f_open_scan, "Text", "Browse", "Position", [10, 10, 80, 20], "ButtonPushedFcn", @get_filepath);
    UI_obj.LoadFile_Cancel_btn  = uibutton(UI_obj.load_scan.f_open_scan, "Text", "Cancel", "Position", [410, 10, 80, 20], "ButtonPushedFcn", @load_scan_cancel_callback);
    UI_obj.LoadFile_Ok_btn      = uibutton(UI_obj.load_scan.f_open_scan, "Text", "Ok", "Position", [500, 10, 80, 20], "ButtonPushedFcn", @load_scan_OK_callback);
end

function load_scan_Keypress_callback(~, event)
    % If the user presses return (enter), it is equivalent to clicking 'OK'
    if strcmp(event.Key, 'return')
        load_scan_OK_callback();
    end
end

function close_all_GUI_windows(~,~) % Make sure that all windows close when the main one is closed by user.
    delete(UI_obj.main.uifigure)
    try delete(UI_obj.load_scan.f_open_scan);   catch;  end
    try delete(UI_obj.def_channel.main);        catch;  end
    try delete(UI_obj.def_channel.data_plot);   catch;  end
    try delete(UI_obj.data_plot);               catch;  end
    try delete(UI_obj.plot.m2q.main);           catch;  end
    try delete(UI_obj.plot.m2q.plot_window);    catch;  end
end

function Save_workspace(hObj, event)
    % The total workspace consists of the following variables:
    % exp_data, settings
    try 
        scan_names                  = fieldnames(exp_data.scans);
        suggested_savename          = exp_data.scans.(scan_names{1}).Name;
        browse_dir                  = exp_data.scans.(scan_names{1}).metadata.IO.csv_filedir;
    catch
        try 
            scan_names                  = fieldnames(exp_data.spectra);
            suggested_savename          = exp_data.spectra.(scan_names{1}).Name;
            browse_dir                  = exp_data.spectra.(scan_names{1}).metadata.IO.csv_filedir;
        catch 
            suggested_savename          = 'SP_workspace';
            browse_dir                  = pwd;
        end
    end
    [saveFile, savePath]  = uiputfile( '*.mat', 'Save workspace as', fullfile(browse_dir, [suggested_savename '.mat']));
    save(fullfile(savePath, saveFile), 'exp_data', 'settings');
end

function Load_workspace(hObj, event)
    % User wishes to load previously-loaded workspace
    % Open a dialog to select the .mat file:
    [filename, filedir] = uigetfile('*.mat', 'Select the workspace file you wish to load', defaults.load_scan.browse_dir);
    % Load the variables:
    load(fullfile(filedir, filename), 'exp_data', 'settings')
    % Update the tables:
    UI_obj.main.scans.uitable.Data                  = compose_uitable_scan_spectrum_Data('scans');
    UI_obj.main.spectra.uitable.Data                = compose_uitable_scan_spectrum_Data('spectra');
    % Main window up:
    figure(UI_obj.main.uifigure)
end

function remove_spectrum_scan_GUI(~, ~,selection)
        % This function removes either a spectrum (selection = 1) or a scan
        % (selection = 2).
    switch selection 
        case 1 % Spectra/um to be removed:
        d_name = 'spectra';
        case 2
        d_name = 'scans';
    end
    % Read which scan was selected:
    if isempty(fieldnames(exp_data.(d_name)))
        UI_obj.main.remove_scan.empty_data_msgbox = msgbox('Cannot remove data, since there are no data files loaded yet. Nice try.');
    elseif isempty(UI_obj.main.(d_name).uitable.Selection)
        UI_obj.main.remove_scan.no_data_selected_msgbox = msgbox('No data selected. Please select the sample you want to remove and try again.');
    else
        rownrs              = unique(UI_obj.main.(d_name).uitable.Selection(:,1));
        for sample_nr       = 1:length(rownrs)
            % Check which run is selected.
            % Identify which internal name this scan has gotten:
            sel_username        = UI_obj.main.(d_name).uitable.Data{rownrs(sample_nr),1};
            intname             = GUI.fs_big.get_intname_from_username(exp_data.(d_name), sel_username);
            % Remove from exp data:
            exp_data.(d_name)        = rmfield(exp_data.(d_name), intname);
        end
        % Update the table:
        uitable_scan_modify();
    end
end

function plot_spectra_GUI(~, ~)
    % This function feeds the selected to the m2q plot function
    if isempty(fieldnames(exp_data))
        UI_obj.main.plot_m2q.empty_data_plot_msgbox = msgbox('Cannot plot mass spectra, since there are no scans loaded yet. Nice try.');
    else
        % % Find out which are the selected scans:
        % [data_to_plot] = fetch_selected_scans();
        [defaults, UI_obj] = GUI.fs_big.Plot_m2q(exp_data, defaults, UI_obj);
    end
end

function define_channel_callback(~, ~)
   % Check which scan is selected:
   if length(fieldnames(exp_data)) == 1% only one scan loaded, so no selection needed:
       selected_scan_nr = 1;
   elseif isempty(fieldnames(exp_data)) % No scans loaded yet, so no scan plot possible:
       selected_scan_nr = [];
   else
       try 
           selected_scan_nr = unique(UI_obj.main.scans.uitable.Selection(:,1)); % Check which scans are selected (if any)
       catch 
           selected_scan_nr = 1; % if no selection is made, take the first.
       end
   end
   
   if isempty(selected_scan_nr) || isempty(fieldnames(exp_data.scans))
       msgbox('Please load the scan(s) you want to plot.')
   else
       % Fetch the name of the selected scan:
       sample_username  = UI_obj.main.scans.uitable.Data{selected_scan_nr,1};
       sample_intname   = GUI.fs_big.get_intname_from_username(exp_data.scans, sample_username);
       % Open the window to let the user select channels for the scan.
       plot_scan(defaults, settings, UI_obj, exp_data, sample_intname);
   end
end

function get_filepath(~, ~)
    if ~isfolder(defaults.load_scan.browse_dir) % The given default is not a directory, so overwritten with current directory:
        defaults.load_scan.browse_dir = pwd;
    end
    % Load differently depending on the setup:
    read_setup_type_radio()
    switch  settings.load_scan.setup_type
        case 'Spektrolatius'         % Spektrolatius setup:
        [filelist, csv_filedir] = uigetfile('.csv', 'Select all spectra that are part of the scan', defaults.load_scan.browse_dir, 'MultiSelect', 'on');
        if iscell(filelist) & ~isempty(csv_filedir) % Multiple files selected:
            settings.load_scan.csv_filedir = csv_filedir;
            settings.load_scan.csv_filelist = filelist;
            % Close the load_file dialog:
            % Sort the filelist by photon energy. Fetch list of photon energies:
            photon_energy_list_unordered = IO.SPECTROLATIUS_S2S.fetch_photon_energy_csv_namelist(filelist);
            % Then sort by ascending order:
            [~, ordering_idx] = sort(photon_energy_list_unordered);
            filelist = filelist(ordering_idx);
            UI_obj.LoadFilePath.Value = filelist;
        elseif ischar(filelist)  & ~isempty(filelist) % only one file selected
            settings.load_scan.csv_filedir = csv_filedir;
            UI_obj.LoadFilePath.Value = {filelist};
            settings.load_scan.csv_filelist = filelist;
        end % The third option, filelist=0, is not acted upon.
        case 'Desirs_LTQ'
        % Here we offer the 'Chef special' option that Bart prepared:
        % Let the user decide which kind of experiment is loaded:
        UI_obj.load_scan.Desirs.questdlg = questdlg('Which Desirs files would you like to load?', ...
        'Choose type of Desirs experiment', 'Desirs (txt)', 'Desirs 2022 (Chef special)', 'Desirs 2022 (Chef special)');
        settings.load_scan.filedir = uigetdir(defaults.load_scan.browse_dir, 'Select path to find the scans');
        UI_obj.LoadFilePath.Value = settings.load_scan.csv_filedir;
        otherwise
        msgbox('Be friendly to the programmer, ask at the right moment if a new setup module could be added in the future');
    end
    % Rename the suggested filename by reading the filename of the first loaded file:
    [~, filename] = fileparts(UI_obj.LoadFilePath.Value{1});
    if iscell(filelist) || ischar(filelist) % If a file has been selected:
        % Make sure the filename is valid:
        filename = general.make_valid_name(filename, 'sp');
        % Rename it:
        UI_obj.load_scan.sample_name.Value = filename;
        % See how many files are loaded. if only one, we classify it as a spectrum:
        if length(UI_obj.LoadFilePath.Value) == 1
            UI_obj.isscanfields.rb_individual_spectra.Value = true;
        else % else they are separate spectra:
            if any(find(isnan(photon_energy_list_unordered))) % nan's for photon energy, so some of the files do not have a photon energy defined, they are
                % also treated as separate spectra rather than a scan:
                UI_obj.isscanfields.rb_individual_spectra.Value = true;
            else
                UI_obj.isscanfields.rb_scan.Value  = true;
            end
        end
    end
    figure(UI_obj.load_scan.f_open_scan)
end

function load_scan_OK_callback(~, ~)
    % This function checks the inputs and, if approved, loads the requested
    % data to file.
    % If we are modifying a load, we first remove the currently selected
    % scan from memory:
    if is_modify_scan
        % Check which run (sample name) is selected.
        sample_selected                 = UI_obj.main.scans.uitable.Selection(1);
        sample_userscanname_selected    = UI_obj.main.scans.uitable.Data(sample_selected, 1);
        % Get the internal name:
        sample_intscanname_selected     = GUI.fs_big.get_intname_from_username(exp_data.scans, sample_userscanname_selected);
        % Remove from experimental data:
        exp_data.scans                  = rmfield(exp_data.scans, sample_intscanname_selected);
        % If the scan has not been modified, no action.
    end
    % First check the inputs:
    % Make sure the sample name does not yet exist:
    user_scannames      = GUI.fs_big.get_user_scannames(exp_data.scans);
    user_spectranames   = GUI.fs_big.get_user_scannames(exp_data.spectra);
    if ismember(UI_obj.load_scan.sample_name.Value, user_scannames) || ismember(UI_obj.load_scan.sample_name.Value, user_spectranames)
        UI_obj.load_scan.duplicate_names_msgbox = msgbox(['Sample name ', UI_obj.load_scan.sample_name.Value, ' is either already in use, or an invalid name. Please choose another name.']);
    else % We assume the input is correct.
        is_scan_loaded = true;
        % Load the files and place a new instance in the settings:
        % Read the re-bin factor 
        settings.load_scan.re_bin_factor = UI_obj.load_scan.re_bin_factor.Value;
        % Read the setup type:
        read_setup_type_radio()
        % Warning the user it might take a while:
        UI_obj.load_scan.loading_data_msgbox = msgbox('Loading the requested spectra. This might take a while');
        % Give a name to this new scan:
        scan_name_cur    = ['scan_' , num2str(settings.scans.scan_nr_cur, '%03.f')];
        spectr_name_cur = ['spectrum_' , num2str(settings.spectra.spectrum_nr_cur, '%03.f')];

        % Load the files to memory, method depends on the spectrometer:
        switch settings.load_scan.setup_type
            case 'Spektrolatius'
                switch UI_obj.isscanfields.rb_individual_spectra.Value
                    case true % Individual spectra (not a scan) loaded:
                        % Save the experimental data from this sample in the general data directory:
                        if ischar(settings.load_scan.csv_filelist) % If only one file user-selected:
                            exp_data.spectra.(spectr_name_cur).Data = IO.SPECTROLATIUS_S2S.load_CSV_filelist(settings.load_scan.csv_filedir, settings.load_scan.csv_filelist , settings.load_scan.re_bin_factor);
                            exp_data.spectra.(spectr_name_cur).Name                 = UI_obj.load_scan.sample_name.Value;                         
                            exp_data.spectra.(spectr_name_cur).Color       = plot.colormkr(settings.filelist.color_counter,1);
                            settings.spectra.spectrum_nr_cur                        = settings.spectra.spectrum_nr_cur + 1;
                            settings.filelist.color_counter                         = settings.filelist.color_counter + 1;
                        else % Load the files one by one and store them in separate spectra files:
                            for spectr_nr = 1:length(settings.load_scan.csv_filelist)
                                exp_data.spectra.(spectr_name_cur)                  = IO.SPECTROLATIUS_S2S.load_CSV_filelist(settings.load_scan.csv_filedir, settings.load_scan.csv_filelist{spectr_nr} , settings.load_scan.re_bin_factor);
                                exp_data.spectra.(spectr_name_cur).Name             = UI_obj.load_scan.sample_name.Value;
                                exp_data.spectra.(spectr_name_cur).Color            = plot.colormkr(settings.filelist.color_counter,1);
                                settings.spectra.spectrum_nr_cur                    = settings.spectra.spectrum_nr_cur + 1;
                                settings.filelist.color_counter                     = settings.filelist.color_counter + 1;
                            end
                        end
                    case false % A scan is loaded, so save the files in exp_data.scans:
                        exp_data.scans.(scan_name_cur).Data   = IO.SPECTROLATIUS_S2S.load_CSV_filelist(settings.load_scan.csv_filedir, settings.load_scan.csv_filelist , settings.load_scan.re_bin_factor);
                        settings.scans.scan_nr_cur = settings.scans.scan_nr_cur + 1;      
                       % Write the metadata of this sample in the settings:
                       exp_data.scans.(scan_name_cur).metadata.IO.setup_type        = settings.load_scan.setup_type;
                       exp_data.scans.(scan_name_cur).metadata.IO.re_bin_factor     = settings.load_scan.re_bin_factor;
                       exp_data.scans.(scan_name_cur).metadata.IO.csv_filelist      = settings.load_scan.csv_filelist;
                       exp_data.scans.(scan_name_cur).metadata.IO.csv_filedir       = settings.load_scan.csv_filedir;
                       exp_data.scans.(scan_name_cur).Name                          = UI_obj.load_scan.sample_name.Value;
                       exp_data.scans.(scan_name_cur).Color                = plot.colormkr(settings.filelist.color_counter,1);
                       settings.filelist.color_counter                              = settings.filelist.color_counter + 1;
                end
               % Update the table with the extra sample(s):
               uitable_scan_modify();
               uitable_spectra_modify();
            case 'Desirs_LTQ'
               msgbox('TODO')
            otherwise
               msgbox('TODO')
        end
        % Closing the load spectrum window:
        set(UI_obj.load_scan.f_open_scan,'visible','off');
        % Closing the message box:
        try set(UI_obj.load_scan.loading_data_msgbox, 'visible', 'off'); catch;  end
        % Set the default directory to this one, for the possible next scan:
        defaults.load_scan.browse_dir = settings.load_scan.csv_filedir;
        figure(UI_obj.main.uifigure)
    end
    % Make the data accessible in base:
    assignin('base', "defaults", defaults);
    assignin('base', "settings", settings);
    assignin('base', "exp_data", exp_data);
end

function load_scan_cancel_callback(~,~)
    % Do nothing and close window.
    set(UI_obj.load_scan.f_open_scan,'visible','off');
end

    function read_setup_type_radio()
        % Find which setup the user has chosen:
        i = 0; found = false;
        while ~ found 
            i = i + 1;
            if UI_obj.setup_bg.Children(i).Value
                found = true; % Found the selected spectrometer. Write in settings:
                settings.load_scan.setup_type = UI_obj.setup_bg.Children(i).Text;
            end
        end
    end

    function uitable_scan_create()
        % Create the table that lists the scans.
        UI_obj.main.scans.Properties.VariableNames = {'Scan name', '#', 'Emin', 'Emax', 'Color'};
        UI_obj.main.scans.uitable                  = uitable(UI_obj.main.uifigure , "ColumnName", UI_obj.main.scans.Properties.VariableNames, "Position",[10 40 430 190]);
        UI_obj.main.scans.uitable.CellEditCallback = @uitable_scan_user_edit;
        UI_obj.main.scans.uitable.CellSelectionCallback = {@uitable_scan_user_select, 2};
        UI_obj.main.scans.uitable.ColumnEditable   = [true false false false, false];
        UI_obj.main.scans.uitable.ColumnWidth      = {200, 40, 50, 50, 50};
        UI_obj.main.scans.uitable.ColumnFormat     = {'char', 'numeric', 'numeric', 'numeric', 'char'};
    end

    function uitable_scan_user_edit(hObj, event)
        % Write the changed values into the data struct:
        scan_int_names   = fieldnames(exp_data.scans);
        if event.Indices(2) == 1 % Name change
            % % Make sure the name is valid:
            % NewName = general.make_valid_name(event.NewData, 'sp');
            NewName = event.NewData; % No name restrictions anymore
            % Check if the name is not already in use: 
            scan_usernames = GUI.fs_big.get_user_scannames(exp_data.scans);
            if ~isempty(NewName) && ~any(ismember(fieldnames(exp_data.scans), NewName))
                % Current internal name:
                cur_int_name    = scan_int_names{event.Indices(1)};
                % Write the new name:
                exp_data.scans.(cur_int_name).Name  = NewName;
                % Update the table:
                UI_obj.main.scans.uitable.Data = compose_uitable_scan_spectrum_Data('scans');
            else % New name not accepted, no change of name:
                hObj.Data{event.Indices(1), event.Indices(2)}            = event.PreviousData;
            end
        end
    end
    

    function uitable_scan_user_select(hObj, event, selection)
        % If the user wants to change the color of the scan/spectrum (relevant in later plots):
        switch selection 
            case 1 % Spectra/um to be removed:
            d_name = 'spectra';
            columnr_color = 2;
            case 2
            d_name = 'scans';
            columnr_color = 5;
        end
         % Callback to update the requested plot line color.
        if ~isempty(hObj.Selection) && all(unique(hObj.Selection(:,2)) == columnr_color) % Only column 2 selected.
            switch unique(hObj.Selection(2))
                case columnr_color % The user wants to change the color of the line. TODO.
                        % Get the current color:
                        scan_names      = fieldnames(exp_data.(d_name));
                        username_active_scan        = UI_obj.main.(d_name).uitable.Data{hObj.Selection(1,1)};
                        intname_active_scan         = GUI.fs_big.get_intname_from_username(exp_data.(d_name), username_active_scan);
                        current_color_RGB_cell      = exp_data.(d_name).(intname_active_scan{:}).Color;
                        % Call the color picker to let the user set a new color:
                        newColorRGB                 = uisetcolor(current_color_RGB_cell);
                        
                        for  i = 1:size(hObj.Selection, 1)% Possibly more than one scan needs to be re-colored:
                            % Write the new RGB value into the settings:
                            UI_obj.main.(d_name).uitable.Data{hObj.Selection(i,1), hObj.Selection(i,2)} = regexprep(num2str(round(newColorRGB,1)),'\s+',',');
                            exp_data.(d_name).(intname_active_scan{:}).Color = newColorRGB;
                        end

                        % Change the color of the cell to the newly selected one:
                        s = uistyle('BackgroundColor', newColorRGB);
                        addStyle(UI_obj.main.(d_name).uitable, s, 'cell', hObj.Selection);
            end
        end
    end

    function uitable_spectra_create()
        % Create the table that lists the scans.
        UI_obj.main.spectra.Properties.VariableNames = {'Spectrum name', 'Color'};
        UI_obj.main.spectra.uitable                  = uitable(UI_obj.main.uifigure , "ColumnName", UI_obj.main.spectra.Properties.VariableNames, "Position",[10 250 430 190]);
        UI_obj.main.spectra.uitable.CellEditCallback = @uitable_spectra_user_edit;
        UI_obj.main.spectra.uitable.CellSelectionCallback = {@uitable_scan_user_select, 1};
        UI_obj.main.spectra.uitable.ColumnWidth     = {250, 200};
        UI_obj.main.spectra.uitable.ColumnEditable   = [true true];
        UI_obj.main.spectra.uitable.ColumnFormat{1}  = {'char'};
        UI_obj.main.spectra.uitable.ColumnFormat{2} = {'char'};
    end

    function uitable_spectra_user_edit(~, event)
        % Write the changed values into the data struct:
        spectra_names   = fieldnames(exp_data.spectra);
        if event.Indices(2) == 1 % Name change
            exp_data.spectra.(spectra_names{event.Indices(1)}) = event.NewData;
        end
    end

    function uitable_scan_modify()
        % Modify the table that lists the scans.
        scan_names                              = fieldnames(exp_data.scans);
        for name_nr = 1:length(scan_names)
            name_cur = scan_names{name_nr};
            % Fetch the number of spectra for each sample:
            try settings.filelist.number_of_spectra{name_nr}           = length(fieldnames(exp_data.scans.(name_cur).hist));
            catch
                settings.filelist.number_of_spectra{name_nr} = 0;
            end
        end
        % Fill the metadata into the table:
        UI_obj.main.scans.uitable.Data                  = compose_uitable_scan_spectrum_Data('scans');
    end

    function [uitable_data] = compose_uitable_scan_spectrum_Data(uitable_type)
        % Fill the current data into a matrix ready to be fed to the table.
        switch uitable_type
            case 'scans' % The user wants the scan table to be updated:
                % Data_column_fieldnames : {'Scan name', '#', 'Emin', 'Emax', 'Color'};
                % The amount of scans defined:
                scan_names          = fieldnames(exp_data.scans);
                nof_scans           = numel(scan_names);
                uitable_data = cell(nof_scans, 5); % Initialize empty cell
                for i = 1:nof_scans
                    current_scan_name = scan_names{i};
                    uitable_data{i,1} = exp_data.scans.(current_scan_name).Name;
                    uitable_data{i,2} = length(exp_data.scans.(current_scan_name).Data.photon.energy);
                    uitable_data{i,3} = min(exp_data.scans.(current_scan_name).Data.photon.energy);
                    uitable_data{i,4} = max(exp_data.scans.(current_scan_name).Data.photon.energy);
                    uitable_data{i,5} = regexprep(num2str(round(exp_data.scans.(current_scan_name).Color,1)),'\s+',',');
                    % Draw background colors for the color cells:
                    s = uistyle('BackgroundColor', exp_data.scans.(current_scan_name).Color);
                    addStyle(UI_obj.main.scans.uitable, s, 'cell', [i,5]);
                end
            case 'spectra'
                % Data_column_fieldnames : {'Spectrum name', 'Color'};
                spectra_intnames    = fieldnames(exp_data.spectra);
                nof_spectra         = numel(spectra_intnames);
                uitable_data        = cell(nof_spectra, 2); % Initialize empty cell
                for i = 1:nof_spectra
                    current_spectrum_name = spectra_intnames{i};
                    uitable_data{i,1} = exp_data.spectra.(current_spectrum_name).Name;
                    uitable_data{i,2} = regexprep(num2str(round(exp_data.spectra.(current_spectrum_name).Color,1)),'\s+',',');
                    % Draw background colors for the color cells:
                    s = uistyle('BackgroundColor', exp_data.spectra.(current_spectrum_name).Color);
                    addStyle(UI_obj.main.spectra.uitable, s, 'cell', [i,2]);
                end
        end
    end

    function uitable_spectra_modify()
        % Modify the table that lists the spectra.
        % Fetch the usernames in a cell:
        spectra_usernames = GUI.fs_big.get_user_scannames(exp_data.spectra);
        % FIll the metadata into the table:
        UI_obj.main.spectra.uitable.Data             = compose_uitable_scan_spectrum_Data('spectra');
    end

% function [data_to_plot, metadata_to_plot, sample_names] = fetch_selected_scans()
%     % Check which run(s) are selected.
%     if isempty(fieldnames(exp_data.scans)) && isempty(fieldnames(exp_data.spectra))
%         msgbox('Please load and select the scan for which you want to define fragments.')
%     elseif isempty(UI_obj.main.scans.uitable.Selection)
%         % No data selected, All samples will be available in the plot interface:
%         sample_names    = fieldnames(exp_data.scans);
%         data_to_plot    = exp_data.scans;
%         metadata_to_plot = settings.metadata;
%     else
%         rownrs              = unique(UI_obj.main.scans.uitable.Selection(:,1));
%         data_to_plot        = struct();
%         table_sample_names  = UI_obj.main.scans.uitable.Data(:,1);
%         for sample_nr       = rownrs'
%             sample_name = table_sample_names{sample_nr};
%             % Add to list of experimental data:
%             data_to_plot.(sample_name)      = exp_data.scans.(sample_name);
%             metadata_to_plot.(sample_name)  = settings.metadata.(sample_name);
%         end 
%     end
% end
end
