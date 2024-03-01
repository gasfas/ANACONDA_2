function cancel_callback(hObj, event, GUI_settings)
% This function cancels the normalization routine
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

% Close the UI, as requested:
delete(UI_obj.normalize.main)
end