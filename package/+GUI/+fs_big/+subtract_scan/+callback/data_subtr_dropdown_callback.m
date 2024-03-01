function data_subtr_dropdown_callback(~, ~, GUI_settings)
% This callback function is called upon a change in dropdown selection of the data to subtract with.

% Fetch the variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

% Update the suggested save name:
if  UI_obj.subtract.radioswitch_subtr_spectrum.Value
    postfix = '_sSp';
elseif UI_obj.subtract.radioswitch_subtr_scan.Value
    postfix = '_sSc';
end

data_selected = UI_obj.subtract.dropdown_dataselection.Value;

UI_obj.subtract.data_output_name.Value = [data_selected postfix];

% Write the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end