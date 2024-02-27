function uitable_scan_user_edit(hObj, event, GUI_settings)
   
% Get the variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

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


% Set the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data);
end
