function radiobutton_subtr_data_callback(hObj, event, GUI_settings)
% This callback function updates the  dropdown list depending whether the
% user chooses to subtract with scan or spectrum.

% Fetch the variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

switch event.NewValue.Text
    case 'Spectrum'
        datatype = 'spectra';
        dropdown_list = GUI.fs_big.get_user_names(exp_data.spectra);
    case 'Scan'
    if UI_obj.subtract.radioswitch_spectrum.Value % We read the current value of the input data.
        % If it is a spectrum, we cannot subtract a spectrum with a scan
        msgbox('Cannot subtract a spectrum with a scan. Automatic reset to subtracting with spectrum'); % we return to spectrum settings:
        UI_obj.subtract.radioswitch_subtr_spectrum.Value = true;
        dropdown_list = GUI.fs_big.get_user_names(exp_data.spectra);
        datatype = 'spectra';
    else % Subtracting scan by scan is possible:
         dropdown_list = GUI.fs_big.get_user_names(exp_data.scans);
        datatype = 'scans';
    end
end

UI_obj.subtract.dropdown_dataselection_subtr.Items = dropdown_list;

% Suggest a new name for the output spectrum/scan name:
GUI.fs_big.subtract_scan.callback.data_subtr_dropdown_callback(hObj, event, GUI_settings)

% Write the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end