function is_success = data_dropdown_callback(~, ~, GUI_settings)
% This callback function is called upon a change in dropdown selection.

% Fetch the variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

% Update the suggested save name:
if  UI_obj.subtract.radioswitch_subtr_spectrum.Value
    postfix = '_sSp';
elseif UI_obj.subtract.radioswitch_subtr_scan.Value
    postfix = '_sSc';
end
% Write the new suggested name:
data_selected = UI_obj.subtract.dropdown_dataselection.Value;
if ~isempty(data_selected)
    UI_obj.subtract.data_output_name.Value = [data_selected postfix];
end

% Check if the data is actually available (spectrum or scan):
if  UI_obj.subtract.radioswitch_spectrum.Value
    data_min_type = 'spectra';
elseif UI_obj.subtract.radioswitch_scan.Value
    data_min_type = 'scans';
end
% Check (if any) what data is available:
data_name = GUI.fs_big.get_intname_from_username(exp_data.(data_min_type), UI_obj.subtract.dropdown_dataselection.Value);

is_success = false;
if ~isempty(data_name)
    % Write the offset and scale values into the editfields for input data:
    GUI.fs_big.subtract_scan.fetch_Scale_Offset(UI_obj.subtract.dropdown_dataselection.Value, data_min_type, UI_obj.subtract.minuend.offset_edit, UI_obj.subtract.minuend.scale_edit, GUI_settings)
    is_success = true;
else
    if numel(fieldnames(exp_data.(data_min_type))) == 0
        msgbox(['No ' data_min_type ' loaded to workspace (for minuend)']); % we return to scan settings:
        % Reseting to the other datatype:
        switch data_min_type
            case 'scans'
                UI_obj.subtract.radioswitch_spectrum.Value  = true;
            case 'spectra'
                UI_obj.subtract.radioswitch_scan.Value      = true;
        end
    else
        is_success = true;
    end
end

% Write the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data);
end