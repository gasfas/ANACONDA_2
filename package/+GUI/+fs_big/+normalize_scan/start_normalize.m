function start_normalize(GUI_settings)
% Fetch variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

% Define the tooltips:
GUI_settings.normalize.tooltips.main                          = 'Normalizing either a scan or spectrum. The normalized data will be added as one of the scans or spectra.';
GUI_settings.normalize.tooltips.radioswitch_spectrum_scan     = 'Would you like to normalize a single spectrum, or multiple spectra in a scan?';
GUI_settings.normalize.tooltips.dropdown_data_choose          = 'Pick the spectrum or scan you would want to normalize';
GUI_settings.normalize.tooltips.normalization_method          = ['Choose normalization method: ' ...
    '''Channel'' divides all intensity by the integrated intensity of a channel (e.g. defining the parent), ' ...
    '''Maximum'' scales the entire spectrum so that the maximum becomes equal to zero.' ...
    '''Total'' integrates the entire mass spectrum and divides all intensity by that.'];
GUI_settings.normalize.tooltips.Normalize          = 'Generate a new spectrum/scan with the above specified preferences.';
GUI_settings.normalize.tooltips.cancel             = 'Generate a new spectrum/scan with the above specified preferences.';
GUI_settings.normalize.default_data_output_name    = 'Example_normalized';
GUI_settings.normalize.tooltips.View_flux                   = 'Plot the photon flux as a function of photon energy (in case of scan), or show the flux number (in case of spectrum)';
GUI_settings.normalize.tooltips.View_PD_current             = 'Plot the measured photodiode current as a function of photon energy (in case of scan), or show the Photodiode current (in case of spectrum)';


% Define the uifigure:
UI_obj.normalize.main         = uifigure('Name', 'Normalize data','NumberTitle','off', ...
                            'Position',[50 50 300 180]);

% Define the buttons and their callbacks:

% Dropdown menu to choose the scan or spectrum to normalize:
UI_obj.normalize.dropdown_dataselection = uidropdown(UI_obj.normalize.main, 'Items', {}, ...
        'Position', [10, 80, 120, 25], 'ValueChangedFcn', {@GUI.fs_big.normalize_scan.callback.data_dropdown_callback, GUI_settings});

% Let the user choose through radiobutton which kind of data should be normalized:
UI_obj.normalize.radioswitch_spectrum_scan  = uibuttongroup(UI_obj.normalize.main,'Title', 'Data type', 'Position',[10 110 120 60], ...
                                            'CreateFcn', {@GUI.fs_big.normalize_scan.callback.choose_spectrum_scan_createcallback, GUI_settings, UI_obj}, ...
                                            'SelectionChangedFcn',{@GUI.fs_big.normalize_scan.callback.choose_spectrum_scan_callback, GUI_settings}, ...
                                            'Tooltip', GUI_settings.normalize.tooltips.radioswitch_spectrum_scan);
UI_obj.normalize.radioswitch_spectrum       = uiradiobutton(UI_obj.normalize.radioswitch_spectrum_scan,'Text', 'Spectrum', 'Position',[10 20 91 15]);
UI_obj.normalize.radioswitch_scan           = uiradiobutton(UI_obj.normalize.radioswitch_spectrum_scan,'Text', 'Scan', 'Position',[10 5 91 15]);

UI_obj.normalize.radioswitch_normalization_method   = uibuttongroup(UI_obj.normalize.main,'Title', 'Normalization method', 'Position',[150 80 140 90], ...
                                                      'SelectionChangedFcn',{@GUI.fs_big.normalize_scan.callback.normalization_method_callback, GUI_settings}, ...
                                                      'Tooltip', GUI_settings.normalize.tooltips.normalization_method);
UI_obj.normalize.radioswitch_norm_maximum           = uiradiobutton(UI_obj.normalize.radioswitch_normalization_method,'Text', 'Maximum', 'Position',[10 50 91 15]);
UI_obj.normalize.radioswitch_norm_channel           = uiradiobutton(UI_obj.normalize.radioswitch_normalization_method,'Text', 'Channel', 'Position',[10 35 91 15]);
UI_obj.normalize.radioswitch_norm_total             = uiradiobutton(UI_obj.normalize.radioswitch_normalization_method,'Text', 'Total', 'Position',[10 20 91 15]);
UI_obj.normalize.radioswitch_norm_photon_flux       = uiradiobutton(UI_obj.normalize.radioswitch_normalization_method,'Text', 'Photon flux', 'Position',[10 5 91 15]);

UI_obj.normalize.Normalize                          = uibutton(UI_obj.normalize.main, "Text", "Normalize", "Position", [200, 10, 80, 20], ...
                                                "ButtonPushedFcn", {@GUI.fs_big.normalize_scan.callback.normalize_callback, GUI_settings}, ...
                                                'Tooltip', GUI_settings.normalize.tooltips.Normalize);
% 
% UI_obj.normalize.Cancel                             = uibutton(UI_obj.normalize.main, "Text", "✕", "Position", [10, 10, 80, 20], ...
%                                                 "ButtonPushedFcn", {@GUI.fs_big.normalize_scan.callback.cancel_callback, GUI_settings}, ...
%                                                 'Tooltip', GUI_settings.normalize.tooltips.cancel);

UI_obj.normalize.data_output_name_label             = uilabel(UI_obj.normalize.main, 'Text', 'Output:', 'Position', [10, 35, 100, 15]);
UI_obj.normalize.data_output_name                   = uieditfield(UI_obj.normalize.main, 'Value', GUI_settings.normalize.default_data_output_name, 'Position', [10, 10, 150, 20]);

% Write the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)

end