function modify_scan_GUI(~, ~, GUI_settings)

% Get the variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

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
            sample_intscanname_selected         = GUI.fs_big.get_intname_from_username(exp_data.scans, sample_userscanname_selected);
            % Read the metadata from that run:
            selected_sample_GUI_settings        = exp_data.scans.(sample_intscanname_selected{:}).metadata.IO;
            % Overwrite the load_scan metadata with that from the selected scan:
            GUI_settings.load_scan              = general.struct.catstruct(GUI_settings.load_scan, exp_data.scans.(sample_intscanname_selected{:}).metadata.IO);
            GUI_settings.load_scan.is_scan      = true;
            GUI_settings.load_scan.Color        = exp_data.scans.(sample_intscanname_selected{:}).Color;
            % Then use the metadata as initial GUI_settings to load_scan_window and load the modified scan:
            [GUI_settings, UI_obj]              = GUI.fs_big.load_scan.load_scan_window(GUI_settings, sample_userscanname_selected{:}, UI_obj, true);
        end
    end
    % Update the tables:
    GUI.fs_big.scan_viewer.uitable_scan_modify(UI_obj, exp_data);
    GUI.fs_big.scan_viewer.uitable_spectra_modify(UI_obj, exp_data);

% Set the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj)
end
