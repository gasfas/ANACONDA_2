function start_subtract(GUI_settings)
% Fetch variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

% Define the tooltips:
GUI_settings.subtract.tooltips.main                          = 'subtracting either a scan or spectrum. The subtracted data will be added as one of the scans or spectra.';
GUI_settings.subtract.tooltips.radioswitch_spectrum_scan     = 'Would you like to subtract a single spectrum, or multiple spectra in a scan?';
GUI_settings.subtract.tooltips.dropdown_data_choose          = 'Pick the spectrum or scan you would want to subtract';
GUI_settings.subtract.tooltips.subtraction_method          = ['Choose subtraction data: ' ...
    '''Spectrum'' subtracts all intensity points (of all spectra in a scan) by the intensity of a spectrum, ' ...
    '''Scan'' subtracts all intensity points of all spectra in a scan with the intensity of spectra in another scan. Note that this option only works when the scan energies of the subtracting scan overlap the subtracted scan range.'];
GUI_settings.subtract.tooltips.subtract          = 'Generate a subtracted spectrum/scan with the above specified preferences.';
GUI_settings.subtract.tooltips.cancel             = 'Generate a new spectrum/scan with the above specified preferences.';
GUI_settings.subtract.default_data_output_name    = 'Example_normalized';

% Define the uifigure:
UI_obj.subtract.main         = uifigure('Name', 'Subtract data','NumberTitle','off', ...
                            'Position',[50 50 300 200]);

% Define the buttons and their callbacks:

% Dropdown menu to choose the scan or spectrum to subtract from:
UI_obj.subtract.dropdown_dataselection = uidropdown(UI_obj.subtract.main, 'Items', {}, ...
        'Position', [10, 100, 120, 25], 'ValueChangedFcn', {@GUI.fs_big.subtract_scan.callback.data_dropdown_callback, GUI_settings});

% Dropdown menu to choose the scan or spectrum to subtract with:
UI_obj.subtract.dropdown_dataselection_subtr = uidropdown(UI_obj.subtract.main, 'Items', {}, ...
        'Position', [150, 100, 120, 25], 'ValueChangedFcn', {@GUI.fs_big.subtract_scan.callback.data_subtr_dropdown_callback, GUI_settings});

% Let the user choose through radiobutton which kind of data should be normalized:
UI_obj.subtract.radioswitch_spectrum_scan  = uibuttongroup(UI_obj.subtract.main,'Title', 'Data type', 'Position',[10 130 120 60], ...
                                            'CreateFcn', {@GUI.fs_big.subtract_scan.callback.choose_spectrum_scan_createcallback, GUI_settings, UI_obj}, ...
                                            'SelectionChangedFcn',{@GUI.fs_big.subtract_scan.callback.radiobutton_data_callback, GUI_settings}, ...
                                            'Tooltip', GUI_settings.subtract.tooltips.radioswitch_spectrum_scan);
UI_obj.subtract.radioswitch_spectrum       = uiradiobutton(UI_obj.subtract.radioswitch_spectrum_scan,'Text', 'Spectrum', 'Position',[10 20 91 15]);
UI_obj.subtract.radioswitch_scan           = uiradiobutton(UI_obj.subtract.radioswitch_spectrum_scan,'Text', 'Scan', 'Position',[10 5 91 15]);

UI_obj.subtract.radioswitch_subtraction_data        = uibuttongroup(UI_obj.subtract.main,'Title', 'Subtraction data', 'Position',[150 130 120 60], ...
                                                      'CreateFcn', {@GUI.fs_big.subtract_scan.callback.choose_subtr_spectrum_scan_createcallback, GUI_settings, UI_obj}, ...
                                                      'SelectionChangedFcn',{@GUI.fs_big.subtract_scan.callback.radiobutton_subtr_data_callback, GUI_settings}, ...
                                                      'Tooltip', GUI_settings.subtract.tooltips.subtraction_method);
UI_obj.subtract.radioswitch_subtr_spectrum          = uiradiobutton(UI_obj.subtract.radioswitch_subtraction_data,'Text', 'Spectrum', 'Position',[10 20 91 15]);
UI_obj.subtract.radioswitch_subtr_scan              = uiradiobutton(UI_obj.subtract.radioswitch_subtraction_data,'Text', 'Scan', 'Position',[10 5 91 15]);

% YScale and offset definition:
UI_obj.subtract.minuend.offset_label        = uilabel(UI_obj.subtract.main, 'Text', 'dY:', 'Position', [10, 80, 50, 15]);
UI_obj.subtract.minuend.offset_edit         = uieditfield(UI_obj.subtract.main, 'numeric', 'Position',  [40, 80, 50, 15]);

UI_obj.subtract.minuend.scale_label         = uilabel(UI_obj.subtract.main, 'Text', 'Scale:', 'Position', [10, 60, 50, 15]);
UI_obj.subtract.minuend.scale_edit          = uieditfield(UI_obj.subtract.main, 'numeric', 'Position', [40, 60, 50, 15]);

UI_obj.subtract.subtrahend.offset_label     = uilabel(UI_obj.subtract.main, 'Text', 'dY:', 'Position', [150, 80, 50, 15]);
UI_obj.subtract.subtrahend.offset_edit      = uieditfield(UI_obj.subtract.main, 'numeric', 'Position', [190, 80, 50, 15]);

UI_obj.subtract.subtrahend.scale_label      = uilabel(UI_obj.subtract.main, 'Text', 'Scale:', 'Position', [150, 60, 50, 15]);
UI_obj.subtract.subtrahend.scale_edit       = uieditfield(UI_obj.subtract.main, 'numeric', 'Position', [190, 60, 50, 15]);

UI_obj.subtract.subtract                          = uibutton(UI_obj.subtract.main, "Text", "Subtract", "Position", [200, 10, 80, 20], ...
                                                "ButtonPushedFcn", {@GUI.fs_big.subtract_scan.callback.subtract_callback, GUI_settings}, ...
                                                'Tooltip', GUI_settings.subtract.tooltips.subtract);



UI_obj.subtract.copy_data                          = uicheckbox(UI_obj.subtract.main, 'Value', true, 'Text', 'Data output:', ...
                                                    'ValueChangedFcn', {@GUI.fs_big.normalize_scan.callback.copy_data_check_callback, 'subtract', GUI_settings}, ...
                                                    'Position', [15, 35, 120, 15], 'Tooltip', GUI_settings.normalize.tooltips.copy_data);
UI_obj.subtract.data_output_name                   = uieditfield(UI_obj.subtract.main, 'Value', GUI_settings.subtract.default_data_output_name, 'Position', [10, 10, 150, 20]);


% Write the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)

% Set whether a scan or spectrum are default ticked (depending what is
% loaded in workspace):
if ~isempty(fieldnames(exp_data.spectra))
    UI_obj.subtract.radioswitch_spectrum.Value = true;
    UI_obj.subtract.dropdown_dataselection.Items = GUI.fs_big.get_user_names(exp_data.spectra);
else
    UI_obj.subtract.radioswitch_scan.Value = true;
    UI_obj.subtract.dropdown_dataselection.Items = GUI.fs_big.get_user_names(exp_data.scans);
end
if ~isempty(fieldnames(exp_data.spectra))
    UI_obj.subtract.radioswitch_subtr_spectrum.Value = true;
    UI_obj.subtract.dropdown_dataselection_subtr.Items = GUI.fs_big.get_user_names(exp_data.spectra);
else
    UI_obj.subtract.radioswitch_subtr_scan.Value = true;
    UI_obj.subtract.dropdown_dataselection_subtr.Items = GUI.fs_big.get_user_names(exp_data.scans);
end

% Set the correct initial dY, offset values:
GUI.fs_big.subtract_scan.callback.data_dropdown_callback(GUI_settings, GUI_settings, GUI_settings);
GUI.fs_big.subtract_scan.fetch_Scale_Offset(UI_obj.subtract.dropdown_dataselection_subtr.Value, 'spectra', UI_obj.subtract.subtrahend.offset_edit, UI_obj.subtract.subtrahend.scale_edit, GUI_settings)

end