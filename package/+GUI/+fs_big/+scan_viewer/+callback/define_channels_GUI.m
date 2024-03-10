function define_channels_GUI(~, ~, GUI_settings)
% This callback launches the define fragment windows.
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

% This function feeds the selected to the m2q plot function
if isempty(fieldnames(exp_data.scans)) 
    UI_obj.main.plot_scan.empty_data_plot_msgbox = msgbox('Cannot plot scans, since none are loaded yet. Nice try.');
else
    % If there is some data to plot, open the window to let the user select channels for the scan.
GUI.fs_big.plot_scan.start_define_channels(GUI_settings);
end

end