function load_scan_cancel_callback(~,~, GUI_settings)

% Get the variables from base workspace:
[GUI_settings, UI_obj] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

% Do nothing and close window.
set(UI_obj.load_scan.f_open_scan,'visible','off');

% Set the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj)
end
