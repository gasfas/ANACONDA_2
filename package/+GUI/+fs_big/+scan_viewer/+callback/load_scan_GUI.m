function load_scan_GUI(~, ~, GUI_settings)
% The load scan function as run from clicking the 'Add' button.
[GUI_settings, UI_obj] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

GUI_settings.load_scan.sample_name     = ['sample', num2str(GUI_settings.load_scan.sample_number)];
GUI_settings.load_scan.re_bin_factor   = 1;
GUI_settings.load_scan.csv_filelist    = GUI_settings.load_scan.browse_dir;
GUI_settings.load_scan.setup_type      = GUI_settings.load_scan.setup_type;
GUI_settings.load_scan.is_scan         = false;

% Set sample name:
GUI_settings.load_scan.sample_number = GUI_settings.load_scan.sample_number + 1;
GUI_settings.load_scan.sample_name  = ['sample', num2str(GUI_settings.load_scan.sample_number)];
defaultusername                 = GUI_settings.load_scan.sample_name;

% create the load scan window:
[GUI_settings, UI_obj] = GUI.fs_big.load_scan.load_scan_window(GUI_settings, defaultusername, UI_obj, false);

% Write the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj)

end