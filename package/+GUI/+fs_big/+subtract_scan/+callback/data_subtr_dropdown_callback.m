function data_subtr_dropdown_callback(~, ~, GUI_settings)
% This callback function is called upon a change in dropdown selection of the data to subtract with.

% Fetch the variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

% Update the suggested save name:
if  UI_obj.subtract.radioswitch_subtr_spectrum.Value
    datatype = 'spectra';
    postfix = '_sSp';
elseif UI_obj.subtract.radioswitch_subtr_scan.Value
    datatype = 'scans';
    postfix = '_sSc';
end

data_selected = UI_obj.subtract.dropdown_dataselection.Value;

if ~isempty(data_selected)
    UI_obj.subtract.data_output_name.Value = [data_selected postfix];
end

data_name = GUI.fs_big.get_intname_from_username(exp_data.(datatype), UI_obj.subtract.dropdown_dataselection_subtr.Value);

if ~isempty(data_name)
    % Write the offset and scale values into the editfields for input data:
    GUI.fs_big.subtract_scan.fetch_Scale_Offset(UI_obj.subtract.dropdown_dataselection_subtr.Value, datatype, UI_obj.subtract.subtrahend.offset_edit, UI_obj.subtract.subtrahend.scale_edit, GUI_settings)
else
    msgbox(['No ' datatype ' loaded to workspace (for subtrahend)']); % we return to scan settings:
    % Reseting to the other datatype:
    switch datatype
        case 'scans'
            UI_obj.subtract.radioswitch_subtr_spectrum.Value  = true;
        case 'spectra'
            UI_obj.subtract.radioswitch_subtr_scan.Value      = true;
    end
end

% Write the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end