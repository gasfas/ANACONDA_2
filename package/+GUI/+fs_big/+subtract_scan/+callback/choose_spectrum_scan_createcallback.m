function choose_spectrum_scan_createcallback(hObj, event, GUI_settings, UI_obj)
% This callback function updates the  dropdown list depending whether the
% user chooses the scans or spectra to normalize on.

% Fetch the variables from base workspace:
[~, ~, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

% Initial value is on 'Spectrum', so we show the available spectra upon startup:
UI_obj.subtract.dropdown_dataselection.Items = GUI.fs_big.get_user_names(exp_data.spectra);

% Write the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end