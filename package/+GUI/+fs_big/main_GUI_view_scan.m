function [exp_data, settings, defaults, UI_obj] = main_GUI_view_scan()
% GUI main view to load and visualize a Spektrolatius/Desirs/... scan

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

defaults.load_scan.tooltips.Add        = 'Load a spectrum (or scan of spectra) from disk to memory. The spectrum name will appear as a row in the table.';
defaults.load_scan.tooltips.Remove_spectrum     = 'Removes the selected spectrum/spectra in the table from memory.';
defaults.load_scan.tooltips.Modify_spectrum     = 'Adapt an already-loaded scan, e.g. by adding or removing spectra or changing the name.';
defaults.load_scan.sample_number = 0; % Sample name
is_scan_loaded                                  = false;

% [settings, defaults] = GUI.fs_big.edit_settings(settings, defaults);

settings                            = struct(); % Settings saved in struct
UI_obj                              = struct(); %All Ui objects stored in this struct.

% Set up the display, Initiate the uifigure:
UI_obj.main.uifigure                 = uifigure('Name', 'Scan viewer','NumberTitle','off','position',[100 100 590 470]);

% Initiate the experiment struct:
exp_data                                = struct('scans', struct(), 'spectra', struct());


% Create the uitable containing the list of scans:
uitable_scan_create();
uitable_spectra_create();

% Initialize the interaction buttons for the spectra:
UI_obj.main.Add                         = uibutton(UI_obj.main.uifigure, "Text", "Add", "Position", [480, 430, 100, 20], 'Tooltip', defaults.load_scan.tooltips.Add, "ButtonPushedFcn", @load_scan_GUI);
UI_obj.main.Remove_spectrum             = uibutton(UI_obj.main.uifigure, "Text", "Remove spectrum", "Position", [480, 400, 100, 20], 'Tooltip', defaults.load_scan.tooltips.Remove_spectrum, "ButtonPushedFcn", @remove_spectrum_GUI);
UI_obj.main.Modify_spectrum             = uibutton(UI_obj.main.uifigure, "Text", "Modify spectrum", "Position", [480, 370, 100, 20], 'Tooltip', defaults.load_scan.tooltips.Modify_spectrum, "ButtonPushedFcn", @modify_spectrum_GUI);

% Initialize the interaction buttons (load, delete, view spectra) for the
% scan:
UI_obj.main.Remove_scan             = uibutton(UI_obj.main.uifigure, "Text", "Remove scan", "Position", [480, 170, 100, 20], 'Tooltip', defaults.load_scan.tooltips.Remove_scan, "ButtonPushedFcn", @remove_scan_GUI);
UI_obj.main.Modify_scan             = uibutton(UI_obj.main.uifigure, "Text", "Modify scan", "Position", [480, 140, 100, 20], 'Tooltip', defaults.load_scan.tooltips.Modify_scan, "ButtonPushedFcn", @modify_scan_GUI);
UI_obj.main.plot_m2q.uibutton       = uibutton(UI_obj.main.uifigure, "Text", "Plot M/Q", "Position", [480, 110, 100, 20], 'Tooltip', defaults.load_scan.tooltips.plot_m2q, "ButtonPushedFcn", @plot_spectra_GUI);

UI_obj.main.plot_scan.uibutton= uibutton(UI_obj.main.uifigure, "Text", "Plot scan", "Position", [480, 80, 100, 20], 'Tooltip', defaults.load_scan.tooltips.plot_scan, "ButtonPushedFcn", @define_channels);

UI_obj.main.Save_workspace.uibutton      = uibutton(UI_obj.main.uifigure, "Text", "Save workspace", "Position", [10, 10, 100, 20], 'Tooltip', defaults.load_scan.tooltips.Save_workspace);
UI_obj.main.Load_workspace.uibutton      = uibutton(UI_obj.main.uifigure, "Text", "Load workspace", "Position", [120, 10, 100, 20], 'Tooltip', defaults.load_scan.tooltips.Load_workspace);

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
    % Set sample name:
    defaults.load_scan.sample_number = defaults.load_scan.sample_number + 1;
    defaults.load_scan.sample_name = ['sample', num2str(defaults.load_scan.sample_number)];
    sample_settings.sample_name     = defaults.load_scan.sample_name;
    % create the load scan window:
    load_scan_window(sample_settings);
end

function modify_scan_GUI(~, ~)
    % The load scan function as run from 'Modify_scan'
    % Read which scan was selected:
    if isempty(fieldnames(exp_data))
        UI_obj.main.modify_scan.empty_data_msgbox = msgbox('Cannot modify scan, since there are no data files loaded yet. Nice try.');
    elseif isempty(UI_obj.main.scan.uitable.Selection)
        UI_obj.main.modify_scan.no_data_selected_msgbox = msgbox('No data selected. Please select the sample you want to modify and try again.');
    else
        rownr              = unique(UI_obj.main.scan.uitable.Selection(:,1));
        if length(rownr) > 1  % More than one selected to be modified
            UI_obj.main.modify_scan.no_data_selected_msgbox = msgbox('Please only select one sample you want to modify');
        else
            % Check which run (sample name) is selected.
            sample_selected    = UI_obj.main.scan.uitable.Selection(1);
            % Read the metadata from that run:
            sample_name = settings.filelist.scan_name{sample_selected};
            selected_sample_settings = settings.metadata.(sample_name);
            % Then use the metadata as initial settings to load_scan_window and load the modified scan:
            is_scan_loaded = load_scan_window(selected_sample_settings);
            if is_scan_loaded
                % Update the table:
                uitable_scan_modify();            % Remove the old exp data 
                exp_data        = rmfield(exp_data, settings.filelist.scan_name{sample_selected});
                % Also from the metadata:
                settings.metadata = rmfield(settings.metadata, settings.filelist.scan_name{sample_selected});
                % If the scan has not been modified, no action.
            end
        end
    end
end

    function [is_scan_loaded] = load_scan_window(sample_settings)
        % Feedback whether a file has been loaded:
        is_scan_loaded = false;
        UI_obj.load_scan.f_open_scan = uifigure('Name', 'Add scan',...
            'NumberTitle','off','position',[200 250 600 400]);
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
        UI_obj.load_scan.sample_name = uieditfield(UI_obj.load_scan.f_open_scan, 'Value', sample_settings.sample_name, 'Tooltip', defaults.load_scan.tooltips.sample_name, 'Position', [200, 350, 100, 30]);
        
        % re-bin factor:
        UI_obj.load_scan.re_bin_text = uilabel(UI_obj.load_scan.f_open_scan, 'Text', 're-bin factor', 'Position', [200, 325, 70, 30]);
        UI_obj.load_scan.re_bin_factor = uieditfield(UI_obj.load_scan.f_open_scan,"numeric", 'Value', sample_settings.re_bin_factor, 'Tooltip', defaults.load_scan.tooltips.re_bin_factor, 'Position', [200, 300, 50, 30]);
        
        % scan or individual spectra:
        % Radio button to choose type of spectrometer:
        % Let the user decide which kind of experiment is done:
        UI_obj.isscan         = uibuttongroup(UI_obj.load_scan.f_open_scan,'Title', 'Data type', 'Tooltip', defaults.load_scan.tooltips.Data_type_radio, 'Position',[320 300 140 80]);
        UI_obj.isscanfields.rb_individual_spectra   = uiradiobutton(UI_obj.isscan,'Text', 'spectra', 'Position',[10 38 91 15]);
        UI_obj.isscanfields.rb_scan                 = uiradiobutton(UI_obj.isscan,'Text', 'scan', 'Position',[10 16 91 15]);

        % Text of the filepath:
        UI_obj.LoadFilePath         = uitextarea(UI_obj.load_scan.f_open_scan, 'Value', sample_settings.csv_filelist, 'Position', [10, 50, 500, 220]);
        UI_obj.LoadFile_Browse_btn  = uibutton(UI_obj.load_scan.f_open_scan, "Text", "Browse", "Position", [10, 10, 80, 20], "ButtonPushedFcn", @get_filepath);
        UI_obj.LoadFile_Cancel_btn  = uibutton(UI_obj.load_scan.f_open_scan, "Text", "Cancel", "Position", [410, 10, 80, 20], "ButtonPushedFcn", @load_scan_cancel_callback);
        UI_obj.LoadFile_Ok_btn      = uibutton(UI_obj.load_scan.f_open_scan, "Text", "Ok", "Position", [500, 10, 80, 20], "ButtonPushedFcn", @load_scan_OK_callback);
    end

function remove_scan_GUI(~, ~)
    % Read which scan was selected:
    if isempty(fieldnames(exp_data.scans))
        UI_obj.main.remove_scan.empty_data_msgbox = msgbox('Cannot remove data, since there are no data files loaded yet. Nice try.');
    elseif isempty(UI_obj.main.scan.uitable.Selection)
        UI_obj.main.remove_scan.no_data_selected_msgbox = msgbox('No data selected. Please select the sample you want to remove and try again.');
    else
        rownrs              = unique(UI_obj.main.scan.uitable.Selection(:,1));
        for sample_nr       = 1:length(rownrs)
            % Check which run is selected.
            sample_selected    = UI_obj.main.scan.uitable.Selection(rownrs(sample_nr));
            % Remove from exp data 
            exp_data        = rmfield(exp_data, settings.filelist.scan_name{sample_selected});
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
        % Find out which are the selected scans:
        [data_to_plot] = fetch_selected_scans();
        % Send these selected spectra to mass spectrum plotter:
        [defaults, UI_obj] = GUI.fs_big.Plot_m2q(data_to_plot, defaults, UI_obj);
    end
end

function define_channels(~, ~)
   % Check which scan is selected:
   if length(fieldnames(exp_data)) == 1% only one scan loaded, so no selection needed:
       selected_scan_nr = 1;
   elseif isempty(fieldnames(exp_data)) % No scans loaded yet, so no scan plot possible:
       selected_scan_nr = [];
   else
       try selected_scan_nr = unique(UI_obj.main.scan.uitable.Selection(:,1)); % Check which scans are selected (if any)
       catch selected_scan_nr = 1:length(fieldnames(exp_data)); % if no selection is made, return emtpy nr array.
       end
   end
   
   if isempty(selected_scan_nr)
       msgbox('Please load and select the scan for which you want to define fragments.')
   else
       % Fetch the name of the selected scan:
       sample_name  = UI_obj.main.scan.uitable.Data{selected_scan_nr,1};
       % Open the window to let the user select channels for the scan.
       [defaults, settings, UI_obj] = GUI.fs_big.define_channels(defaults, settings, UI_obj, exp_data, sample_name);
   end
end

function [data_to_plot, metadata_to_plot, sample_names] = fetch_selected_scans()
    % Check which run(s) are selected.
    if isempty(UI_obj.main.scan.uitable.Selection)
        % No data selected, All samples will be available in the plot interface:
        sample_names    = fieldnames(exp_data.scans);
        data_to_plot    = exp_data.scans;
        metadata_to_plot = settings.metadata;
    else
        rownrs              = unique(UI_obj.main.scan.uitable.Selection(:,1));
        data_to_plot        = struct();
        table_sample_names  = UI_obj.main.scan.uitable.Data(:,1);
        for sample_nr       = rownrs'
            sample_name = table_sample_names{sample_nr};
            % Add to list of experimental data:
            data_to_plot.(sample_name)      = exp_data.scans.(sample_name);
            metadata_to_plot.(sample_name)  = settings.metadata.(sample_name);
        end 
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
        [filelist, settings.load_scan.csv_filedir] = uigetfile('.csv', 'Select all spectra that are part of the scan', defaults.load_scan.browse_dir, 'MultiSelect', 'on');
        if iscell(filelist) % Multiple files selected:
            settings.load_scan.csv_filelist = filelist;
            % Close the load_file dialog:
            % Sort the filelist by photon energy. Fetch list of photon energies:
            photon_energy_list_unordered = IO.SPECTROLATIUS_S2S.fetch_photon_energy_csv_namelist(filelist);
            % Then sort by ascending order:
            [~, ordering_idx] = sort(photon_energy_list_unordered);
            filelist = filelist(ordering_idx);
            UI_obj.LoadFilePath.Value = filelist;
        elseif ischar(filelist) % only one file selected
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
    % First check the inputs:
    % Make sure the sample name does not yet exist:
    if isfield(exp_data.scans, UI_obj.load_scan.sample_name.Value) || ~isvarname(UI_obj.load_scan.sample_name.Value)
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
        
        % Load the files to memory, method depends on the spectrometer:
        switch settings.load_scan.setup_type
            case 'Spektrolatius'
                switch UI_obj.isscanfields.rb_individual_spectra.Value
                    case true % Individual spectra (not a scan) loaded:
                        % Save the experimental data from this sample in the general data directory:
                        if ischar(settings.load_scan.csv_filelist)
                            exp_data.spectra.([UI_obj.load_scan.sample_name.Value]) = IO.SPECTROLATIUS_S2S.load_CSV_filelist(settings.load_scan.csv_filedir, settings.load_scan.csv_filelist , settings.load_scan.re_bin_factor);
                        else 
                            % Load the files one by one and store them
                            % in separate spectra files:
                            for spectr_nr = 1:length(settings.load_scan.csv_filelist)
                                spectr_name_cur = general.make_valid_name(settings.load_scan.csv_filelist{spectr_nr});
                                exp_data.spectra.(spectr_name_cur)  = IO.SPECTROLATIUS_S2S.load_CSV_filelist(settings.load_scan.csv_filedir, settings.load_scan.csv_filelist{spectr_nr} , settings.load_scan.re_bin_factor);
                            end
                        end
                    case false % A scan is loaded, so save the files in exp_data.scans:
                        exp_data.scans.([UI_obj.load_scan.sample_name.Value])  = IO.SPECTROLATIUS_S2S.load_CSV_filelist(settings.load_scan.csv_filedir, settings.load_scan.csv_filelist , settings.load_scan.re_bin_factor);
                end
               
                % Write the metadata of this sample in the settings:
                settings.metadata.([UI_obj.load_scan.sample_name.Value]).setup_type     = settings.load_scan.setup_type;
                settings.metadata.([UI_obj.load_scan.sample_name.Value]).re_bin_factor  = settings.load_scan.re_bin_factor;
                settings.metadata.([UI_obj.load_scan.sample_name.Value]).csv_filelist   = settings.load_scan.csv_filelist;
                settings.metadata.([UI_obj.load_scan.sample_name.Value]).csv_filedir    = settings.load_scan.csv_filedir;
                settings.metadata.([UI_obj.load_scan.sample_name.Value]).sample_name      = UI_obj.load_scan.sample_name.Value;
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
        set(UI_obj.load_scan.loading_data_msgbox, 'visible', 'off');
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
        UI_obj.main.scan.Properties.VariableNames = {'Scan name', '# spectra', 'E min', 'E max'};
        UI_obj.main.scan.uitable                  = uitable(UI_obj.main.uifigure , "ColumnName", UI_obj.main.scan.Properties.VariableNames, "Position",[10 40 430 190]);
        UI_obj.main.scan.uitable.CellEditCallback = @uitable_scan_user_edit;
        UI_obj.main.scan.uitable.ColumnEditable   = [true false false false];
        UI_obj.main.scan.uitable.ColumnFormat     = {'char', 'numeric', 'numeric', 'numeric'};
    end

    function uitable_scan_user_edit(~, event)
        % Write the changed values into the data struct:
        scan_names   = fieldnames(exp_data.scans);
        if event.Indices(2) == 1 % Name change
            % Make the new field with new name:
            exp_data.scans.(event.NewData)      = exp_data.scans.(scan_names{event.Indices(1)});
            settings.metadata.(event.NewData)   = settings.metadata.(scan_names{event.Indices(1)});
            % remove old name:
            exp_data.scans                      = rmfield(exp_data.scans, scan_names{event.Indices(1)});
            settings.metadata                   = rmfield(settings.metadata, (scan_names{event.Indices(1)}));
        end
    end

    function uitable_spectra_create()
        % Create the table that lists the scans.
        UI_obj.main.spectra.Properties.VariableNames = {'Spectrum name', 'Type'};
        UI_obj.main.spectra.uitable                  = uitable(UI_obj.main.uifigure , "ColumnName", UI_obj.main.spectra.Properties.VariableNames, "Position",[10 250 430 190]);
        UI_obj.main.spectra.uitable.CellEditCallback = @uitable_spectra_user_edit;
        UI_obj.main.spectra.uitable.ColumnEditable   = [true true];
        UI_obj.main.spectra.uitable.ColumnFormat{1}  = {'char'};
        UI_obj.main.spectra.uitable.ColumnFormat{2} = {'ESI_only', 'no_ESI', 'background', 'none'};
    end

    function uitable_spectra_user_edit(~, event)
        % Write the changed values into the data struct:
        spectra_names   = fieldnames(exp_data.spectra);
        if event.Indices(2) == 1 % Name change
            exp_data.spectra.(spectra_names{event.Indices(1)}) = event.NewData;
        elseif event.Indices(2) == 2 % type change
            exp_data.spectra.(spectra_names{event.Indices(1)}).type = event.NewData;
        end
    end

    function uitable_scan_modify()
        % Modify the table that lists the scans.
        % First fetch the up-to-date info on the spectra:
        settings.filelist.scan_name             = fieldnames(exp_data.scans);
        settings.filelist.photon_energy_min     = cell(length(settings.filelist.scan_name),1);
        settings.filelist.photon_energy_max     = cell(length(settings.filelist.scan_name),1);
        settings.filelist.number_of_spectra     = cell(length(settings.filelist.scan_name),1);
        for name_nr = 1:length(settings.filelist.scan_name)
            name_cur = settings.filelist.scan_name{name_nr};
            % Fetch the number of spectra for each sample:
            try settings.filelist.number_of_spectra{name_nr}           = length(fieldnames(exp_data.scans.(name_cur).hist));
            catch
                settings.filelist.number_of_spectra{name_nr} = 0;
            end
             % And the minimum and maximum photon energies:
             settings.filelist.photon_energy_min{name_nr}     = min(exp_data.scans.(name_cur).photon.energy);
             settings.filelist.photon_energy_max{name_nr}     = max(exp_data.scans.(name_cur).photon.energy);
        end
        % FIll the metadata into the table:
        UI_obj.main.scan.uitable.Data             = [settings.filelist.scan_name, settings.filelist.number_of_spectra settings.filelist.photon_energy_min, settings.filelist.photon_energy_max];
    end

    function uitable_spectra_modify()
        % Modify the table that lists the spectra.
        % First fetch the up-to-date info on the spectra:
        settings.filelist.spectra_name          = fieldnames(exp_data.spectra);
        % FIll the metadata into the table:
        UI_obj.main.spectra.uitable.Data             = [settings.filelist.spectra_name, cell(size(settings.filelist.spectra_name))];
        C = cell(size(settings.filelist.spectra_name));
        C(:) = {'none'};
        UI_obj.main.spectra.uitable.Data             = [settings.filelist.spectra_name, C];
    end

end