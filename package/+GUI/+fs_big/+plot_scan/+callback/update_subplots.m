function update_subplots(hObj, event, GUI_settings)
% Overwrite the current subplot with a new one:
% Fetch the variables from base workspace:
[GUI_settings, UI_obj] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

delete(UI_obj.plot_scan.subplot.fig)
% Draw subplots
GUI.fs_big.plot_scan.callback.draw_subplots(GUI_settings, GUI_settings, GUI_settings);

% Fetch the variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

UI_obj.plot_scan.refresh_subplots = uicontrol(UI_obj.plot_scan.subplot.fig, 'style','push',  'units','pix', ...
        'position',[10 10 25 25], 'fontsize',12, 'String','↻', ...
        'Tooltip', 'Refresh the plots', 'callback',{@GUI.fs_big.plot_scan.callback.update_subplots, GUI_settings});

% Set the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end

