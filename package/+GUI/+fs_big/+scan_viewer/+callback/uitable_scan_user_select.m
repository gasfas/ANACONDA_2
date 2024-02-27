function uitable_scan_user_select(hObj, event, selection, GUI_settings)

% Get the variables from base workspace:
[GUI_settings2, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

    % If the user wants to change the color of the scan/spectrum (relevant in later plots):
    switch selection 
        case 1 % Spectra/um to be removed:
        d_name = 'spectra';
        columnr_color = 2;
        case 2
        d_name = 'scans';
        columnr_color = 5;
    end
     % Callback to update the requested plot line color.
    if ~isempty(hObj.Selection) && all(unique(hObj.Selection(:,2)) == columnr_color) % Only column 2 selected.
        switch unique(hObj.Selection(2))
            case columnr_color % The user wants to change the color of the line. TODO.
                    % Get the current color:
                    scan_names                  = fieldnames(exp_data.(d_name));
                    username_active_scan        = UI_obj.main.(d_name).uitable.Data{hObj.Selection(1,1)};
                    intname_active_scan         = GUI.fs_big.get_intname_from_username(exp_data.(d_name), username_active_scan);
                    current_color_RGB_cell      = exp_data.(d_name).(intname_active_scan{:}).Color;
                    % Call the color picker to let the user set a new color:
                    newColorRGB                 = uisetcolor(current_color_RGB_cell);
                    
                    for  i = 1:size(hObj.Selection, 1)% Possibly more than one scan needs to be re-colored:
                        % Write the new RGB value into the GUI_settings:
                        UI_obj.main.(d_name).uitable.Data{hObj.Selection(i,1), hObj.Selection(i,2)} = regexprep(num2str(round(newColorRGB,1)),'\s+',',');
                        exp_data.(d_name).(intname_active_scan{:}).Color = newColorRGB;
                    end

                    % Change the color of the cell to the newly selected one:
                    s = uistyle('BackgroundColor', newColorRGB);
                    addStyle(UI_obj.main.(d_name).uitable, s, 'cell', hObj.Selection);
        end
    end


% Set the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)

end