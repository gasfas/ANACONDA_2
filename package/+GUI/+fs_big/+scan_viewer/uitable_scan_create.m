function UI_obj = uitable_scan_create(GUI_settings, UI_obj)
% Create an emtpy uitable for the scans.

% Create the table that lists the scans.
UI_obj.main.scans.Properties.VariableNames = {'Scan name', '#', 'Emin', 'Emax', 'Color'};
UI_obj.main.scans.uitable                  = uitable(UI_obj.main.uifigure, "ColumnName", UI_obj.main.scans.Properties.VariableNames, "Position",[10 40 440 190]);
UI_obj.main.scans.uitable.CellEditCallback = {@GUI.fs_big.scan_viewer.callback.uitable_scan_spectra_user_edit, GUI_settings, 'scans'};
UI_obj.main.scans.uitable.CellSelectionCallback = {@GUI.fs_big.scan_viewer.callback.uitable_scan_user_select, 2, GUI_settings};
UI_obj.main.scans.uitable.ColumnEditable   = [true false false false, false];
UI_obj.main.scans.uitable.ColumnWidth      = {180, 30, 50, 50, 80};
UI_obj.main.scans.uitable.ColumnFormat     = {'char', 'numeric', 'numeric', 'numeric', 'char'};

end