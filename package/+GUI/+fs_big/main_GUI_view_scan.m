function [exp_data, settings, defaults, UI_obj] = main_GUI_view_scan()
% GUI main view to load and visualize a Spektrolatius/Desirs/... scan

% Set some defaults:
defaults.load_scan.browse_dir       = 'D:\';
defaults.load_scan.browse_dir       = 'D:\DATA\2023\P04_Dec23\PETRA P04 2023_12\20231217\4-ABA\ABA_Oprot_O Kedge';
defaults.load_scan.setup_type       = 'Spektrolatius';
defaults.load_scan.tooltips.re_bin_factor       = 'The re-bin factor reduces the amount of (m2q) datapoints by calculating the average of every bunch of ''re-bin factor'' values.';
defaults.load_scan.tooltips.sample_name         = 'Fill in the name of the sample or run you are loading. For example: ""MetEnk_Desirs"" ';
defaults.load_scan.tooltips.Add_scan            = 'Load a set of files from disk to memory. The uniquely named scan will appear as a row in the table.';
defaults.load_scan.tooltips.Remove_scan         = 'Removes the selected table row(s) in the table from memory.';
defaults.load_scan.tooltips.Modify_scan         = 'Adapt an already-loaded scan, e.g. by adding or removing spectra or changing the name.';
defaults.load_scan.tooltips.plot_m2q            = 'Visualize the mass spectra of selected scan(s). If no scans are selected, all of them will be available.';
defaults.load_scan.tooltips.plot_scan           = 'Visualize the yields of selected scan(s). If no scans are selected, all of them will be considered.';
defaults.load_scan.tooltips.define_channels     = 'Select the fragments from an averaged mass spectru';
defaults.load_scan.tooltips.Save_workspace      = 'TODO Save the current workspace to disk, to be loaded at a later stage.';
defaults.load_scan.tooltips.Load_workspace      = 'TODO Load a previously used workspace from disk. Note that the currently loaded workspace will be cleared.';

defaults.load_scan.sample_number = 0; % Sample name
settings                            = struct(); % Setting in saved in struct
UI_obj                              = struct(); %All Ui objects stored in this struct.

% Set up the display
UI_obj.f_scan                       = uifigure('Name', 'Scan viewer','NumberTitle','off','position',[200 200 600 400]);

% Initiate the experiment struct:
exp_data                                = struct;
update_filelist_uitable()

% Initialize the interaction buttons (load, delete, view spectra):
UI_obj.main.Add_scan                = uibutton(UI_obj.f_scan, "Text", "Add scan", "Position", [480, 350, 100, 20], 'Tooltip', defaults.load_scan.tooltips.Add_scan, "ButtonPushedFcn", @load_scan_GUI);
UI_obj.main.Remove_scan             = uibutton(UI_obj.f_scan, "Text", "Remove scan", "Position", [480, 320, 100, 20], 'Tooltip', defaults.load_scan.tooltips.Remove_scan, "ButtonPushedFcn", @remove_scan_GUI);
UI_obj.main.Modify_scan             = uibutton(UI_obj.f_scan, "Text", "Modify scan", "Position", [480, 290, 100, 20], 'Tooltip', defaults.load_scan.tooltips.Modify_scan, "ButtonPushedFcn", @modify_scan_GUI);
UI_obj.main.plot_m2q.uibutton       = uibutton(UI_obj.f_scan, "Text", "Plot M/Q", "Position", [480, 260, 100, 20], 'Tooltip', defaults.load_scan.tooltips.plot_m2q, "ButtonPushedFcn", @plot_spectra_GUI);
UI_obj.main.plot_m2q.plot_scan       = uibutton(UI_obj.f_scan, "Text", "Plot scan", "Position", [480, 230, 100, 20], 'Tooltip', defaults.load_scan.tooltips.plot_scan, "ButtonPushedFcn", @define_channels);

UI_obj.main.Save_workspace.uibutton      = uibutton(UI_obj.f_scan, "Text", "Save workspace", "Position", [480, 140, 100, 20], 'Tooltip', defaults.load_scan.tooltips.Save_workspace);
UI_obj.main.Load_workspace.uibutton      = uibutton(UI_obj.f_scan, "Text", "Load workspace", "Position", [480, 110, 100, 20], 'Tooltip', defaults.load_scan.tooltips.Load_workspace);

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
    load_scan_window(sample_settings)
end

function modify_scan_GUI(~, ~)
    % The load scan function as run from 'Modify_scan'
    % Read which scan was selected:
    if length(fieldnames(exp_data)) == 0
        UI_obj.main.modify_scan.empty_data_msgbox = msgbox('Cannot modify scan, since there are no data files loaded yet. Nice try.');
    elseif isempty(UI_obj.main.uitable.Selection)
        UI_obj.main.modify_scan.no_data_selected_msgbox = msgbox('No data selected. Please select the sample you want to modify and try again.');
    else
        rownr              = unique(UI_obj.main.uitable.Selection(:,1));
        if length(rownr) > 1  % More than one selected to be modified
            UI_obj.main.modify_scan.no_data_selected_msgbox = msgbox('Please only select one sample you want to modify');
        else
            % Check which run (sample name) is selected.
            sample_selected    = UI_obj.main.uitable.Selection(1);
            % Read the metadata from that run:
            sample_name = settings.filelist.scan_name{sample_selected};
            selected_sample_settings = settings.metadata.(sample_name);
            % Remove the old exp data 
            exp_data        = rmfield(exp_data, settings.filelist.scan_name{sample_selected});
            % Also from the metadata:
            settings.metadata = rmfield(settings.metadata, settings.filelist.scan_name{sample_selected});
            % Then use the metadata as initial settings to load_scan_window and load the modified scan:
            load_scan_window(selected_sample_settings);
            
            % Update the table:
            update_filelist_uitable();
        end
    end
end

function load_scan_window(sample_settings)
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
    
    % Text of the filepath:
    UI_obj.LoadFilePath         = uitextarea(UI_obj.load_scan.f_open_scan, 'Value', sample_settings.csv_filelist, 'Position', [10, 50, 500, 220]);
    UI_obj.LoadFile_Browse_btn  = uibutton(UI_obj.load_scan.f_open_scan, "Text", "Browse", "Position", [10, 10, 80, 20], "ButtonPushedFcn", @get_filepath);
    UI_obj.LoadFile_Ok_btn      = uibutton(UI_obj.load_scan.f_open_scan, "Text", "Cancel", "Position", [410, 10, 80, 20], "ButtonPushedFcn", @load_scan_cancel_callback);
    UI_obj.LoadFile_Ok_btn      = uibutton(UI_obj.load_scan.f_open_scan, "Text", "Ok", "Position", [500, 10, 80, 20], "ButtonPushedFcn", @load_scan_OK_callback);
end

function remove_scan_GUI(~, ~)
    % Read which scan was selected:
    if length(fieldnames(exp_data)) == 0
        UI_obj.main.remove_scan.empty_data_msgbox = msgbox('Cannot remove data, since there are no data files loaded yet. Nice try.');
    elseif isempty(UI_obj.main.uitable.Selection)
        UI_obj.main.remove_scan.no_data_selected_msgbox = msgbox('No data selected. Please select the sample you want to remove and try again.');
    else
        rownrs              = unique(UI_obj.main.uitable.Selection(:,1));
        for sample_nr       = 1:length(rownrs)
            % Check which run is selected.
            sample_selected    = UI_obj.main.uitable.Selection(rownrs(sample_nr));
            % Remove from exp data 
            exp_data        = rmfield(exp_data, settings.filelist.scan_name{sample_selected});
        end
        % Update the table:
        update_filelist_uitable();
    end
end

function plot_spectra_GUI(~, ~)
    % This function feeds the selected to the m2q plot function
    if isempty(fieldnames(exp_data))
        UI_obj.main.plot_m2q.empty_data_plot_msgbox = msgbox('Cannot plot mass spectra, since there are no scans loaded yet. Nice try.');
    else
        % Find out which are the selected scans:
        [data_to_plot, metadata_to_plot] = fetch_selected_scans();
        % Send these selected spectra to mass spectrum plotter:
        GUI.fs_big.Plot_m2q(data_to_plot, metadata_to_plot);
    end
end

function define_channels(~, ~)
   % Check which scan is selected:
   if length(fieldnames(exp_data)) == 1% only one scan loaded, so no selection needed:
       selected_scan_nr = 1;
   elseif isempty(fieldnames(exp_data))
       UI_obj.main.plot_m2q.empty_data_plot_msgbox = msgbox('Cannot plot scans, since there are no scans loaded yet. Please do that first.');
       selected_scan_nr = [];
   else  % More than one scan loaded, so check whether any are selected to show first:
       try 
           selected_scan_nr = unique(UI_obj.main.uitable.Selection(:,1));
       catch
           selected_scan_nr = 1:length(fieldnames(exp_data)); % if no selection is made
       end
   end
   if ~isempty(selected_scan_nr)
       % Fetch the name of the selected scan:
       sample_name  = UI_obj.main.uitable.Data.Name{selected_scan_nr};
       % Open the window to let the user select channels for the scan.
       [defaults, settings, UI_obj] = GUI.fs_big.define_channels(defaults, settings, UI_obj, exp_data, selected_scan_nr);
   end
end

function plot_scan_GUI(~,~)
    if length(fieldnames(exp_data)) == 0
        UI_obj.main.plot_m2q.empty_data_plot_msgbox = msgbox('Cannot plot scans, since there are no scans loaded yet. Nice try.');
    else
        % Find out which are the selected scans:
        [data_to_plot, metadata_to_plot] = fetch_selected_scans();
        % Send these selected spectra to mass spectrum plotter:
        GUI.fs_big.Plot_scans(data_to_plot, metadata_to_plot);
    end 
end


function [data_to_plot, metadata_to_plot, sample_names] = fetch_selected_scans()
    % Check which run(s) are selected.
    if isempty(UI_obj.main.uitable.Selection)
        % No data selected, All samples will be available in the plot interface:
        sample_names    = fieldnames(exp_data);
        data_to_plot    = exp_data;
        metadata_to_plot = settings.metadata;
    else
        rownrs              = unique(UI_obj.main.uitable.Selection(:,1));
        data_to_plot        = struct();
        table_sample_names  = UI_obj.main.uitable.Data.Name;
        for sample_nr       = rownrs'
            sample_name = table_sample_names{sample_nr};
            % Add to list of experimental data:
            data_to_plot.(sample_name)      = exp_data.(sample_name);
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
    figure(UI_obj.load_scan.f_open_scan)
end

function load_scan_OK_callback(~, ~)
    % This function checks the inputs and, if approved, loads the requested
    % data to file.
    % First check the inputs:
    % Make sure the sample name does not yet exist:
    if isfield(exp_data, UI_obj.load_scan.sample_name.Value) || ~isvarname(UI_obj.load_scan.sample_name.Value)
        UI_obj.load_scan.duplicate_names_msgbox = msgbox(['Sample name ', UI_obj.load_scan.sample_name.Value, ' is either already in use, or an invalid name. Please choose another name.']);
    else % We assume the input is correct.
        % Load the files and place a new instance in the settings:
        % Read the re-bin factor 
        settings.load_scan.re_bin_factor = UI_obj.load_scan.re_bin_factor.Value;
        % Read the setup type:
        read_setup_type_radio()
        % Warning the user it might take a while:
        UI_obj.load_scan.loading_data_msgbox = msgbox('Loading the requested spectra. This might take a while');
        switch settings.load_scan.setup_type
            case 'Spektrolatius'
                sample_data = IO.SPECTROLATIUS_S2S.load_CSV_filelist(settings.load_scan.csv_filedir, settings.load_scan.csv_filelist , settings.load_scan.re_bin_factor);
                % Save the experimental data from this sample in the general
                % data directory:
                exp_data.([UI_obj.load_scan.sample_name.Value]) = sample_data;
                % Write the metadata of this sample in the settings:
                settings.metadata.([UI_obj.load_scan.sample_name.Value]).setup_type     = settings.load_scan.setup_type;
                settings.metadata.([UI_obj.load_scan.sample_name.Value]).re_bin_factor  = settings.load_scan.re_bin_factor;
                settings.metadata.([UI_obj.load_scan.sample_name.Value]).csv_filelist   = settings.load_scan.csv_filelist;
                settings.metadata.([UI_obj.load_scan.sample_name.Value]).csv_filedir    = settings.load_scan.csv_filedir;
                settings.metadata.([UI_obj.load_scan.sample_name.Value]).sample_name      = UI_obj.load_scan.sample_name.Value;
                % Update the table with the extra sample(s):
                update_filelist_uitable();
            case 'Desirs_LTQ'
                msgbox('TODO')
            otherwise
                msgbox('TODO')
        end
        % Closing the load spectrum window:
        set(UI_obj.load_scan.f_open_scan,'visible','off');
        % Closing the message box:
        set(UI_obj.load_scan.loading_data_msgbox, 'visible', 'off');
        figure(UI_obj.f_scan)
    end
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

function update_filelist_uitable()
    try 
        rmfield(UI_obj.main.uitable) % Remove old table, if present.
    end
    % Update the names:
    settings.filelist.scan_name             = fieldnames(exp_data);
    settings.filelist.number_of_spectra     = zeros(size(settings.filelist.scan_name));
    settings.filelist.photon_energy_min     = zeros(size(settings.filelist.scan_name));
    settings.filelist.photon_energy_max     = zeros(size(settings.filelist.scan_name));
    for name_nr = 1:length(settings.filelist.scan_name)
        name_cur = settings.filelist.scan_name{name_nr};
        % Fetch the number of spectra for each sample:
        try settings.filelist.number_of_spectra(name_nr)           = length(fieldnames(exp_data.(name_cur).hist));
        catch
            settings.filelist.number_of_spectra(name_nr) = 0;
        end
         % And the minimum and maximum photon energies:
         settings.filelist.photon_energy_min(name_nr)     = min(exp_data.(name_cur).photon.energy);
         settings.filelist.photon_energy_max(name_nr)     = max(exp_data.(name_cur).photon.energy);
    end
    UI_obj.main.t_filelist          = table(settings.filelist.scan_name, settings.filelist.number_of_spectra, settings.filelist.photon_energy_min, settings.filelist.photon_energy_max);
    UI_obj.main.t_filelist.Properties.VariableNames = {'Name', '# spectra', 'E min', 'E max'};
    UI_obj.main.uitable             = uitable(UI_obj.f_scan, "Data", UI_obj.main.t_filelist, "Position",[20 25 450 350]);
    UI_obj.main.uitable.ColumnEditable = [false false false false];
end

end