function data_dropdown_callback(~, ~, GUI_settings)
% This callback function is called upon a change in dropdown selection.

% Fetch the variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

% Update the suggested save name:
if  UI_obj.normalize.radioswitch_norm_maximum.Value
    postfix = '_nM';
elseif UI_obj.normalize.radioswitch_norm_channel.Value
    postfix = '_nC';
elseif UI_obj.normalize.radioswitch_norm_total.Value
    postfix = '_nT';
elseif UI_obj.normalize.radioswitch_norm_photon_flux.Value
    postfix = '_nP';
end

data_selected = UI_obj.normalize.dropdown_dataselection.Value;
if isempty(data_selected)
    data_selected = 'example_name';
end

UI_obj.normalize.data_output_name.Value = [data_selected postfix];

% Write the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end