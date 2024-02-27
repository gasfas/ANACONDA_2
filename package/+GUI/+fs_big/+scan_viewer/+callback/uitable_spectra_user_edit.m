function uitable_spectra_user_edit(~, event, GUI_settings)
   
% Get the variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

% Write the changed values into the data struct:
spectra_names   = fieldnames(exp_data.spectra);
if event.Indices(2) == 1 % Name change
    exp_data.spectra.(spectra_names{event.Indices(1)}) = event.NewData;
end

% Set the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data);

end