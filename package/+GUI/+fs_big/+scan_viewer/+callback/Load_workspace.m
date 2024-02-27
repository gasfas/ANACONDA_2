function Load_workspace(hObj, event, GUI_settings)
    % User wishes to load previously-loaded workspace
   
    % Get the variables from base workspace:
    [~, UI_obj] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

    % Open a dialog to select the .mat file:
    [filename, filedir] = uigetfile('*.mat', 'Select the workspace file you wish to load', GUI_settings.load_scan.browse_dir);
    if all([filename, filedir])
        % Load the variables:
        load(fullfile(filedir, filename), 'exp_data', 'GUI_settings')
        % Update the tables:
        UI_obj.main.scans.uitable.Data                  = GUI.fs_big.scan_viewer.compose_uitable_scan_spectrum_Data('scans', UI_obj, exp_data);
        UI_obj.main.spectra.uitable.Data                = GUI.fs_big.scan_viewer.compose_uitable_scan_spectrum_Data('spectra', UI_obj, exp_data);
        % Main window up:
        figure(UI_obj.main.uifigure)
        % TODO: determine sample_number
    end

% Set the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)

end