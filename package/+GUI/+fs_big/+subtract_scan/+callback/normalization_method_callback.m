function normalization_method_callback(hObj, event, GUI_settings)
% This callback function updates the  dropdown list that determines the 
% normalization method.

% Fetch the variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

switch event.NewValue.Text
    case 'Channel' 
        switch general.struct.issubfield(GUI_settings, 'channels.list')
            case true
                % User wants to see a channel, so make the dropdown list appear to choose which channel:        
                UI_obj.normalize.Channel_choose_label               = uilabel(UI_obj.normalize.main, 'Text', 'Channel:', 'Position', [150, 70, 100, 15]);
                UI_obj.normalize.Channel_choose_dropdown            = uidropdown(UI_obj.normalize.main, ...
                    'Items', GUI.fs_big.get_user_names(GUI_settings.channels.list), 'Position', [150, 45, 130, 20]);
            otherwise
                msgbox('No channels defined. Please define in ''plot_scan'' window first.')
        end
    otherwise % Hide the channel dropdown if the usre does not want the channel normalization method:
        if isfield(UI_obj.normalize, 'Channel_choose_dropdown')
            UI_obj.normalize.Channel_choose_dropdown.Visible    = 'off';
            UI_obj.normalize.Channel_choose_label.Visible       = 'off';
        end
end

% Update the suggested name:
GUI.fs_big.normalize_scan.callback.data_dropdown_callback(GUI_settings, GUI_settings, GUI_settings);

% Write the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end