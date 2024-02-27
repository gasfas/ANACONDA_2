function [GUI_settings] = read_setup_type_radio(GUI_settings, UI_obj)
    % Find which setup the user has chosen:
    i = 0; found = false;
    while ~ found 
        i = i + 1;
        if UI_obj.setup_bg.Children(i).Value
            found = true; % Found the selected spectrometer. Write in GUI_settings:
            GUI_settings.load_scan.setup_type = UI_obj.setup_bg.Children(i).Text;
        end
    end
end