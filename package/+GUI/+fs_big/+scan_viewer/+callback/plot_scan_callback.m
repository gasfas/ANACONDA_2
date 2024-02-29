function plot_scan_callback(~, ~, GUI_settings)
% This callback launches the scan plot windows.

% Open the window to let the user select channels for the scan.
GUI.fs_big.plot_scan.start_plot_scan(GUI_settings);

end