function Save_workspace(hObj, event, GUI_settings)
% Save all current variables to workspace for later use.
% The total workspace consists of the following variables:
% exp_data, GUI_settings

% Load the variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

try 
    scan_names                  = fieldnames(exp_data.scans);
    suggested_savename          = exp_data.scans.(scan_names{1}).Name;
    browse_dir                  = exp_data.scans.(scan_names{1}).metadata.IO.csv_filedir;
catch
    try 
        scan_names                  = fieldnames(exp_data.spectra);
        suggested_savename          = exp_data.spectra.(scan_names{1}).Name;
        browse_dir                  = exp_data.spectra.(scan_names{1}).metadata.IO.csv_filedir;
    catch 
        suggested_savename          = 'SP_workspace';
        browse_dir                  = pwd;
    end
end
[saveFile, savePath]  = uiputfile( '*.mat', 'Save workspace as', fullfile(browse_dir, [suggested_savename '.mat']));
if all([saveFile, savePath])
    save(fullfile(savePath, saveFile), 'exp_data', 'GUI_settings');
    % Update the tables:
    UI_obj.main.scans.uitable.Data                  = GUI.fs_big.scan_viewer.compose_uitable_scan_spectrum_Data('scans', UI_obj, exp_data);
    UI_obj.main.spectra.uitable.Data                = GUI.fs_big.scan_viewer.compose_uitable_scan_spectrum_Data('spectra', UI_obj, exp_data);
    % Main window up:
    figure(UI_obj.main.uifigure)
end
end