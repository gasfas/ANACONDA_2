function uitable_scan_spectra_user_edit(hObj, event, GUI_settings, uitable_type)
% Table (name) edit on either the scan or spectrum uitable.

% uitable_type is either 'scans' or 'spectra'

% Get the variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

% Write the changed values into the data struct:
if event.Indices(2) == 1 % Name change
    NewName = event.NewData;
    cur_int_names   = fieldnames(exp_data.(uitable_type));
    % Make sure the name is unique and valid:
    if GUI.fs_big.isemptyname(exp_data, NewName)
        % Current internal name:
        cur_int_name    = cur_int_names{event.Indices(1)};
        % Write the new name:
        exp_data.(uitable_type).(cur_int_name).Name  = NewName;
        % Update the tables:
        GUI.fs_big.scan_viewer.uitable_scan_modify(UI_obj, exp_data);
        GUI.fs_big.scan_viewer.uitable_spectra_modify(UI_obj, exp_data);
    else % New name not accepted, no change of name:
        hObj.Data{event.Indices(1), event.Indices(2)}            = event.PreviousData;
    end
end

% Set the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data);

end