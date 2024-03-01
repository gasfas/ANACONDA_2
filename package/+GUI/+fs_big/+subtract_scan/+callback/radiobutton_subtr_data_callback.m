function radiobutton_subtr_data_callback(hObj, event, GUI_settings)
% This callback function updates the  dropdown list depending whether the
% user chooses to subtract with scan or spectrum.

% Fetch the variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);


switch event.NewValue.Text
    case 'Spectrum'
        dropdown_list = GUI.fs_big.get_user_names(exp_data.spectra);
    case 'Scan'
        dropdown_list = GUI.fs_big.get_user_names(exp_data.scans);
end

UI_obj.subtract.dropdown_dataselection_subtr.Items = dropdown_list;


% Write the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end