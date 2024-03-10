function radiobutton_data_callback(hObj, event, GUI_settings)
% This callback function updates the  dropdown list depending whether the
% user chooses the scans or spectra to normalize on.

% Fetch the variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

is_success = GUI.fs_big.subtract_scan.callback.data_dropdown_callback(hObj, event, GUI_settings);

if is_success
    % Write the new values for the spectra (Yscale, offset, suggested name):
    switch event.NewValue.Text
        case 'Spectrum'
            dropdown_list = GUI.fs_big.get_user_names(exp_data.spectra);
            if UI_obj.subtract.radioswitch_subtr_scan.Value && ~isempty(dropdown_list) % We read the current value of the subtracting data.
                % If it is a scan, we cannot subtract a spectrum with a scan:
                msgbox('Cannot subtract a spectrum with a scan. Automatic reset to subtracting with spectrum'); % we return to scan settings:
                UI_obj.subtract.radioswitch_subtr_spectrum.Value = true;
            end
        case 'Scan'
            dropdown_list = GUI.fs_big.get_user_names(exp_data.scans);
    end

    % List the filenames in the options:
    UI_obj.subtract.dropdown_dataselection.Items = dropdown_list;
end

% Suggest a name for the output spectrum/scan name:
GUI.fs_big.subtract_scan.callback.data_dropdown_callback(hObj, event, GUI_settings);

% Write the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end