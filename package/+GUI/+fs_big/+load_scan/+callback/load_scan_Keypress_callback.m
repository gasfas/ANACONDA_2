function load_scan_Keypress_callback(~, event, GUI_settings)

% If the user presses return (enter), it is equivalent to clicking 'OK'
if strcmp(event.Key, 'return')
    GUI.fs_big.load_scan.callback.load_scan_OK_callback(GUI_settings, GUI_settings, GUI_settings);
end


end