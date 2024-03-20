function copy_data_check_callback(~, event, action_type, GUI_settings)
% This callback function updates the  dropdown list that determines the 
% normalization method. 
% Inputs: 
%   action_type         char, either 'normalize', or 'subtract'

% Fetch the variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

% Hide the output name if the user wants to overwrite the data :
if event.Value % User wants to overwrite the data, so no need for the output name:
    UI_obj.(action_type).data_output_name.Visible           = 'on';
else
    UI_obj.(action_type).data_output_name.Visible           = 'off';
end

% Write the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end